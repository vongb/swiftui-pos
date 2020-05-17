////
////  Cashout.swift
////  antique
////
////  Created by Vong Beng on 8/5/20.
////  Copyright © 2020 Vong Beng. All rights reserved.
////
//
//import Foundation
//
//class Cashout : ObservableObject {
//    @Published var title : String = ""
//    @Published var description : String = ""
//    @Published var price : Int = 0
//    @Published var date : Date = Date()
//    @Published var isPriceRiels : Bool = false
//    var priceDisplay : String {
//        let price : Double
//        if self.isPriceRiels {
//            price = Double(self.price) / 4000
//            return String(format: "$%.02f", price)
//        } else {
//            price = Double(self.price) / 100
//        }
//        return String(format: "$%.02f", price)
//    }
//    init() {
//        self.title = "No Title"
//        self.price = 0
//        self.description = "No Description"
//        self.date = Date()
//    }
//
//    init(_ cashout: CodableCashout) {
//        self.title = cashout.title
//        self.description = cashout.description
//        self.price = Int(cashout.priceInUSD * 100)
//        self.date = cashout.date
//        self.isPriceRiels = false
//    }
//
//    func updateCashout(_ cashout: CodableCashout) {
//        self.title = cashout.title
//        self.description = cashout.description
//        self.price = Int(cashout.priceInUSD * 100)
//        self.date = cashout.date
//        self.isPriceRiels = false
//    }
//
//    func getCodable() -> CodableCashout {
//        if isPriceRiels {
//            return CodableCashout(title: self.title, description: self.description, priceInRiels: price)
//        } else {
//            return CodableCashout(title: self.title, description: self.description, priceInCents: price)
//        }
//    }
//}
