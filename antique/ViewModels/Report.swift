//
//  Report.swift
//  antique
//
//  Created by Vong Beng on 9/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

class Report : ObservableObject {
    var menuSections : [String]
    private let menuDictionary : [String : Set<String>] = Menu.getMenuDictionary()
    
    @Published var cashouts : Cashouts
    
    @Published var date : Date {
        willSet {
            itemsOrderedIsLoading = true
        }
        didSet {
            cashouts.date = date
            refreshSavedOrders()
        }
    }
    @Published var includeWholeMonth : Bool {
        willSet {
            itemsOrderedIsLoading = true
        }
        didSet {
            cashouts.includeWholeMonth = includeWholeMonth
            refreshSavedOrders()
        }
    }
    @Published var includeCashouts : Bool
    
    @Published var filteredItemsTotal : Double
    
    var profits: Double {
        if includeCashouts {
            return filteredItemsTotal - cashouts.total
        } else {
            return filteredItemsTotal
        }
    }
    
    @Published var collapsedCategories : Bool
    @Published var includeCategory : [Bool] {
        didSet {
            refreshSavedOrders()
        }
    }
    
    // A list of unique items ordered with their quantities and totals
    // Returns a descending array based on quantity ordered.
    @Published var itemsOrdered: [ItemOrdered]
    @Published var sectionTotals: [BarItem]
    @Published var itemsOrderedIsLoading: Bool
    
    var excludedSections : String {
        var excludedSections = "Sections excluded: None"
        for index in includeCategory.indices {
            if !includeCategory[index] {
                if excludedSections.hasSuffix(" None") {
                    excludedSections.removeLast(5)
                }
                excludedSections.append(" \(menuSections[index]),")
            }
        }
        if excludedSections.last == "," {
            excludedSections.removeLast()
        }
        return excludedSections
    }
    
    
    
    // CONSTRUCTOR
    init() {
        cashouts = Cashouts()
        date = Date()
        includeWholeMonth = false
        includeCashouts = false
        collapsedCategories = true
        filteredItemsTotal = 0.0
        
        itemsOrdered = []
        sectionTotals = []
        itemsOrderedIsLoading = true
        
        menuSections = Menu.getMenuSections()
        menuSections.append("Deleted Items")

        includeCategory = Array(repeating: true, count: menuSections.count)
    }

    private func findSection(_ itemName: String) -> Int {
        for (index, section) in menuSections.enumerated() {
            if menuDictionary[section]?.contains(itemName) ?? false {
                return index
            }
        }
        // Gives the index of Deleted Items
        return menuSections.count - 1
    }
    
    func refreshSavedOrders() {
        itemsOrderedIsLoading = true
        itemsOrdered.removeAll()
        DispatchQueue.global(qos: .userInteractive).async {
            var savedOrders = [CodableOrder]()
            if self.includeWholeMonth {
                savedOrders = Bundle.main.readMonthOrders(orderDate: self.date)
            } else {
                savedOrders = Bundle.main.readOrders(orderDate: self.date)
            }
//            print("Finished Loading Saved Orders")
//            print("Generating Report \(self.itemsOrderedIsLoading)")
            
            // Map that stores name : index of order menu items for itemsOrdered below
            var itemsOrderedMap : [String : Int] = [:]
            var itemsOrdered = [ItemOrdered]()
            var filteredItemsTotal = 0.0
            
            var sectionTotalsMap : [String : Int] = [ : ]
            var sectionTotals = [BarItem]()
            
            savedOrders.forEach { order in
                if !order.cancelled {
                    order.items.forEach { orderItem in
                        let sectionIndex = self.findSection(orderItem.item.name)
                        let sectionName = self.menuSections[sectionIndex]
                        // If it is marked to be included in report
                        if self.includeCategory[sectionIndex] {
                            filteredItemsTotal += orderItem.total // item price * qty
                            // If exists in itemsOrdered array, then update the existing qty
                            if let itemsOrderIndex = itemsOrderedMap[orderItem.item.name] {
                                itemsOrdered[itemsOrderIndex].qty += orderItem.qty
                                itemsOrdered[itemsOrderIndex].itemTotal += orderItem.total
                            } else {
                                // Else add it to the map and the array
                                itemsOrdered.append(ItemOrdered(item: orderItem.item, qty: orderItem.qty, itemTotal: orderItem.total, date: order.date))
                                itemsOrderedMap[orderItem.item.name] = itemsOrdered.count - 1
                            }
                            
                            if let sectionIndex = sectionTotalsMap[sectionName] {
                                sectionTotals[sectionIndex].amount += orderItem.total
                            } else {
                                sectionTotals.append(BarItem(label: sectionName, amount: orderItem.total))
                                sectionTotalsMap.updateValue(sectionTotals.count - 1, forKey: sectionName)
                            }
                        }
                    }
                }
            }
            
            
            DispatchQueue.main.async {
                self.itemsOrderedIsLoading = false
                self.filteredItemsTotal = filteredItemsTotal
                self.itemsOrdered = itemsOrdered.sorted(by: {$0.qty > $1.qty})
                self.sectionTotals = sectionTotals.sorted(by: {$0.label < $1.label})
                print("Is loading: \(self.itemsOrderedIsLoading)")
                print("Finished generating report \(self.itemsOrdered.count)")
            }
        }
    }
}
