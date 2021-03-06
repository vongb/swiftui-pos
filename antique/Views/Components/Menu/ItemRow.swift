//
//  ItemRow.swift
//  antique
//
//  Created by Vong Beng on 23/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.

//  This is a component that is resused for listing
//  menu items. It displays the name and price of the item.
//  It navigates to the DetailedView screen when tapped.
//

import SwiftUI

struct ItemRow: View {
    let item : MenuItem
    
    var body: some View {
        NavigationLink(destination : DetailedView(item: item)) {
            HStack() {
                Text(item.name)
                Spacer()
                Text(String(format: "$%.02f", item.price))
                    .foregroundColor(Color(red:0.31, green:0.85, blue:0.56))
            }
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(item: MenuItem(name: "Test Latte", price: 2.25, hasSugarLevels: false, iceLevelIndex: 1, hasIceLevels: true))
    }
}
