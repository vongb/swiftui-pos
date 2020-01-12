//
//  Order.swift
//  antique
//
//  Adapted from Paul Hudson
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

class Order : ObservableObject {
    @Published var items = [OrderItem]()
    @Published var discountPercentage : Int = 0
    let date = Date()
    
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
    var total : Double {
        return subtotal * (1 - Double(discountPercentage) / 100)
    }

    func add(item: MenuItem, qty : Int, sugarLevel : String, iceLevel : String, upsized: Bool) {
        for (index, orderItem) in items.enumerated() {
            if(item.id == orderItem.item.id) {
                if(orderItem.iceLevel == iceLevel && orderItem.sugarLevel == sugarLevel && orderItem.upsized == upsized) {
                    items[index].qty += qty
                    return
                }
            }
        }
        items.append(
            OrderItem(item: item, qty: qty, upsized: upsized, sugarLevel: sugarLevel, iceLevel: iceLevel)
        )
    }
    
    func deduct(itemID: UUID, sugar : String, ice : String) {
        for (index, itemInOrder) in items.enumerated() {
            if(itemInOrder.id == itemID && itemInOrder.sugarLevel == sugar && itemInOrder.iceLevel == ice) {
                if(itemInOrder.qty > 1) {
                    items[index].qty -= 1
                } else {
                    items.remove(at: index)
                }
            }
        }
    }
    
    func incDiscount(){
        if(discountPercentage < 100) {
            discountPercentage += 5
        }
    }
    
    func decDiscount(){
        if(discountPercentage > 0) {
            discountPercentage -= 5
        }
    }
    
    func settleOrder(orderNo: Int, settled: Bool) {
        if(items.count > 0) {
            let codedItem = CodableOrder(orderNo: orderNo, itemsOrdered: self.items, discPercentage: self.discountPercentage, total: self.total, subtotal: self.subtotal, date: Date(), settled: settled)
            Bundle.main.saveOrder(orderToEncode: codedItem)
            items.removeAll()
            discountPercentage = 0
        }
    }
}

struct CodableOrder : Codable, Identifiable {
    let id : UUID = UUID()
    var orderNo : Int = 0
    var itemsOrdered : [OrderItem] = [OrderItem]()
    var discPercentage : Int = 0
    var total : Double = 0
    var subtotal : Double = 0
    var date : Date = Date()
    var settled : Bool = false
}
