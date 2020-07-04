//
//  OrderItem.swift
//  antique
//
//  Created by Vong Beng on 24/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import Foundation

// Struct containing details about each order item
struct OrderItem: Codable, Equatable, Identifiable, Hashable {
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
    
    init(item : MenuItem = MenuItem(),
         qty : Int = 1,
         upsized : Bool = false,
         specialDiscounted : Bool = false,
         sugarLevel : String = "Regular",
         iceLevel : String = "Regular") {
        self.item = item
        self.qty = qty
        self.upsized = upsized
        self.specialDiscounted = specialDiscounted
        self.sugarLevel = sugarLevel
        self.iceLevel = iceLevel
    }
    
    init(_ order: OrderItemDTO) {
        self.item = order.item ?? MenuItem()
        self.qty = order.qty ?? 1
        self.upsized = order.upsized ?? false
        self.specialDiscounted = order.specialDiscounted ?? false
        self.sugarLevel = order.sugarLevel ?? "Regular"
        self.iceLevel = order.iceLevel ?? "Regular"
    }
    
    mutating func updateQty(_ newQty : Int) {
        self.qty += newQty
    }
    
    func convertToDTO() -> OrderItemDTO {
        return OrderItemDTO(item: self.item,
                            qty: self.qty,
                            upsized: self.upsized,
                            specialDiscounted: self.specialDiscounted,
                            sugarLevel: self.sugarLevel,
                            iceLevel: self.iceLevel)
    }
    
    static func hasSameAttributes(_ left : OrderItem, _ right : OrderItem) -> Bool {
        return left.item.name == right.item.name
            && left.upsized == right.upsized
            && left.iceLevel == right.iceLevel
            && left.sugarLevel == right.sugarLevel
            && left.specialDiscounted == right.specialDiscounted
    }
}

struct OrderItemDTO : Codable {
    var item : MenuItem?
    var qty : Int?
    var upsized : Bool?
    var specialDiscounted : Bool?
    var sugarLevel : String?
    var iceLevel : String?
    
    init() {
        item = MenuItem()
        qty = 1
        upsized = false
        specialDiscounted = false
        sugarLevel = "Regular"
        iceLevel = "Regular"
    }
    
    init(item : MenuItem = MenuItem(),
         qty : Int = 1,
         upsized : Bool = false,
         specialDiscounted : Bool = false,
         sugarLevel : String = "Regular",
         iceLevel : String = "Regular") {
        self.item = item
        self.qty = qty
        self.upsized = upsized
        self.specialDiscounted = specialDiscounted
        self.sugarLevel = sugarLevel
        self.iceLevel = iceLevel
    }
    
    init(from decoder: Decoder) throws {
        let json = try decoder.container(keyedBy: OrderItemKeys.self)
        self.item = try? json.decode(MenuItem.self, forKey: .item)
        self.qty = try? json.decode(Int.self, forKey: .qty)
        self.upsized = try? json.decode(Bool.self, forKey: .upsized)
        self.specialDiscounted = try? json.decode(Bool.self, forKey: .specialDiscounted)
        self.sugarLevel = try? json.decode(String.self, forKey: .sugarLevel)
        self.iceLevel = try? json.decode(String.self, forKey: .iceLevel)
    }
    
    func convertToOrderItem() -> OrderItem {
        let item = OrderItem(self)
        return item
    }
    
    private enum OrderItemKeys : String, CodingKey {
        case item
        case qty
        case upsized
        case specialDiscounted
        case sugarLevel
        case iceLevel
    }
}
