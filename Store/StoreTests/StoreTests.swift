//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testAddSingleItem() {
        register.scan(Item(name: "Milk", priceEach: 399))
        XCTAssertEqual(399, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(399, receipt.total())
        let expectedReceipt = """
Receipt:
Milk: $3.99
------------------
TOTAL: $3.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testTwoForOneDiscount() {
        let twoForOne = PricingScheme()
        twoForOne.addBuyTwoGetOneItem(Item(name: "Milk", priceEach: 399))
        register  = Register(discount: twoForOne)
        register.scan(Item(name: "Milk", priceEach: 399))
        XCTAssertEqual(399, register.subtotal())
        register.scan(Item(name: "Milk", priceEach: 399))
        XCTAssertEqual(798, register.subtotal())
        register.scan(Item(name: "Milk", priceEach: 399))
        XCTAssertEqual(798, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(798, receipt.total())
        let expectedReceipt = """
Receipt:
Milk: $3.99
Milk: $3.99
Milk: $3.99
MilkBuy2Get1Discount: $-3.99
------------------
TOTAL: $7.98
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
}
