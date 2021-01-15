//
//  CodableMenuSection.swift
//  antique
//
//  Created by Vong Beng on 4/7/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation

struct MenuSection: Codable, Identifiable, Hashable, Equatable {
    let id : UUID = UUID()
    var name: String
    var items: [MenuItem]
    
    enum CodingKeys : String, CodingKey {
        case name
        case items
    }
    
    func contains(_ id: String) -> Int {
        for(index, menuItem) in self.items.enumerated() {
            print(menuItem.id.uuidString)
            if id == menuItem.id.uuidString {
                print("Found item in MenuSection")
                return index
            }
        }
        print("Not found asf")
        return -1;
    }
    
    mutating func add(_ item: MenuItem) {
        self.items.append(item)
    }
    
    mutating func update(id: String, item: MenuItem) {
        let index = contains(id)
        if index != -1  {
            self.items[index].update(item)
        }
    }
    
    mutating func remove(_ id: String) {
        let index = self.contains(id)
        if index != -1 {
            self.items.remove(at: index)
        }
    }
}
