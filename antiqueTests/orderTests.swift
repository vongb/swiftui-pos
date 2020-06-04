//
//  orderTests.swift
//  antiqueTests
//
//  Created by Vong Beng on 4/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import XCTest
@testable import antique

class orderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubtotal() {
        let item1 = MenuItem(price: 2.5, canUpsize: false, specialDiscount: 0)
        let item2 = MenuItem(price: 4.5, canUpsize: false, specialDiscount: 0)
        let item3 = MenuItem(price: 3.5, canUpsize: false, specialDiscount: 0)
        var order = CodableOrder(orderNo: 1, date: Date())
        var orderItem = OrderItem(item: item1, qty: 1)
        order.items.append(orderItem)
        
        orderItem.item = item2
        order.items.append(orderItem)
        
        orderItem.item = item3
        order.items.append(orderItem)
        
        order.discPercentage = 10
        
        let expectedSubtotal = item1.price + item2.price + item3.price
//        print(expectedSubtotal)
//        print(order.subtotal)
        XCTAssert(order.subtotal == expectedSubtotal)
    }
    
    func testDiscountPercentage() {
        let item1 = MenuItem(price: 2.5, canUpsize: false, specialDiscount: 0)
        let item2 = MenuItem(price: 4.5, canUpsize: false, specialDiscount: 0)
        let item3 = MenuItem(price: 3.5, canUpsize: false, specialDiscount: 0)
        var order = CodableOrder(orderNo: 1, date: Date())
        var orderItem = OrderItem(item: item1, qty: 1)
        
        order.items.append(orderItem)
        
        orderItem.item = item2
        order.items.append(orderItem)
        
        orderItem.item = item3
        order.items.append(orderItem)
        
        let percentage = 10
        order.discPercentage = percentage
        order.isDiscPercentage = true
        
        let expectedTotal = (item1.price + item2.price + item3.price) * (Double((100-percentage))/100)
        print(expectedTotal)
        print(order.total)
        XCTAssert(order.total == expectedTotal)
    }

    func testAddSameUpsizedItemToOrderIncrementsQty() {
        let item1 = MenuItem(price: 3, canUpsize: true, upsizePrice: 3, specialDiscount: 2)
        
        let orderItemUpsized = OrderItem(item: item1, qty: 1, upsized: true, specialDiscounted: false)
        
        var order = CodableOrder(orderNo: 0, date: Date())
        order.items.removeAll()
        order.add(orderItemUpsized)
        order.add(orderItemUpsized)
        XCTAssert(order.items.count == 1)
        XCTAssert(order.items[0].qty == 2)
    }
    
    func testCancel() {
        var order = CodableOrder(orderNo: 1, date: Date())
        order.cancel()
        XCTAssert(order.cancelled)
        XCTAssertFalse(order.settled)
    }
    
    func testSettle() {
        var order = CodableOrder(orderNo: 1, date: Date())
        order.settle()
        XCTAssert(order.settled)
        XCTAssertFalse(order.cancelled)
    }
    
    func testUncancel() {
        var order = CodableOrder(orderNo: 1, date: Date())
        order.uncancel()
        XCTAssertFalse(order.cancelled)
        XCTAssertFalse(order.settled)
    }
    
    func testUnsettle() {
        var order = CodableOrder(orderNo: 1, date: Date())
        order.unsettle()
        XCTAssertFalse(order.settled)
        XCTAssertFalse(order.cancelled)
    }
}
