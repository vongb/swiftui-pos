//
//  CategoryReport.swift
//  antique
//
//  Created by Vong Beng on 11/9/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import Combine

class CategoryReport: ObservableObject {
    var menuSections: [String]
    private let menuDictionary: [String : Set<String>] = Menu.getMenuDictionary()
    
    @Published var sectionSelection: Int {
        willSet {
            filteringItems = true
        }
        didSet {
            refilterItems()
        }
    }

    @Published var date: Date {
        willSet {
            loadingItems = true
        }
        didSet {
            refreshOrders()
            
        }
    }
    @Published var includeWholeMonth: Bool {
        willSet {
            loadingItems = true
        }
        didSet {
            refreshOrders()
        }
    }
    private var savedOrders: [CodableOrder]
    @Published var loadingItems: Bool
    
    @Published var filteredItems: [ItemOrdered]
    @Published var filteredItemsTotal: Double
    @Published var filteringItems: Bool
    
    init() {
        menuSections = Menu.getMenuSections()
        menuSections.append("Deleted Items")
        
        date = Date()
        includeWholeMonth = false
        sectionSelection = 0

        savedOrders = Bundle.main.readOrders(orderDate: Date())
        loadingItems = false
        
        filteredItems = []
        filteredItemsTotal = 0.0
        filteringItems = true
    }
    
    private func findSection(_ itemName: String) -> Int {
        for (index, section) in menuSections.enumerated() {
            if menuDictionary[section]?.contains(itemName) ?? false {
                return index
            }
        }
        // Gives index of deleted items
        return menuSections.count - 1
    }
    
    func refreshOrders() {
        loadingItems = true
        savedOrders.removeAll()
        if self.includeWholeMonth {
            self.savedOrders = Bundle.main.readMonthOrders(orderDate: self.date)
        } else {
            self.savedOrders = Bundle.main.readOrders(orderDate: self.date)
        }
        self.loadingItems = false
        refilterItems()
    }
    
    func refilterItems() {
        filteringItems = true
        DispatchQueue.global(qos: .userInteractive).async {
            print("Saved Orders Count: \(self.savedOrders.count)")
            // Map that stores name : index of order menu items for itemsOrdered below
            var itemsOrderedMap : [String : Int] = [:]
            var itemsOrdered = [ItemOrdered]()
            var filteredItemsTotal = 0.0
            self.savedOrders.forEach { order in
                if !order.cancelled {
                    order.items.forEach { orderItem in
                        let sectionIndex = self.findSection(orderItem.item.name)
                        print("Item Section: \(self.menuSections[sectionIndex])")
                        print("Selected Section: \(self.menuSections[self.sectionSelection])")
                        if self.menuSections[sectionIndex] == self.menuSections[self.sectionSelection] {
                            filteredItemsTotal += orderItem.total
                            // If exists in itemsOrdered array

                            if let itemsOrderIndex = itemsOrderedMap[orderItem.item.name] {
                                itemsOrdered[itemsOrderIndex].qty += orderItem.qty
                                itemsOrdered[itemsOrderIndex].itemTotal += orderItem.total
                            } else {
                                // Else add it to the array and its index to the map
                                itemsOrdered.append(ItemOrdered(item: orderItem.item, qty: orderItem.qty, itemTotal: orderItem.total, date: order.date))
                                itemsOrderedMap[orderItem.item.name] = itemsOrdered.count - 1
                            }
                        }
                    }
                }
            }
            print("big for loop finito")
            DispatchQueue.main.async {
                self.filteringItems = false
                self.filteredItemsTotal = filteredItemsTotal
                self.filteredItems = itemsOrdered.sorted(by: {$0.qty > $1.qty})
            }
        }
    }
}
