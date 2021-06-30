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
    var overItemFirst = true
    var notOverItemFirst = true
    var itemFirst = true
    
    func createItem() -> [Item:Int] {
        let newItem = Item(random: true)
        var index = 2
        
        if newItem.overFlag {
            if overItemFirst {
                overItem.append(newItem)
                if itemFirst {
                    allItems.insert(overItem, at: 0)
                    allItems.insert([], at: 1)
                    itemFirst = false
                }
                overItemFirst = false
            } else {
                allItems[0].append(newItem)
            }
            print("overItem: \(overItem)")
            index = 0
        } else {
            if notOverItemFirst {
                notOverItem.append(newItem)
                if itemFirst {
                    allItems.insert([], at: 0)
                    allItems.insert(notOverItem, at: 1)
                    itemFirst = false
                }
                notOverItemFirst = false
            } else {
                allItems[1].append(newItem)
            }
            print("notOverItem: \(notOverItem)")
            index = 1
        }
        print("allItems: \(allItems)")
        return [newItem:index]
    }
}
