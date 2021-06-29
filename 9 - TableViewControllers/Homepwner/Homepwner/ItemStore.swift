//
//  ItemStore.swift
//  Homepwner
//
//  Created by 전소영 on 2021/06/29.
//

//import Foundation
import UIKit

class ItemStore {
    var allItems = [[Item]]()
    var overItem = [Item]()
    var notOverItem = [Item]()
    
    func createItem() {
        let newItem = Item(random: true)
        
        if newItem.overFlag {
            overItem.append(newItem)
            print("overItem: \(overItem)")
        } else {
            notOverItem.append(newItem)
            print("notOverItem: \(notOverItem)")
        }
    }
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
        allItems.insert(overItem, at: 0)
        allItems.insert(notOverItem, at: 1)
//        allItems.append(notOverItem)
        print("allItems: \(allItems)")
    }
}
