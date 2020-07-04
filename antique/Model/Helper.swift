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
    
    func readMenu() -> [MenuSection] {
        let menuFileName = getMenuFileName()
        do {
            if FileManager.default.fileExists(atPath: menuFileName) {
                let data = try Data(contentsOf: URL(fileURLWithPath: menuFileName))
                let menuSections = try JSONDecoder().decode([MenuSection].self, from: data)
                return menuSections
            }
        } catch {
            print(error)
        }
        return [MenuSection]()
    }
    
    func updateMenu(menuSections: [MenuSection]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(menuSections)
            if FileManager.default.fileExists(atPath: getMenuFileName()) {
                try data.write(to: URL(fileURLWithPath: getMenuFileName()))
            } else {
                FileManager.default.createFile(atPath: getMenuFileName(), contents: data)
            }
        } catch {

        }
        
    }
    
    func getMenuFileName() -> String {
        let directory = getDocumentsDirectory()
        let fileName = "menu.json"
        return directory.appendingPathComponent(fileName).path
    }
    
    // Read orders from the given date's folder, will return EMPTY [CodableOrder] if no files or directory found.
    func readOrders(orderDate: Date = Date()) -> [CodableOrder]{
        do {
            let format = DateFormatter()
            format.dateFormat = "yyyy/MMM/dd"
            
            let day = format.string(from: orderDate)
            
            let fileManager = FileManager.default
            
            let directory = getDocumentsDirectory()
            
            let folderURL = directory.appendingPathComponent(day)

            let orderFiles = try fileManager.contentsOfDirectory(atPath: folderURL.path)
            
            var orders = [CodableOrder]()
            for orderFile in orderFiles {
                if orderFile != "cashout" {
                    let data = try Data(contentsOf: folderURL.appendingPathComponent(orderFile))
                    let orderDTO = try JSONDecoder().decode(CodableOrderDTO.self, from: data)
                    let codableOrder = CodableOrder(orderDTO)
                    orders.append(codableOrder)
                }
            }
            return orders.sorted(by: {$0.orderNo < $1.orderNo})
        } catch {
            return [CodableOrder]()
        }
    }
    
    func readMonthOrders(orderDate: Date = Date()) -> [CodableOrder] {
        do{
            let format = DateFormatter()
            format.dateFormat = "yyyy/MMM"
            
            let month = format.string(from: orderDate)
            
            let fileManager = FileManager.default
            
            let directory = getDocumentsDirectory()
            
            let monthFolderURL = directory.appendingPathComponent(month)
            
            let days = try fileManager.contentsOfDirectory(atPath: monthFolderURL.path)
            
            var monthOrders = [CodableOrder]()
            
            var date = DateComponents()
            format.dateFormat = "yyyy"
            date.year = Int(format.string(from: orderDate)) ?? 2020
            format.dateFormat = "MM"
            date.month = Int(format.string(from: orderDate)) ?? 1
            date.hour = 0
            date.minute = 0
            for day in days {
                date.day = Int(day)
                if date.day != nil {
                    monthOrders.append(contentsOf: readOrders(orderDate: Calendar.current.date(from: date)!))
                }
            }
            return monthOrders
        } catch {
            return [CodableOrder]()
        }
    }
    
    func readCashout(date: Date = Date()) -> [CodableCashout] {
        do {
            let format = DateFormatter()
            format.dateFormat = "yyyy/MMM/dd"
            
            let day = format.string(from: date)
            
            let fileManager = FileManager.default
            
            let directory = getDocumentsDirectory()
            
            let cashoutFolderURL = directory.appendingPathComponent(day).appendingPathComponent("cashout")
            
            let cashoutFiles = try fileManager.contentsOfDirectory(atPath: cashoutFolderURL.path)
            var cashouts = [CodableCashout]()
            for cashoutFile in cashoutFiles {
                    let data = try Data(contentsOf: cashoutFolderURL.appendingPathComponent(cashoutFile))
                    let cashout = try JSONDecoder().decode(CodableCashout.self, from: data)
                    cashouts.append(cashout)
            }
            return cashouts.sorted(by: {$0.date < $1.date})
        } catch {
            return [CodableCashout]()
        }
    }
    
    func readMonthCashouts(cashOutDate: Date = Date()) -> [CodableCashout] {
        do {
            let format = DateFormatter()
            format.dateFormat = "yyyy/MMM"
            
            let month = format.string(from: cashOutDate)
            
            let fileManager = FileManager.default
            
            let directory = getDocumentsDirectory()
            
            let monthFolderURL = directory.appendingPathComponent(month)
            
            let days = try fileManager.contentsOfDirectory(atPath: monthFolderURL.path)
            
            var monthCashouts = [CodableCashout]()
            
            var date = DateComponents()
            format.dateFormat = "yyyy"
            date.year = Int(format.string(from: cashOutDate)) ?? 2020
            format.dateFormat = "MM"
            date.month = Int(format.string(from: cashOutDate)) ?? 1
            date.hour = 0
            date.minute = 0
            for day in days {
                date.day = Int(day)
                if date.day != nil {
                    monthCashouts.append(contentsOf: readCashout(date: Calendar.current.date(from: date)!))
                }
            }
            return monthCashouts
        } catch {
            return [CodableCashout]()
        }
    }
    
    // Creates a cash out file
    func cashOut(_ cashOut: CodableCashout) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let fileManager = FileManager.default
        let docDir = getDocumentsDirectory()
        let currentDay = date(directory: true)
        let cashOutFolderName = "cashout"
        
        let cashOutDir = docDir.appendingPathComponent(currentDay).appendingPathComponent(cashOutFolderName).path
        
        do {
            // Check if directory exists
            if !fileManager.fileExists(atPath: cashOutDir) {
                try FileManager.default.createDirectory(atPath: cashOutDir, withIntermediateDirectories: true, attributes: nil)
            }
            let data = try encoder.encode(cashOut)
            let cashOutFileName = cashOutDir + "/" + date(directory: false) + ".json"
            fileManager.createFile(atPath: cashOutFileName, contents: data, attributes: nil)
        } catch {
            print(error)
        }
    }
    
    // Creates a new order file. Only call when creating new order
    func createOrder(orderToEncode: CodableOrder) {
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
    
    // Updates existing order in CodableOrder, the format stored in JSON files.
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
    
    func updateCashout(_ cashout: CodableCashout) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let docsDir = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        let dirPath = docsDir.appendingPathComponent(date(directory: true, forDate: cashout.date))
        
        let fileURL = dirPath?.appendingPathComponent("cashout").appendingPathComponent(date(directory: false, forDate: cashout.date)).appendingPathExtension("json")

        if FileManager.default.fileExists(atPath: fileURL!.path) {
            do {
                let data = try encoder.encode(cashout)
                try data.write(to: fileURL!)
            } catch {
                print(error)
            }
        }
    }
        
    // Returns the save file name along with path to folder of day
    private func saveFileName() -> String {
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
    
    private func date(directory: Bool, forDate: Date = Date()) -> String {
        let format = DateFormatter()
        if(directory) {
            format.dateFormat = "yyyy/MMM/dd"
        } else {
            format.dateFormat = "yyyy-MM-dd hh:mm:ss"
        }
        return format.string(from: forDate)
    }
    
    private func getDocumentsDirectory() -> URL {
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

