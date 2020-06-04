//
//  Receipt.swift
//  antique
//
//  Created by Vong Beng on 9/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

// Struct for receipt layout
struct Receipt {
    // Page width in number of characters
    let PAGE_WIDTH : Int = 32
    
    // Difference of 2 to count for spaces between columns
    let ITEM_COL : Int = 18
    let QTY_COL : Int = 5
    let TOT_COL : Int = 8
    
    let SPACER : String = "\n\n\n"
    
    let WIFI_PASS : String = UserDefaults.standard.string(forKey: UserDefKeys.wifiPasswordKey) ?? ""
    
    // Order to print
    let order : CodableOrder
    let date : Date
    // Title Section
    // Name of Cafe (Centred)
    // Date (Left)
    // Time (Left)
    func title() -> String{
        let title = centre(msg: "ANTIQUE CAFE") + "\n"
        let orderNo = "Order #" + String(order.orderNo) + "\n"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let date = "Date: " + dateFormatter.string(from: order.date) + "\n"
        dateFormatter.dateFormat = "hh:mm:ss"
        let time = "Time: " + dateFormatter.string(from: self.date) + "\n"
        return title + orderNo + date + time
    }
    
    // Body Section (Will split item names in 2 lines if too long for item column)
    // ITEM             QTY  Price
    // **Item List*
    func body() -> String {
        // Column Labels
        let bodyHeader =
            String(repeating: "-", count: PAGE_WIDTH) + "\n" +
            self.pad(msg: "Item", totLength: ITEM_COL) + " " +
            self.pad(msg: "Qty", totLength: QTY_COL, padRight: false) +
            self.pad(msg: "Total", totLength: TOT_COL, padRight: false) +
            "\n" + String(repeating: "-", count: PAGE_WIDTH) + "\n"
        
        // Order items
        var body : String = ""
        self.order.items.forEach{orderItem in
            body += self.itemMultiLine(name: orderItem.item.name, price: orderItem.total, qty: orderItem.qty)
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
                body += String(format: "Special Discount (-$%0.02f ea)\n", orderItem.item.specialDiscount)
            }
            body += "\n"
        }
        
        return bodyHeader + body
    }
    
    // Footer Section
    // Subtotal
    // Discounts
    // Total
    // WiFi Password
    // Gratitude
    // Spacer for next receipt
    func footer() -> String{
        let REMAINING_SPACE = PAGE_WIDTH - ITEM_COL
        
        let subtotal = self.pad(msg: "Subtotal:", totLength: ITEM_COL) +
            self.pad(msg: String(format: "$%.02f", self.order.subtotal), totLength: REMAINING_SPACE, padRight: false) + "\n"
        let discount = self.pad(msg: "Discounts:", totLength: ITEM_COL) +
            self.pad(msg: "\(self.order.discPercentage)%", totLength: REMAINING_SPACE, padRight: false) + "\n"
        let grandTotal = self.pad(msg: "Grand Total:", totLength: ITEM_COL) +
            self.pad(msg: String(format: "$%.02f", self.order.total), totLength: REMAINING_SPACE, padRight: false) + "\n"
        
        let footer = "WiFi Password: " + WIFI_PASS
        let thankYou = "Thank You, Please Come Again"
        let divider = String(repeating: "-", count: PAGE_WIDTH) + "\n"
        
        
        return divider + subtotal + discount + grandTotal + divider + centre(msg: footer) + centre(msg: thankYou)
    }
    
    // Checks if item name is longer than item column and splits it into 2 lines if necessary.
    func itemMultiLine(name: String, price: Double, qty: Int) -> String {
        let qtyPrice = " " + self.pad(msg: "x" + String(qty), totLength: QTY_COL, padRight: false) + self.pad(msg: String(format: "$%.02f", price), totLength: TOT_COL, padRight: false)
        
        if name.count <= ITEM_COL {
            return self.pad(msg: name, totLength: ITEM_COL)
                + qtyPrice + "\n"
        } else {
            let charsLeft = name.count - ITEM_COL
            return self.pad(msg: String(name.prefix(ITEM_COL)), totLength: ITEM_COL)
                + qtyPrice + "\n"
                + self.pad(msg: String(name.suffix(charsLeft)), totLength: ITEM_COL) + "\n"
        }
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
        return title() + body() + footer() + SPACER
    }
}
