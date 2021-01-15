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
    @Published var tableNo : String = ""
    @Published var paymentType: String = ""
    var date : Date = Date()
    
    var discountDisplay : String {
        if isDiscPercentage {
            return "\(discPercentage)%"
        } else {
            return String(format: "$%0.2f", discAmountInUSD)
        }
    }
    
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
        if isDiscPercentage {
            return subtotal * (1 - Double(discPercentage) / 100)
        } else {
            return subtotal - discAmountInUSD
        }
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
    
    func settleOrder(orderNo: Int, settled: Bool = true, settleDate : Date = Date()) {
        if(items.count > 0) {
            var orderItemsDTO = [OrderItemDTO]()
            for i in 0 ..< self.items.count {
                orderItemsDTO.append(self.items[i].convertToDTO())
            }
            
            let codedItem = CodableOrderDTO(orderNo: orderNo,
                                            tableNo: tableNo,
                                            items: orderItemsDTO,
                                            discPercentage: self.discPercentage,
                                            isDiscPercentage: self.isDiscPercentage,
                                            discAmountInUSD: self.discAmountInUSD,
                                            paymentType: settled ? self.paymentType : "",
                                            date: settleDate,
                                            settled: settled)
            
            let codableOrder = CodableOrder(codedItem)
            
            Bundle.main.createOrder(orderToEncode: codableOrder)
            resetOrder()
        }
    }
    
    func resetOrder() {
        items.removeAll()
        discAmountInUSD = 0
        discPercentage = 0
        isDiscPercentage = true
        date = Date()
        tableNo = ""
    }
}


