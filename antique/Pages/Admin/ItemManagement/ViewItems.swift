//
//  EditItem.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ViewItems: View {
    @EnvironmentObject var styles : Styles
    @EnvironmentObject var menu : Menu
    var body: some View {
        NavigationView {
            List {
                ForEach(menu.items) { section in
                    Section(header: Text(section.name)) {
                        ForEach(section.items) { item in
                            EditItemRow(item: item)
                        }
                    }
                }
            }
            .navigationBarTitle("Menu Items")
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}

struct ViewItems_Previews: PreviewProvider {
    static let styles = Styles()
    static let menu = Menu()
    static var previews: some View {
        ViewItems().environmentObject(styles).environmentObject(menu)
    }
}
