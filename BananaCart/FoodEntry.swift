//
//  FoodEntry.swift
//  BananaCart
//
//  Created by Austin McKee on 9/19/15.
//  Copyright © 2015 Austin McKee. All rights reserved.
//

import Foundation

class FoodEntry {
    var name: NSString
    var id : NSString
    var price : Double
    var weight : Double
    var lastScanned : NSDate
    var quantity : integer_t
    
    static let scanTimeout : Double = 5.0
    
    init(name: NSString, id: NSString, price: Double, weight: Double) {
        self.name = name
        self.id = id
        self.price = price
        self.weight = weight
        
        // Zero quantity
        self.quantity = 1
        
        // Set to Unix epoch
        self.lastScanned = NSDate(timeIntervalSince1970: NSTimeInterval(0))
    }
    
    func scan() {
        self.lastScanned = NSDate()
    }
    func canScan() -> Bool {
        return ((NSDate().timeIntervalSince1970 - lastScanned.timeIntervalSince1970) > FoodEntry.scanTimeout)
    }
    
    func copy() -> FoodEntry {
        return FoodEntry(name: name, id: id, price: price, weight: weight)
    }
}
