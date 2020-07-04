//
//  CashOuts.swift
//  antique
//
//  Created by Vong Beng on 6/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

class Cashouts : ObservableObject {
    @Published var date : Date {
        didSet {
            refreshCashouts()
        }
    }
    @Published var cashouts : [CodableCashout]
    @Published var includeWholeMonth : Bool {
        didSet {
            refreshCashouts()
        }
    }
    var total : Double {
        var temp : Double = 0.0
        self.cashouts.forEach { cashout in
            temp += cashout.priceInUSD
        }
        return temp
    }

    init() {
        date = Date()
        cashouts = Bundle.main.readCashout();
        includeWholeMonth = false
    }
    
    init(date: Date = Date(), monthOnly : Bool = false) {
        self.date = date
        cashouts = Bundle.main.readCashout(date: date)
        self.includeWholeMonth = monthOnly
    }
    
    func refreshCashouts() {
        if includeWholeMonth {
            self.cashouts = Bundle.main.readMonthCashouts(cashOutDate: date)
        } else {
            self.cashouts = Bundle.main.readCashout(date: date)
        }
    }
}

