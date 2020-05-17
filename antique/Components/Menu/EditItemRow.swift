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
    let id : String
    let item : MenuItem
    let sectionSelection : Int
    @Binding var editItemID : String
    @Binding var editingItem : Bool
    @Binding var activeSheet : ActiveSheet
    @Binding var itemForEdit : MenuItem
    @Binding var menuSectionSelection : Int
    var body: some View {
        Button(action: setSelectedItem) {
            HStack(alignment: .center) {
                Text(item.name)
                Spacer()
                Text(String(format: "$%.02f", item.price))
                    .foregroundColor(Color(red:0.31, green:0.85, blue:0.56))
                Image(systemName: "square.and.pencil")
                    .padding(.bottom, 5)
            }
        }
    }
    
    func setSelectedItem() {
        self.editItemID = self.id
        self.itemForEdit = self.item
        self.editingItem = true
        self.activeSheet = .editItem
        self.menuSectionSelection = self.sectionSelection
    }
}

//struct EditItemRow_Previews: PreviewProvider {
//    static let item = MenuItem(name: "Test", price: 1.5)
//    static var previews: some View {
//        EditItemRow(item: item, sectionSelection: 0)
//    }
//}
