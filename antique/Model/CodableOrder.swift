//
//  CodableOrder.swift
//  antique
//
//  File created by Vong Beng on 22/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

struct CodableOrder : Codable, Identifiable, Hashable {
    let id : UUID = UUID()
    var orderNo : Int
    var tableNo : String
    var items : [OrderItem]
    var discPercentage : Int
    var isDiscPercentage : Bool
    var discAmountInUSD : Double
    var date : Date
    var settled : Bool
    var cancelled : Bool
    
    var discountDisplay : String {
        if isDiscPercentage {
            return "\(discPercentage)%"
        } else {
            return String(format: "$%0.2f", discAmountInUSD)
        }
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
        if isDiscPercentage {
            return subtotal * (1 - Double(discPercentage) / 100)
        } else {
            return subtotal - discAmountInUSD
        }
    }
    
    // Creates instance of CodableOrder from returned value from reading json files
    init(_ order: CodableOrderDTO) {
        orderNo = order.orderNo ?? 0
        tableNo = order.tableNo ?? "No Table Number"
        items = order.getOrderItems()
        discPercentage = order.discPercentage ?? 0
        isDiscPercentage = order.isDiscPercentage ?? true
        discAmountInUSD = order.discAmountInUSD ?? 0
        date = order.date ?? Date(timeIntervalSince1970: 0)
        settled = order.settled ?? false
        cancelled = order.cancelled ?? false
    }
    
    // Manual CodableOrder init
    init(orderNo: Int, tableNo: String = "", items: [OrderItem] = [OrderItem](), discPercentage : Int = 0, isDiscPercentage : Bool = true, discAmountInUSD : Double = 0, date: Date, settled : Bool = false, cancelled : Bool = false) {
        self.orderNo = orderNo
        self.tableNo = tableNo
        self.items = items
        self.discPercentage = discPercentage
        self.isDiscPercentage = isDiscPercentage
        self.discAmountInUSD = discAmountInUSD
        self.date = date
        self.settled = settled
        self.cancelled = cancelled
    }
    
    // Checks for duplicate items before adding to the ordered items array
    mutating func add(_ newOrderItem : OrderItem) {
        for (index, orderedItem) in items.enumerated() {
            if OrderItem.hasSameAttributes(newOrderItem, orderedItem) {
                items[index].qty = items[index].qty + newOrderItem.qty
                let item = items.remove(at: index)
                items.append(item)
                return
            }
        }
        self.items.append(newOrderItem)
    }
    
    // Will remove in future iterations for text input instead
    // Increases discount percentage by 5%
    mutating func incDiscount(){
        if(discPercentage < 100) {
            discPercentage += 5
        }
    }
    // Decreases discount
    mutating func decDiscount(){
        if(discPercentage > 0) {
            discPercentage -= 5
        }
    }
    
    // Sets cancelled to true and unsettles the order
    mutating func cancel(){
        self.cancelled = true
        self.settled = false
    }
    mutating func uncancel() {
        self.cancelled = false
        self.settled = false
    }
    
    // Settles/Unsettles Order
    mutating func settle() {
        self.settled = true
        self.cancelled = false
    }
    
    mutating func unsettle() {
        self.settled = false
        self.cancelled = false
    }
}

// Data Transfer Object for reading JSON files
struct CodableOrderDTO : Codable {
    var orderNo : Int?
    var tableNo : String?
    var items : [OrderItemDTO]?
    var discPercentage : Int?
    var isDiscPercentage : Bool?
    var discAmountInUSD: Double?
    var date : Date?
    var settled : Bool?
    var cancelled : Bool?
    
    init() {
        orderNo = 1
        tableNo = "TA"
        items = [OrderItemDTO]()
        discPercentage = 0
        isDiscPercentage = true
        discAmountInUSD = 0
        date = Date()
        settled = false
        cancelled = false
    }
    
    init(orderNo: Int = -1, tableNo: String = "", items: [OrderItemDTO] = [OrderItemDTO](), discPercentage: Int = 0, isDiscPercentage: Bool = true, discAmountInUSD: Double = 0, date: Date = Date(), settled: Bool = false, cancelled: Bool = false) {
        self.orderNo = orderNo
        self.tableNo = tableNo
        self.items = items
        self.discPercentage = discPercentage
        self.isDiscPercentage = isDiscPercentage
        self.discAmountInUSD = discAmountInUSD
        self.date = date
        self.settled = settled
        self.cancelled = cancelled
    }
    
    init(from decoder: Decoder) throws {
        let newJSON = try decoder.container(keyedBy: NewKeys.self)
        orderNo = try? newJSON.decode(Int.self, forKey: .orderNo)
        tableNo = try? newJSON.decode(String.self, forKey: .tableNo)
        if let orderedItems = try? newJSON.decodeIfPresent([OrderItemDTO].self, forKey: .items){
            items = orderedItems
        } else {
            let oldJSON = try decoder.container(keyedBy: OldKeys.self)
            items = try? oldJSON.decode([OrderItemDTO].self, forKey: .itemsOrdered)
        }
        discPercentage = try? newJSON.decode(Int.self, forKey: .discPercentage)
        isDiscPercentage = try? newJSON.decode(Bool.self, forKey: .isDiscPercentage)
        discAmountInUSD = try? newJSON.decode(Double.self, forKey: .discAmountInUSD)
        date = try? newJSON.decode(Date.self, forKey: .date)
        settled = try? newJSON.decode(Bool.self, forKey: .settled)
        cancelled = try? newJSON.decode(Bool.self, forKey: .cancelled)
    }
    
    func getOrderItems() -> [OrderItem] {
        var items = [OrderItem]()
        
        if self.items != nil {
            for index in 0 ..< self.items!.count {
                items.append(self.items![index].convertToOrderItem())
            }
        }
        return items
    }
    
    private enum NewKeys : String, CodingKey {
        case orderNo
        case tableNo
        case items
        case discPercentage
        case isDiscPercentage
        case discAmountInUSD
        case date
        case settled
        case cancelled
    }
    
    private enum OldKeys : String, CodingKey {
        case orderNo
        case itemsOrdered
        case discPercentage
        case isDiscPercentage
        case discAmountInUSD
        case date
        case settled
        case cancelled
    }
}
