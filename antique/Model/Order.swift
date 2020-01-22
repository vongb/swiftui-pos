//
//  Order.swift
//  antique
//
//  Adapted from Paul Hudson, hackingwithswift
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

class Order : ObservableObject {
    @Published var items = [OrderItem]()
    @Published var discPercentage : Int = 0
    var date : Date = Date()
    
    init(){
        self.items = [OrderItem]()
        self.discPercentage = 0
        date = Date()
    }
    
    init(codableOrder: CodableOrder){
        self.items = codableOrder.items
        self.discPercentage = codableOrder.discPercentage
        self.date = codableOrder.date
    }
    
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
        return subtotal * (1 - Double(discPercentage) / 100)
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
        if(discPercentage < 100) {
            discPercentage += 5
        }
    }
    
    func decDiscount(){
        if(discPercentage > 0) {
            discPercentage -= 5
        }
    }
    
    func settleOrder(orderNo: Int, settled: Bool = true) {
        if(items.count > 0) {
            let codedItemDTO = CodableOrderDTO(orderNo: orderNo, items: self.items, discPercentage: self.discPercentage, date: Date(), settled: settled)
            let codableOrder = CodableOrder(codedItemDTO)
            Bundle.main.saveOrder(orderToEncode: codableOrder)
            items.removeAll()
            discPercentage = 0
        }
    }
}

struct CodableOrder : Codable, Identifiable {
    let id : UUID = UUID()
    var orderNo : Int
    var items : [OrderItem]
    var discPercentage : Int
    var date : Date
    var settled : Bool
    var cancelled : Bool
    
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
        return subtotal * (1 - Double(discPercentage) / 100)
    }
    
    init(_ order: CodableOrderDTO) {
        self.orderNo = order.orderNo ?? 0
        self.items = order.items ?? [OrderItem]()
        self.discPercentage = order.discPercentage ?? 0
        self.date = order.date ?? Date()
        self.settled = order.settled ?? false
        self.cancelled = order.cancelled ?? false
    }
    
    init(orderNo: Int, items: [OrderItem], discPercentage : Int, date: Date, settled : Bool, cancelled : Bool) {
        self.orderNo = orderNo
        self.items = items
        self.discPercentage = discPercentage
        self.date = date
        self.settled = settled
        self.cancelled = cancelled
    }
    
    mutating func add(item: MenuItem, qty : Int, sugarLevel : String, iceLevel : String, upsized: Bool) {
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
    
    mutating func incDiscount(){
        if(discPercentage < 100) {
            discPercentage += 5
        }
    }
    
    mutating func decDiscount(){
        if(discPercentage > 0) {
            discPercentage -= 5
        }
    }
    
    mutating func cancel(){
        self.cancelled = true
        self.settled = false
    }
    
    mutating func uncancel() {
        self.cancelled = false
        self.settled = false
    }
    
    mutating func settle() {
        self.settled = true
    }
    
    mutating func unsettle() {
        self.settled = false
    }
}

struct CodableOrderDTO : Codable {
    var orderNo : Int?
    var items : [OrderItem]?
    var discPercentage : Int?
//    var total : Double?
//    var subtotal : Double?
    var date : Date?
    var settled : Bool?
    var cancelled : Bool?
}
