//
//  Report.swift
//  antique
//
//  Created by Vong Beng on 9/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation


class Report : ObservableObject {
    @Published var date : Date = Date() {
        didSet {
            cashouts.date = date
            orders.date = date
        }
    }
    
    var includeWholeMonth : Bool = false {
        didSet {
            cashouts.includeWholeMonth = includeWholeMonth
            orders.includeWholeMonth = includeWholeMonth
        }
    }
    
    
    
    @Published var includeCashouts : Bool = false
    @Published var cashouts : Cashouts = Cashouts()
    @Published var orders : Orders = Orders()
    var total : Double {
        if includeCashouts {
            return orders.total - cashouts.total
        } else {
            return orders.total
        }
    }
}
