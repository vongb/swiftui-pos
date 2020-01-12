//
//  OrderView.swift
//  antique
//
//  Created by Vong Beng on 23/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var order : Order
    @EnvironmentObject var orders : Orders
    var body: some View {
        NavigationView {
            VStack(alignment: .leading,spacing: 0) {
                List {
                    OrderHeader()
                    ForEach(order.items) { orderItem in
                        OrderRow(orderItem: orderItem)
                    }
                    .onDelete(perform: delete)

                }
                .padding(0)
                OrderSummary()
                OrderConfirm()
            }
            .navigationBarTitle("Order #\(String(orders.nextOrderNo))")
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    
    func delete(at offsets: IndexSet) {
        order.items.remove(atOffsets: offsets)
    }
}

struct OrderView_Previews: PreviewProvider {
    static let order = Order()
    static let orders = Orders()
    static var previews: some View {
        OrderView()
            .environmentObject(order)
            .environmentObject(orders)
    }
}
