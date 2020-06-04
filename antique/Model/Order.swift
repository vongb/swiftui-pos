//
//  Order.swift
//  antique
//
//  Adapted from Paul Hudson, hackingwithswift
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI


// Used for main POS page as an Environment Object
class Order : ObservableObject {
    @Published var items = [OrderItem]() // Items ordered
    @Published var discPercentage : Int = 0 // Discount percentage
    @Published var isDiscPercentage : Bool = true
    @Published var discAmountInUSD : Double = 0
    var date : Date = Date()
    
    // Calculates subtotal
    var subtotal: Double {
        if items.count > 0 {
            var total = 0.0
            for item in items {
                total = total + item.total
            }
            return total
        } else {
            return 0
        }
    }
    
    // Applies discounts and returns final total
    var total : Double {
        return subtotal * (1 - Double(discPercentage) / 100)
    }

    // Will search through current ordered items and check if there are the same item already added.
    // If so, it will increase ordered QTY by the qty parameter.
    func add(_ newOrderItem : OrderItem) {
        for (index, orderedItem) in items.enumerated() {
            // Same item attributes matches (Name, sugar level, ice level, upsized, special discounted)
            if OrderItem.hasSameAttributes(newOrderItem, orderedItem) {
                items[index].qty = items[index].qty + newOrderItem.qty
                let item = items.remove(at: index)
                items.append(item)
                return
            }
        }
        items.append(newOrderItem)
    }
    
    func incDiscount(){
        if(discPercentage < 100) {
            discPercentage += 5
        }
    }
    
    func decDiscount(){
        if(discPercentage > 0) {
            discPercentage -= 5
        }
    }
    
    func settleOrder(orderNo: Int, settled: Bool = true, settleDate : Date = Date()) {
        if(items.count > 0) {
            let codedItemDTO = CodableOrderDTO(orderNo: orderNo, items: self.items, discPercentage: self.discPercentage, date: settleDate, settled: settled)
            let codableOrder = CodableOrder(codedItemDTO)
            Bundle.main.createOrder(orderToEncode: codableOrder)
            items.removeAll()
            discPercentage = 0
            self.date = Date()
        }
    }
}


