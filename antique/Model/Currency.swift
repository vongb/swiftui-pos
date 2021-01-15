//
//  Currency.swift
//  antique
//
//  Created by Vong Beng on 16/8/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

struct Currency {
    static let EXCHANGE_RATE = UserDefKeys.getExchangeRate()
    
    static func convertToDollars(riels : Int) -> Double {
        Double(riels) / Double(EXCHANGE_RATE)
    }
    
    static func convertToDollars(cents: Int) -> Double {
        Double(cents) / 100.0
    }
    
    
    
    static func convertToCents(dollars: Double) -> Int {
        Int(
            (dollars * 100)
                .rounded(.up)
        )
    }
    
    static func convertToCents(riels: Int) -> Int {
        convertToCents(dollars: convertToDollars(riels: riels))
    }
    
    
    // Converts dollars to riels and rounds up
    static func convertToRiels(dollars: Double) -> Int {
        Int(
            (dollars * Double(Self.EXCHANGE_RATE))
                .rounded(.up)
        )
    }
    
    static func convertToRiels(cents: Int) -> Int {
        convertToRiels(dollars: convertToDollars(cents: cents))
    }
    
}
