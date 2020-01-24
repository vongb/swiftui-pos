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
    let item : MenuItem
    var qty : Int = 1
    var upsized : Bool = false
    var sugarLevel : String = "Regular"
    var iceLevel : String = "Regular"
    var total : Double {
        if upsized && item.canUpsize {
            return (item.price + item.upsizePrice) * Double(qty)
        } else {
            return item.price * Double(qty)
        }
    }
}
