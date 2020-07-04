//
//  UserDefKeys.swift
//  antique
//
//  Created by Vong Beng on 4/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation


struct UserDefKeys {
    static let exchangeRateKey = "exchangeRate"
    static let wifiPasswordKey = "wifiPassword"
    static let adminPasscodeKey = "adminPasscode"
    
    static func getExchangeRate() -> Int {
        return UserDefaults.standard.value(forKey: exchangeRateKey) as? Int ?? 4000
    }
    
    static func getWifiPassword() -> String {
        return UserDefaults.standard.string(forKey: wifiPasswordKey) ?? "No password set"
    }
}
