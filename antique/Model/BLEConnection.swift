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
    private var centralManager: CBCentralManager! = nil
    private var peripheral: CBPeripheral! = nil
    private var printingService: CBService!
    private var printingCharacteristic: CBCharacteristic!
    
    @Published var connected : Bool = false
    
    func startCentral() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Central Manager State: \(self.centralManager.state)")
    }
    
    // Handles BT Turning On/Off
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
            case .unsupported:
                print("BLE is Unsupported")
                self.connected = false
                break
            case .unauthorized:
                print("BLE is Unauthorized")
                self.connected = false
                break
            case .unknown:
                print("BLE is Unknown")
                self.connected = false
                break
            case .resetting:
                print("BLE is Resetting")
                self.connected = false
                break
            case .poweredOff:
                print("BLE is Powered Off")
                self.connected = false
                break
            case .poweredOn:
                print("Central scanning");
                self.centralManager.scanForPeripherals(withServices: nil)
                break
            default:
                print("State unknown")
                self.connected = false
        }
    }

    // Handles the result of the scan
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print(peripheral)

        // We've found it so stop scan
        self.centralManager.stopScan()
        
        // Copy the peripheral instance
        self.peripheral = peripheral
        if peripheral.name != nil {
            if peripheral.name == "BlueTooth Printer" {
                self.peripheral.delegate = self
                self.connected = true
                self.centralManager.connect(self.peripheral, options: nil)
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.peripheral = nil
        self.printingService = nil
        self.printingCharacteristic = nil
        self.connected = false
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(self.peripheral.name ?? "No Name")")
        self.peripheral.discoverServices(nil)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
          print(characteristic)
            if characteristic.uuid.uuidString == "BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F" {
                self.printingCharacteristic = characteristic
            }
        }
    }
    
    public func sendToPrinter(message: String) {
        let data = Data(message.utf8)
        let chunks = splitData(data: data)
        chunks.forEach{chunk in
            if peripheral != nil {
                peripheral.writeValue(chunk, for: self.printingCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
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
            print("Chunk size: " + String(chunk.count))
        }
        return chunks
    }
}
