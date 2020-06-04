//
//  OrderViewLocal.swift
//  antique
//
//  Created by Vong Beng on 18/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderViewEditing: View {
    @Binding var editingOrder : Bool
    @Binding var order : CodableOrder

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    OrderHeader()
                    ForEach(self.order.items) { orderItem in
                        OrderRow(orderItem: orderItem)
                    }
//                    .onDelete(perform: delete)
                }
                .padding(0)
                OrderSummaryOrderEditing(order: self.$order)
                OrderConfirmEditingButton(editingOrder: self.$editingOrder, order: self.$order)
            }
            .navigationBarTitle("Editing Order #\(String(self.order.orderNo))")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func delete(at offsets: IndexSet) {
        if self.order.items.count > 1 {
            self.order.items.remove(atOffsets: offsets)
        }
    }
}

//struct OrderViewEditing_Previews: PreviewProvider {
//    static let order = CodableOrder(CodableOrderDTO())
//    static var previews: some View {
//        OrderViewEditing(order: order)
//    }
//}
