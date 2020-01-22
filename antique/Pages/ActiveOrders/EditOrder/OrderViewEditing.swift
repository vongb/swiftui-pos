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
    @Binding var items : [OrderItem]
    @Binding var discPercentage : Int
    var orderNo : Int
    var subtotal : Double
    var total : Double

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    OrderHeader()
                    ForEach(items) { orderItem in
                        OrderRow(orderItem: orderItem)
                    }
                    .onDelete(perform: delete)
                }
                .padding(0)
                OrderSummaryOrderEditing(discPercentage: self.$discPercentage, subtotal: self.subtotal, total: self.total)
                OrderConfirmEditingButton(editingOrder: self.$editingOrder, total: self.total)
            }
            .navigationBarTitle("Editing Order #\(String(self.orderNo))")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func delete(at offsets: IndexSet) {
        if self.items.count > 1 {
            self.items.remove(atOffsets: offsets)
        }
    }
}

//struct OrderViewEditing_Previews: PreviewProvider {
//    static let order = CodableOrder(CodableOrderDTO())
//    static var previews: some View {
//        OrderViewEditing(order: order)
//    }
//}
