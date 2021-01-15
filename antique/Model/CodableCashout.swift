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
        self.priceInUSD = Currency.convertToDollars(riels: priceInRiels)
    }
    
    init(title: String, description: String, priceInCents: Int) {
        self.title = title
        self.description = description
        self.priceInUSD = Currency.convertToDollars(cents: priceInCents)
    }
    
    init(title: String, description: String, priceInCents: Int, date: Date) {
        self.title = title
        self.description = description
        self.priceInUSD = Currency.convertToDollars(cents: priceInCents)
        self.date = date
    }
    
    init(title: String, description: String, priceInRiels: Int, date: Date) {
        self.title = title
        self.description = description
        self.priceInUSD = Currency.convertToDollars(riels: priceInRiels)
        self.date = date
    }
    
    mutating func cashOut() {
        self.date = Date()
        Bundle.main.cashOut(self)
    }
    
}
