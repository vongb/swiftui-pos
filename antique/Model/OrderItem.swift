//
//  OrderItem.swift
//  antique
//
//  Created by Vong Beng on 24/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import Foundation

// Struct containing details about each order item
struct OrderItem: Codable, Equatable, Identifiable {
    let id : UUID = UUID()
    var item : MenuItem = MenuItem()
    var qty : Int = 1
    var upsized : Bool = false
    var specialDiscounted : Bool = false
    var sugarLevel : String = "Regular"
    var iceLevel : String = "Regular"
    
    var total : Double {
        var basePrice = item.price
        if specialDiscounted {
            basePrice -= item.specialDiscount
        }
        if upsized && item.canUpsize {
            basePrice += item.upsizePrice
        }
        return basePrice * Double(qty)
    }
    
    mutating func updateQty(_ newQty : Int) {
        self.qty += newQty
    }
    
    static func hasSameAttributes(_ left : OrderItem, _ right : OrderItem) -> Bool {
        return left.item.name == right.item.name
            && left.upsized == right.upsized
            && left.iceLevel == right.iceLevel
            && left.sugarLevel == right.sugarLevel
            && left.specialDiscounted == right.specialDiscounted
    }
}
