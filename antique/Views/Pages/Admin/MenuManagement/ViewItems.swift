//
//  EditItem.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ViewItems: View {
    @EnvironmentObject var menu : Menu
    
    var body: some View {
            List {
                ForEach(self.menu.items, id: \.self) { section in
                    Section(header: Text(section.name)) { // section
                        ForEach(section.items, id: \.self) { item in
                            EditItemRow(sectionName: section.name, item: item)
                        }
                        .onMove { (indexSet, destination) in
                            self.move(from: indexSet, to: destination, section: self.menu.getSectionIndex(name: section.name))
                        }
                        .onDelete(perform: { offsets in
                            self.menu.deleteMenuItem(offsets, self.menu.getSectionIndex(name: section.name))
                        })
                    }
                }
            }
            .navigationBarTitle(Text("Menu"))
            .navigationBarItems(trailing: EditButton())
    }
    
    func move(from source: IndexSet, to destination: Int, section: Int) {
        self.menu.items[section].items.move(fromOffsets: source, toOffset: destination)
        self.menu.update()
        self.menu.refreshMenuItems()
    }
}
//
//struct ViewItems_Previews: PreviewProvider {
//    static let menu = Menu()
//    static var previews: some View {
//        ViewItems().environmentObject(styles).environmentObject(menu)
//    }
//}
