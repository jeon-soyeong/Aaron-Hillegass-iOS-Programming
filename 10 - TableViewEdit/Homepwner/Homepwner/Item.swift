//
//  Item.swift
//  Homepwner
//
//  Created by 전소영 on 2021/06/29.
//

//import Foundation
import UIKit

class Item: NSObject {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: NSData
    var overFlag: Bool
    
    init(name: String, valueInDollars: Int, serialNumber: String?, overFlag: Bool) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = NSData()
        self.overFlag = overFlag
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber =
            NSUUID().uuidString.components(separatedBy: "-").first!
            
            if randomValue >= 50 {
                self.init(name: randomName,
                          valueInDollars: randomValue, serialNumber: randomSerialNumber, overFlag: true)
            } else {
                self.init(name: randomName,
                          valueInDollars: randomValue, serialNumber: randomSerialNumber, overFlag: false)
            }
            
        }
        else { 
            self.init(name: "", valueInDollars: 0, serialNumber: nil, overFlag: false)
        }
    }
}
