//
//  EditItem.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ViewItems: View {
    @Binding var editItemID : String
    @Binding var editingItem : Bool
    @Binding var activeSheet : ActiveSheet
    @Binding var itemForEdit : MenuItem
    @Binding var menuSectionSelection : Int
    var styles = Styles()
    @EnvironmentObject var menu : Menu
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<menu.items.count) { index in
                    Section(header: Text(self.menu.items[index].name)) { // section
                        ForEach(self.menu.items[index].items) { item in
                            EditItemRow(id: item.id.uuidString,item: item, sectionSelection: index, editItemID: self.$editItemID, editingItem: self.$editingItem, activeSheet: self.$activeSheet, itemForEdit: self.$itemForEdit, menuSectionSelection: self.$menuSectionSelection)
                        }
                        .onMove{ (indexSet, destination) in
                            self.move(from: indexSet, to: destination, section: index)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Menu"))
            .navigationBarItems(trailing: EditButton())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func move(from source: IndexSet, to destination: Int, section: Int) {
        self.menu.items[section].items.move(fromOffsets: source, toOffset: destination)
        Bundle.main.updateMenu(menuSections: self.menu.items)
        self.menu.refreshMenuItems()
    }
}
//
//struct ViewItems_Previews: PreviewProvider {
//    static let styles = Styles()
//    static let menu = Menu()
//    static var previews: some View {
//        ViewItems().environmentObject(styles).environmentObject(menu)
//    }
//}
