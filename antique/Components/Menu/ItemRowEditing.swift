//
//  ItemRowEditing.swift
//  antique
//
//  Created by Vong Beng on 19/20/20.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct ItemRowEditing: View {
    @Binding var items : [OrderItem]
    let item : MenuItem
    
    var body: some View {
        NavigationLink(destination : DetailedViewEditing(items: self.$items, item: item)) {
            HStack() {
                Text(item.name)
                Spacer()
                Text(String(format: "$%.02f", item.price))
                    .foregroundColor(Color(red:0.31, green:0.85, blue:0.56))
            }
        }
    }
}

//struct ItemRowEditing_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRowEditing(item: MenuItem(name: "Test Latte", price: 2.25, hasSugarLevels: false, iceLevelIndex: 1, hasIceLevels: true))
//    }
//}
