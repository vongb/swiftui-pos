//
//  cashoutTests.swift
//  antiqueTests
//
//  Created by Vong Beng on 4/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import XCTest
@testable import antique

class cashoutTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCorrectUserDefaultExchangeRate() {
        let cashout = CodableCashout()
        let exchangeRate = UserDefKeys.getExchangeRate()
        XCTAssert(exchangeRate == cashout.EXCHANGE_RATE)
    }

    func testCashoutRielToUSD() {
        let riels = 40000
        let exchangeRate = UserDefKeys.getExchangeRate()
        let usd = Double(riels) / Double(exchangeRate)
        let cashout = CodableCashout(title: "Test Cashout", description: "Test Description", priceInRiels: riels)
        
        XCTAssert(usd == cashout.priceInUSD)
    }

    func testCashoutUSDValue() {
        let cents = 50000
        let priceInUSD = Double(cents) / 100.0
        let cashout = CodableCashout(title: "Title", description: "Desc", priceInCents: cents)
        XCTAssert(priceInUSD == cashout.priceInUSD)
    }
}
