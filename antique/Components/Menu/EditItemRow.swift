//
//  EditItemRow.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct EditItemRow: View {
    let item : MenuItem
    var body: some View {
        NavigationLink(destination : EditItem(item: item)) {
            HStack() {
                Text(item.name)
                Spacer()
                Text(String(format: "$%.02f", item.price))
                    .foregroundColor(Color(red:0.31, green:0.85, blue:0.56))
            }
        }
    }
}

struct EditItemRow_Previews: PreviewProvider {
    static let item = MenuItem(name: "Test", price: 1.5)
    static var previews: some View {
        EditItemRow(item: item)
    }
}
