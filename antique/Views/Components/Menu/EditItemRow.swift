//
//  EditItemRow.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

// Item row for editing MenuItems
struct EditItemRow: View {
    @EnvironmentObject var menu : Menu
    var sectionName : String
    var item : MenuItem
    
    @State private var showingItemDetails : Bool = false
    
    var body: some View {
        NavigationLink(destination: ItemEditor(id: item.id.uuidString, item: item, sectionName: sectionName)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(String(format: "$%.02f", item.price))
                        .font(.caption)
                        .foregroundColor(.green)
                }
                Spacer()
            }
        }
    }
}

