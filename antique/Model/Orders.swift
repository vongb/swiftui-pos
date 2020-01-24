//
//  Orders.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

// Class that holds a list of saved orders based on a given date
class Orders : ObservableObject {
    var monthOnly : Bool {
        didSet {
            refreshSavedOrders()
        }
    }
    
    
    // Date where the list of order is based on.
    // Changes savedOrders when date changes value
    @Published var date : Date {
        didSet {
            if monthOnly {
                savedOrders = Bundle.main.readMonthOrders(orderDate: date)
            } else {
                savedOrders = Bundle.main.readOrders(orderDate: date)
            }
        }
    }
    
    // [CodableOrder] array of all the orders found in the given date directory
    @Published var savedOrders : [CodableOrder]
    
    init() {
        monthOnly = false
        self.date = Date()
        if monthOnly {
            self.savedOrders = Bundle.main.readMonthOrders(orderDate: Date())
        } else {
            self.savedOrders = Bundle.main.readOrders(orderDate: Date())
        }
    }
    
    init(monthOnly: Bool) {
        self.monthOnly = monthOnly
        self.date = Date()
        if monthOnly {
            self.savedOrders = Bundle.main.readMonthOrders(orderDate: Date())
        } else {
            self.savedOrders = Bundle.main.readOrders(orderDate: Date())
        }
    }
    
    
    // Calculates total, excluding any cancelled orders
    var total : Double {
        var total : Double = 0.0
        self.savedOrders.forEach{ order in
            if !order.cancelled {
                total += order.total
            }
        }
        return total
    }
    
    // A list of unique items ordered with their quantities and totals
    // Returns a descending array based on quantity ordered.
    var items : [ItemOrdered] {
        var temp = [ItemOrdered]()
        self.savedOrders.forEach{ order in
            if !order.cancelled {
                order.items.forEach{ orderItem in
                    var found = false
                    for index in 0..<temp.count {
                        if temp[index].item.name == orderItem.item.name {
                            temp[index].qty += orderItem.qty
                            temp[index].itemTotal += orderItem.total
                            found = true
                            break
                        }
                    }
                    if !found {
                        temp.append(ItemOrdered(item: orderItem.item, qty: orderItem.qty, itemTotal: orderItem.total, date: order.date))
                    }
                }
            }
        }
        return temp.sorted(by: {$0.qty > $1.qty})
    }
    
    // Next order number
    var nextOrderNo : Int {
        if monthOnly {
            return 0
        } else {
            return savedOrders.count + 1
        }
    }
    
    // Manually updates the current order list
    func refreshSavedOrders() {
        if monthOnly {
            self.savedOrders = Bundle.main.readMonthOrders(orderDate: self.date)
        } else {
            self.savedOrders = Bundle.main.readOrders(orderDate: self.date)
        }
    }
}
