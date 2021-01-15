//
//  PaymentTypeReport.swift
//  antique
//
//  Created by Vong Beng on 12/9/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import Combine

class PaymentReport: ObservableObject {
    @Published var date: Date {
        didSet {
            refreshOrders()
        }
    }
    @Published var includeWholeMonth: Bool {
        didSet {
            refreshOrders()
        }
    }
    
    @Published var paymentIncomes: [BarItem]
    
    @Published var isLoading: Bool
    
    init() {
        date = Date()
        includeWholeMonth = false
        paymentIncomes = []
        isLoading = true
    }
    
    func refreshOrders() {
        isLoading = true
        var savedOrders = [CodableOrder]()
        paymentIncomes.removeAll()
        DispatchQueue.global(qos: .userInteractive).async {
            if self.includeWholeMonth {
                savedOrders = Bundle.main.readMonthOrders(orderDate: self.date)
            } else {
                savedOrders = Bundle.main.readOrders(orderDate: self.date)
            }
            
            var paymentTypeIndexMap = [String : Int]()
            var paymentTypes = Set<String>()
            var paymentIncomes = [BarItem]()
            savedOrders.forEach { order in
                if !order.cancelled {
                    if paymentTypes.contains(order.paymentType) {
                        if let index = paymentTypeIndexMap[order.paymentType] {
                            paymentIncomes[index].amount += order.total
                        }
                    } else {
                        paymentTypes.insert(order.paymentType)
                        paymentIncomes.append(BarItem(label: order.paymentType, amount: order.total))
                        paymentTypeIndexMap.updateValue(paymentIncomes.count - 1, forKey: order.paymentType)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.paymentIncomes = paymentIncomes
                self.isLoading = false
            }
        }
    }
}
