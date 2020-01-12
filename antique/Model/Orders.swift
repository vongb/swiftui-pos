//
//  Orders.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

class Orders : ObservableObject {
    @Published var savedOrders = Bundle.main.readOrders()
    
    var nextOrderNo : Int {
        self.savedOrders.count + 1
    }
    
    func refreshSavedOrders() {
        self.savedOrders = Bundle.main.readOrders()
    }
}
