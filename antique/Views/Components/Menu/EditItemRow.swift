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
    @Binding var item : MenuItem
    @State var sectionName : String
    
    @State private var showingItemDetails : Bool = false
    
    var body: some View {
        Button(action: {
            self.showingItemDetails = true
        }) {
            HStack(alignment: .center) {
                Text(item.name)
                Spacer()
                Text(String(format: "$%.02f", item.price))
                    .foregroundColor(.green)
                Image(systemName: "square.and.pencil")
                    .padding(.bottom, 5)
            }
        }
        .sheet(isPresented: $showingItemDetails) {
            ItemEditor(id: self.item.id.uuidString, item: self.$item, sectionName: self.sectionName)
                .environmentObject(self.menu)
        }
    }
}

//struct EditItemRow_Previews: PreviewProvider {
//    static let item = MenuItem(name: "Test", price: 1.5)
//    static var previews: some View {
//        EditItemRow(item: item, sectionSelection: 0)
//    }
//}
