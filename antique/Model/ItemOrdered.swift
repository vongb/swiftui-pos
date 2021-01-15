//
//  ItemOrdered.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

struct ItemOrdered : Identifiable, Equatable, Hashable {
    let id = UUID()
    var item: MenuItem
    var qty : Int = 0
    var itemTotal : Double = 0.0
    var date : Date
    
    func barItem() -> BarItem {
        return BarItem(label: "\(item.name) x\(qty)",
                       amount: itemTotal)
    }
}
