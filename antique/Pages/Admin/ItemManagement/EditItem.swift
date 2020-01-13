//
//  EditItem.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct EditItem: View {
    @EnvironmentObject var styles : Styles
    var item : MenuItem
    
    var body: some View {
        BlackText(text: item.name, fontSize: 40)
    }
}

struct EditItem_Previews: PreviewProvider {
    static let styles = Styles()
    static let item = MenuItem(name: "Iced Chocolate", price: 1.5)
    static var previews: some View {
        EditItem(item: item).environmentObject(styles)
    }
}
