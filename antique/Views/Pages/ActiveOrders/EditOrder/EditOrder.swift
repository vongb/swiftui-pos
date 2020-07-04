//
//  EditOrder.swift
//  antique
//
//  Created by Vong Beng on 18/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct EditOrder: View {
    @Binding var order : CodableOrder
    @Binding var editingOrder : Bool
    var canDelete : Bool = true
    var body: some View {
        HStack {
            MenuViewEditing(items: self.$order.items)
            OrderViewEditing(editingOrder: self.$editingOrder, order: self.$order, canDelete: self.canDelete)
        }
    }
    
    
}

//struct EditOrder_Previews: PreviewProvider {
//    static let order = CodableOrder(CodableOrderDTO())
//    static var previews: some View {
//        EditOrder(order: order)
//    }
//}
