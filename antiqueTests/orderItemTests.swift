//
//  orderItemTests.swift
//  antiqueTests
//
//  Created by Vong Beng on 4/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import XCTest
@testable import antique

class orderItemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testOrderItemUnmodifiedTotal() {
        let menuItem = MenuItem(name: "Name", price: 2.5, hasSugarLevels: true, iceLevelIndex: 0, hasIceLevels: true, canUpsize: false, upsizePrice: 0, specialDiscount: 0)
        let qty = 4
        let expectedPrice = Double(qty) * menuItem.price
        var orderItem = OrderItem(item: menuItem)
        orderItem.qty = qty
        XCTAssert(orderItem.total == expectedPrice)
    }
    
    func testUpsizeAnUnupsizableItem() {
        let item = MenuItem(name: "item", price: 5, hasSugarLevels: false, iceLevelIndex: 0, hasIceLevels: false, canUpsize: false, specialDiscount: 0)
        let qty = 1
        let orderItem = OrderItem(item: item, qty: qty, upsized: true)
        let expectedPrice = item.price * Double(qty)
        XCTAssert(expectedPrice == orderItem.total)
    }

    func testUpsizePriceApplied() {
        let basePrice = 2.5
        let qty = 2
        let upsizePrice = 0.75
        let expectedPrice = (basePrice + upsizePrice) * Double(qty)
        
        let menuItem = MenuItem(name: "name", price: basePrice, hasSugarLevels: true, iceLevelIndex: 0, hasIceLevels: true, canUpsize: true, upsizePrice: upsizePrice, specialDiscount: 0)
        
        var orderItem = OrderItem(item: menuItem)
        orderItem.qty = qty
        orderItem.upsized = true
        
        XCTAssert(orderItem.total == expectedPrice)
    }
    
    func testSpecialDiscountApplied() {
        let basePrice = 2.5
        let qty = 2
        let discountedBy = 1.0
        let expectedDiscountedPrice = (basePrice - discountedBy) * Double(qty)
        let menuItem = MenuItem(name: "Item Name", price: basePrice, hasSugarLevels: true, iceLevelIndex: 0, hasIceLevels: true, canUpsize: true, upsizePrice: 0.5, specialDiscount: discountedBy)
        var orderItem = OrderItem(item: menuItem)
        orderItem.specialDiscounted = true
        orderItem.qty = qty
        XCTAssert(orderItem.total == expectedDiscountedPrice)
    }

    func testSameOrderItem() {
        var item1 = OrderItem()
        var item2 = OrderItem()
        
        item1.item.canUpsize = true
        item2.item.canUpsize = true
        
        item1.item.specialDiscount = 0.5
        item2.item.specialDiscount = 0.5
        
        XCTAssert(OrderItem.hasSameAttributes(item1, item2))
        
        item1.upsized = true
        item2.upsized = false
        XCTAssertFalse(OrderItem.hasSameAttributes(item1, item2))
        
        item1.upsized = true
        item2.upsized = true
        item1.specialDiscounted = true
        item2.specialDiscounted = false
        XCTAssertFalse(OrderItem.hasSameAttributes(item1, item2))
    }
    
}
