//
//  CashOut.swift
//  antique
//
//  Created by Vong Beng on 8/3/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

struct CodableCashout : Codable, Identifiable, Hashable {
    let id = UUID()
    var title : String = ""
    var description : String = ""
    var priceInUSD : Double = 0.0
    var date : Date = Date()
    
    init() {
        self.title = ""
        self.description = ""
        self.priceInUSD = 0.0
    }
    
    init(title: String, description: String, priceInRiels: Int) {
        self.title = title
        self.description = description
        self.priceInUSD = Double(priceInRiels) / 4000
    }
    
    init(title: String, description: String, priceInCents: Int) {
        self.title = title
        self.description = description
        self.priceInUSD = Double(priceInCents) / 100.0
    }
    
    init(title: String, description: String, priceInCents: Int, date: Date) {
        self.title = title
        self.description = description
        self.priceInUSD = Double(priceInCents) / 100.0
        self.date = date
    }
    
    init(title: String, description: String, priceInRiels: Int, date: Date) {
        self.title = title
        self.description = description
        self.priceInUSD = Double(priceInRiels) / 4000
        self.date = date
    }
    
//    mutating func update(_ newCashout : CodableCashout) {
//        self.title = newCashout.title
//        self.description = newCashout.description
//        self.priceInUSD = newCashout.priceInUSD
//        self.date = newCashout.date
//    }
    
    mutating func cashOut() {
        self.date = Date()
        Bundle.main.cashOut(self)
    }
    
}
