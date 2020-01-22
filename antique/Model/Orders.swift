//
//  Orders.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

class Orders : ObservableObject {
    @Published var date = Date() {
        didSet {
            savedOrders = Bundle.main.readOrders(orderDate: date)
        }
    }
    
    @Published var savedOrders = Bundle.main.readOrders()
    
    var formatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
    
    var dailyTotal : Double {
        var total : Double = 0.0
        self.savedOrders.forEach{ order in
            if !order.cancelled {
                total += order.total
            }
        }
        return total
    }
    
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
                        temp.append(ItemOrdered(item: orderItem.item, qty: orderItem.qty, itemTotal: orderItem.total))
                    }
                }
            }
        }
        return temp.sorted(by: {$0.qty > $1.qty})
    }
    
    init(date: Date = Date()) {
        self.date = date
    }
    
    var nextOrderNo : Int {
        return savedOrders.count + 1
    }
    
    func resetDate() {
        self.date = Date()
    }
    
    func refreshSavedOrders() {
        self.savedOrders = Bundle.main.readOrders(orderDate: self.date)
    }
}
