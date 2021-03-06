//
//  BLEConnection.swift
//  antique
//
//  adapted from:
//      https://www.raywenderlich.com/231-core-bluetooth-tutorial-for-ios-heart-rate-monitor#toc-anchor-008
//      https://stackoverflow.com/questions/31353112/ios-corebluetooth-print-cbservice-and-cbcharacteristic
//      https://stackoverflow.com/questions/58239721/render-list-after-bluetooth-scanning-starts-swiftui
//
import Foundation
import UIKit
import CoreBluetooth

open class BLEConnection : NSObject, ObservableObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var printingService: CBService!
    private var printingCharacteristic: CBCharacteristic!
    
    @Published var connected : Bool = false
    @Published var scanning : Bool = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        disconnect()
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        }
        scanning = centralManager.isScanning
    }
    
    // Reset properties
    private func disconnect() {
        if self.peripheral != nil {
            centralManager.cancelPeripheralConnection(self.peripheral)
        }
        connected = false
        peripheral = nil
        printingService = nil
        printingCharacteristic = nil
        scanning = centralManager.isScanning
    }
    
    func stopScan() {
        centralManager.stopScan()
        scanning = centralManager.isScanning
        print(centralManager.isScanning)
    }
    
    // Handles BT Turning On/Off
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
            case .poweredOn:
                break
            case .unknown:
                print("unknown state")
            case .resetting:
                print("resetting")
            case .unsupported:
                print("unsupported")
            case .unauthorized:
                print("unauthorised")
            case .poweredOff:
                disconnect()
            @unknown default:
                disconnect()
        }
    }

    // Handles the result of the scan
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name != nil {
            // Only connect to this printer to avoid user error
            if peripheral.name == "BlueTooth Printer" {
                self.peripheral = peripheral
                peripheral.delegate = self
                centralManager.connect(self.peripheral, options: nil)
            }
        }
    }
    
    // Fail to connect
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("FAILED TO CONNECT: \(String(describing: error))")
        connected = false
        scanning = centralManager.isScanning
    }
    
    // Handles Connection
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "")")
        connected = true
        peripheral.discoverServices(nil)
        scanning = centralManager.isScanning
    }
    
    // On Disconnect
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        disconnect()
    }

    // Search for characteristic
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    // Discover Characteristics
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            // Printing characteristic
            if characteristic.uuid.uuidString == "BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F" {
                printingCharacteristic = characteristic
                stopScan()
            }
        }
    }
    
    // Convert incoming text to bytes (20 byte chunks) and send to printer.
    public func sendToPrinter(message: String) {
        let data = Data(message.utf8)
//        print(message.utf8)
//        print(data)
        let chunks = splitData(data: data)
        chunks.forEach { chunk in
            if peripheral != nil && printingCharacteristic != nil {
//                print("Chunk: \(chunk.description)")
                peripheral.writeValue(chunk, for: self.printingCharacteristic, type: .withoutResponse)
            } else {
                disconnect()
                print("disconnected")
            }
        }
    }
    
    // Splits the data object into 20 byte chunks to avoid overflowing the buffer
    private func splitData(data: Data) -> [Data] {
        var chunks = [Data]()
        let dataSize = data.count
        let chunkSize = 20
        let fullSizedChunks = dataSize / chunkSize
        let totalChunks = fullSizedChunks + (dataSize % chunkSize != 0 ? 1 : 0)
        
        for chunkCounter in 0..<totalChunks {
            var chunk : Data
            let chunkBase = chunkCounter * chunkSize
            var diff = chunkSize
            if chunkCounter == totalChunks - 1 {
                diff = dataSize - chunkBase
            }
            let range : Range<Data.Index> = chunkBase..<(chunkBase + diff)
            chunk = data.subdata(in: range)
            chunks.append(chunk)
        }
        return chunks
    }
}
