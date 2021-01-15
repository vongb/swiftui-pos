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
    @Published var includeWholeMonth : Bool {
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
    @Published var savedOrdersIsLoading: Bool = true
    
    
    init() {
        self.includeWholeMonth = false
        self.date = Date()
        self.savedOrders = Bundle.main.readOrders(orderDate: Date())
    }
    
    init(monthOnly: Bool) {
        self.includeWholeMonth = monthOnly
        self.date = Date()
        if monthOnly {
            self.savedOrders = Bundle.main.readMonthOrders(orderDate: Date())
        } else {
            self.savedOrders = Bundle.main.readOrders(orderDate: Date())
        }
    }
    
    
    // Calculates total, excluding any cancelled orders
    @Published var total : Double = 0

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
        savedOrdersIsLoading = true
        if includeWholeMonth {
            self.savedOrders = Bundle.main.readMonthOrders(orderDate: self.date)
        } else {
            self.savedOrders = Bundle.main.readOrders(orderDate: self.date)
        }
        self.savedOrdersIsLoading = false
    }
    
    func settleAll() {
        for index in 0 ..< self.savedOrders.count {
            self.savedOrders[index].settle()
            Bundle.main.updateOrder(order: self.savedOrders[index])
        }
    }
    
}
