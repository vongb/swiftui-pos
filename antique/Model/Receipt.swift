//
//  Receipt.swift
//  antique
//
//  Created by Vong Beng on 9/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//  https://stackoverflow.com/questions/53769188/change-font-size-programmatically-on-thermal-bluetooth-printer

import Foundation

// Struct for receipt layout
struct Receipt {
    // Page width in number of characters
    // CHANGE DIVIDER COUNT WHEN PAGE WIDTH CHANGES
    let PAGE_WIDTH : Int = 32
    let divider = String(repeating: "-", count: 32) + "\n"
    
    // Difference of 3 to account for spaces between columns
    let ITEM_COL : Int = 12
    let U_PRICE_COL : Int = 6
    let QTY_COL : Int = 4
    let TOT_COL : Int = 8
    
    let SPACER : String = "\n\n\n"
    let WIFI_PASS : String = UserDefKeys.getWifiPassword()
    
    // Order to print
    let order : CodableOrder
    // Title Section
    // Name of Cafe (Centred)
    // Date (Left)
    // Time (Left)
    func title() -> String{
        let title = centre(msg: "ANTIQUE CAFE") + "\n\n"
        let tableNo = "Table Number: \(order.tableNo)\n"
        return title + tableNo
    }
    
    func header() -> String {
        let orderNo = "Order #" + String(order.orderNo) + "\n"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let date = "Date: " + dateFormatter.string(from: order.date) + "\n"
        dateFormatter.dateFormat = "hh:mm:ss"
        let time = "Time: " + dateFormatter.string(from: order.date) + "\n"
        return orderNo + date + time
    }
    
    // Body Section (Will split item names in 2 lines if too long for item column)
    // ITEM             QTY  Price
    // **Item List*
    func body() -> String {
        // Column Labels
        let bodyHeader =
            divider +
            self.pad(msg: "Item", totLength: ITEM_COL) + " " +
            self.pad(msg: "Price", totLength: U_PRICE_COL, padRight: false) +
            self.pad(msg: "Qty", totLength: QTY_COL, padRight: false) +
            self.pad(msg: "Total", totLength: TOT_COL, padRight: false) +
            "\n" + divider
        
        // Order items
        var body : String = ""
        self.order.items.forEach{orderItem in
            
            body += self.itemMultiLine(name: orderItem.item.name, unitPrice: orderItem.item.price, price: orderItem.total, qty: orderItem.qty)
            
            if orderItem.item.hasIceLevels {
                body += "Ice: " + orderItem.iceLevel + "\n"
            }
            
            if orderItem.item.hasSugarLevels {
                body += "Sugar: " + orderItem.sugarLevel + "\n"
            }
            
            if orderItem.item.canUpsize {
                if orderItem.upsized {
                    body += String(format: "Upsized ($%.02f ea)\n", orderItem.item.upsizePrice)
                }
            }
            
            if orderItem.specialDiscounted {
                body += String(format: "Discounted (-$%0.02f ea)\n", orderItem.item.specialDiscount)
            }
            
            body += "\n"
        }
        
        return bodyHeader + body
    }
    
    // Subtotal
    // Discounts
    // Total
    func totals() -> String {
        let REMAINING_SPACE = PAGE_WIDTH - ITEM_COL
        let subtotal = self.pad(msg: "Subtotal:", totLength: ITEM_COL) +
            self.pad(msg: String(format: "$%.02f", self.order.subtotal), totLength: REMAINING_SPACE, padRight: false) + "\n"
        let discount = self.pad(msg: "Discounts:", totLength: ITEM_COL) +
            self.pad(msg: "\(self.order.discountDisplay)", totLength: REMAINING_SPACE, padRight: false) + "\n"
        let grandTotal = self.pad(msg: "Grand Total:", totLength: ITEM_COL) +
            self.pad(msg: String(format: "$%.02f", self.order.total), totLength: REMAINING_SPACE, padRight: false) + "\n"
        return divider + subtotal + discount + grandTotal
    }
    
    // Footer Section
    // WiFi Password
    // Gratitude
    // Spacer for next receipt
    func footer() -> String{
        let footer = "WiFi Password: " + WIFI_PASS
        let gratitude = "Thank You, Please Come Again"
        
        return divider + centre(msg: footer) + centre(msg: gratitude)
    }
    
    // Checks if item name is longer than item column and splits it into 2 lines if necessary.
    func itemMultiLine(name: String, unitPrice: Double, price: Double, qty: Int) -> String {
        var qtyPrice = " " +
                        self.pad(msg: String(format: "$%.02f", unitPrice), totLength: U_PRICE_COL, padRight: false) +
                        self.pad(msg: "x" + String(qty), totLength: QTY_COL, padRight: false) +
                        self.pad(msg: String(format: "$%.02f", price), totLength: TOT_COL, padRight: false)
        qtyPrice = modify(qtyPrice, modifier: .normal)
        let nameByWords = name.components(separatedBy: " ")
        var spacesLeft = ITEM_COL
        var passedFirstLine = false
        var nameOnFirstLine = ""
        var remainingName = ""
        for word in nameByWords {
            if spacesLeft - word.count <= 1 {
                if passedFirstLine {
                    remainingName += "\n"
                }
                passedFirstLine = true
                spacesLeft = ITEM_COL - word.count
            } else {
                spacesLeft = spacesLeft - word.count
            }
            if passedFirstLine {
                remainingName += word + " "
            } else {
                nameOnFirstLine += word + " "
            }
        }
        return modify(self.pad(msg: String(nameOnFirstLine.prefix(ITEM_COL)), totLength: ITEM_COL), modifier: .bold)
                + qtyPrice
            + modify(remainingName, modifier: .bold) + "\n" + modify("")
    }
    
    // Pads the rest of the totLength provided with spaces after including msg.
    // String length will not override totLength
    func pad(msg: String, totLength: Int, padRight: Bool = true, repeatingChar: Character = " ") -> String {
        if msg.count < totLength {
            var spacesLeft = totLength
            spacesLeft -= msg.count
            let spacing = String(repeating: repeatingChar, count: spacesLeft)
            if padRight {
                return msg + spacing
            } else {
                return spacing + msg
            }
        } else {
            return String(msg.prefix(totLength))
        }
    }
    
    // Centres the given text based on its length and PAGE_WIDTH
    func centre(msg: String) -> String {
        let leftMsg = String(msg.prefix(msg.count / 2))
        
        var rightMsg = ""
        if msg.count % 2 == 0 {
            rightMsg = String(msg.suffix(msg.count / 2))
        } else {
            rightMsg = String(msg.suffix(msg.count / 2 + 1))
        }
        
        return self.pad(msg: leftMsg, totLength: PAGE_WIDTH / 2, padRight: false) + rightMsg + "\n"
    }
    
    
    func receipt() -> String {
        return modify(title(), modifier: .doubleHeight) +
            modify("") +
            header() +
            body() +
            modify(totals(), modifier: .doubleHeight) +
            modify("") +
            footer() +
            SPACER
    }
    
    func modify(_ message: String, modifier: FontModifier = .normal) -> String {
        let hexs : [Int]
        switch modifier {
            case .normal:
                hexs = [0x1b,0x21,0x00]
            case .doubleHeight:
                hexs = [0x1b,0x21,0x10]
            case .bold:
                hexs = [0x1b,0x21,0x08]
        }
        var hexString = String()
        for hex in hexs {
            if let scalar = UnicodeScalar(hex) {
                hexString.append(Character(scalar))
            }
        }
        return hexString + message
    }
    
    enum FontModifier {
        case normal
        case doubleHeight
        case bold
    }
}
