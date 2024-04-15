//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name : String {get}
    
    func price() -> Int
}

class Item : SKU {
    var name : String
    var itemPrice : Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.itemPrice = priceEach
    }
    
    func price () -> Int {
        return self.itemPrice
    }
}

class Receipt {
    var listOfSKU : [SKU]
    
    init() {
        self.listOfSKU = []
    }
    
    func items () -> [SKU] {
        return listOfSKU
    }
    
    func output () -> String{
        var returnText : String = "Receipt:\n"
        for sku in listOfSKU {
            returnText += sku.name + ": $" + String(Double(sku.price())/100.0) + "\n"
        }
        returnText += "------------------\nTOTAL: $\(String(Double(total())/100.0))"
        
        return returnText
    }
    
    func addSKU (_ sku : SKU) {
        listOfSKU.append(sku)
    }
    
    func total () -> Int {
        var totalAmount = 0
        for sku in listOfSKU {
            totalAmount += sku.price()
        }
        return totalAmount
    }
}

class Register {
    var receipt : Receipt
    
    init() {
        self.receipt = Receipt()
    }
    
    func subtotal () -> Int {
        return receipt.total()
    }
    
    func total () -> Receipt {
        let receiptHolder = self.receipt
        self.receipt = Receipt()
        return receiptHolder
    }
    
    func scan (_ sku : SKU) {
        receipt.addSKU(sku)
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

