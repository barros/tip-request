//
//  Payment.swift
//  Tip Request
//
//  Created by Jeffrey Barros Peña on 4/21/18.
//  Copyright © 2018 Barros Peña. All rights reserved.
//

import Foundation

class Payment: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.subtotal, forKey: "subtotal")
        print("(debug): self.subtotal = \(self.subtotal)")
        aCoder.encode(self.tip, forKey: "tip")
        aCoder.encode(self.total, forKey: "total")
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.timeZone, forKey: "timezone")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.subtotal = aDecoder.decodeDouble(forKey: "subtotal")
        self.tip = aDecoder.decodeDouble(forKey: "tip")
        self.total = aDecoder.decodeDouble(forKey: "total")
        if let location = aDecoder.decodeObject(forKey: "location") as? String {
            self.location = location
        }
        if let date = aDecoder.decodeObject(forKey: "date") as? Date {
            self.date = date
        }
        if let timeZone = aDecoder.decodeObject(forKey: "timezone") as? String {
            self.timeZone = timeZone
        }
    }
    
    var subtotal: Double = 0
    var tip: Double = 0
    var total: Double = 0
    var location: String = ""
    var date: Date = Date()
    var timeZone: String = ""
    
    func paymentInit(subtotal: Double, tip: Double, total: Double, location: String, date: Date, timeZone: String) {
        self.subtotal = subtotal
        self.tip = tip
        self.total = total
        self.location = location
        self.date = date
        self.timeZone = timeZone
    }
    
    override init() {
        super.init()
        self.paymentInit(subtotal: 0.0, tip: 10.0, total: 0.0, location: "", date: Date(), timeZone: TimeZone.current.identifier)
    }
}
