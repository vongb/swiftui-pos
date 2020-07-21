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
    let menuSections : [String]
    let menuDictionary : [String : Set<String>]

    var sectionSelection : Int {
        didSet {
            refreshSavedOrders()
        }
    }
    
    var includeWholeMonth : Bool {
        didSet {
            refreshSavedOrders()
        }
    }
    
    // Date where the list of order is based on.
    // Changes savedOrders when date changes value
    @Published var date : Date {
        didSet {
            refreshSavedOrders()
        }
    }
    
    // [CodableOrder] array of all the orders found in the given date directory
    @Published var savedOrders : [CodableOrder]
    
    init() {
        self.menuDictionary = Menu.getMenuDictionary()
        self.menuSections = Menu.getMenuSections()
        self.includeWholeMonth = false
        self.sectionSelection = 0
        self.date = Date()
        if includeWholeMonth {
            self.savedOrders = Bundle.main.readMonthOrders(orderDate: Date())
        } else {
            self.savedOrders = Bundle.main.readOrders(orderDate: Date())
        }
    }
    
    init(monthOnly: Bool) {
        self.menuDictionary = Menu.getMenuDictionary()
        self.menuSections = Menu.getMenuSections()
        self.includeWholeMonth = monthOnly
        self.sectionSelection = 0
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
                order.items.forEach { orderItem in
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
    
    var filteredItems : [ItemOrdered] {
        var filteredItems = [ItemOrdered]()
        for item in items {
            if menuDictionary[menuSections[sectionSelection]]?.contains(item.item.name) ?? false {
                filteredItems.append(item)
            }
        }
        return filteredItems
    }
    
    var categoryTotal : Double {
        var total = 0.0
        self.filteredItems.forEach { (orderedItem) in
            total += orderedItem.itemTotal
        }
        return total
    }

    
    // Next order number
    var nextOrderNo : Int {
        if includeWholeMonth {
            return 0
        } else {
            var nextOrderNo : Int = 1
            for index in 0 ..< savedOrders.count {
                let currentOrderNo = savedOrders[index].orderNo
                if nextOrderNo <= currentOrderNo {
                    nextOrderNo = currentOrderNo + 1
                }
            }
            return nextOrderNo
        }
    }
    
    // Manually updates the current order list
    func refreshSavedOrders() {
        if includeWholeMonth {
            self.savedOrders = Bundle.main.readMonthOrders(orderDate: self.date)
        } else {
            self.savedOrders = Bundle.main.readOrders(orderDate: self.date)
        }
    }
    
    func settleAll() {
        for index in 0 ..< self.savedOrders.count {
            self.savedOrders[index].settle()
            Bundle.main.updateOrder(order: self.savedOrders[index])
        }
    }
    
}