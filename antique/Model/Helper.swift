//
//  Helper.swift
//  A small collection of quick helpers to avoid repeating the same old code.
//
//  Created by Paul Hudson on 23/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
    
    func readOrders(orderDate: Date = Date()) -> [CodableOrder]{
        do {
            let format = DateFormatter()
            format.dateFormat = "yyyy/MMM/dd"
            
            let day = format.string(from: orderDate)
            
            let fileManager = FileManager.default
            
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let folderURL = directory.appendingPathComponent(day)

            let orderFiles = try fileManager.contentsOfDirectory(atPath: folderURL.path)
            
            var orders = [CodableOrder]()
            for orderFile in orderFiles {
                let data = try Data(contentsOf: folderURL.appendingPathComponent(orderFile))
                let orderDTO = try JSONDecoder().decode(CodableOrderDTO.self, from: data)
                let codableOrder = CodableOrder(orderDTO)
                orders.append(codableOrder)
            }
            return orders.sorted(by: {$0.orderNo < $1.orderNo})
        } catch {
            print(error)
            return [CodableOrder]()
        }
    }
    
    func saveOrder(orderToEncode: CodableOrder) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let fileURL = saveFileName()
        
        do {
            let data = try encoder.encode(orderToEncode)
            FileManager.default.createFile(atPath: fileURL, contents: data, attributes: nil)
        } catch {
            print(error)
        }
    }
    
    func updateOrder(order: CodableOrder) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let docsDir = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        let dirPath = docsDir.appendingPathComponent(date(directory: true, forDate: order.date))
        
        let fileURL = dirPath?.appendingPathComponent(date(directory: false, forDate: order.date)).appendingPathExtension("json")

        if FileManager.default.fileExists(atPath: fileURL!.path) {
            do {
                let data = try encoder.encode(order)
                try data.write(to: fileURL!)
            } catch {
                print(error)
            }
        }
    }
        
    // Returns the save file name along with path to folder of day
    func saveFileName() -> String {
        let docsDir = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        let dirPath = docsDir.appendingPathComponent(date(directory: true))
        
        
        if(!FileManager.default.fileExists(atPath: dirPath!.path)) {
            do {
                try FileManager.default.createDirectory(atPath: dirPath!.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        let fileName = dirPath!.path + "/" + date(directory: false) + ".json"
        
        return fileName
    }
    
    func date(directory: Bool, forDate: Date = Date()) -> String {
        let format = DateFormatter()
        if(directory) {
            format.dateFormat = "yyyy/MMM/dd"
        } else {
            format.dateFormat = "yyyy-MM-dd hh:mm:ss"
        }
        return format.string(from: forDate)
    }
    
    func getDocumentsDirectory() -> URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            return URL(fileURLWithPath: "")
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

