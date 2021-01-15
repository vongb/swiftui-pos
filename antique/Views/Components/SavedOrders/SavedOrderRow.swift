//
//  SavedOrderRow.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct SavedOrderRow: View {
    
    let order : CodableOrder
    let orderNo : Int
    
    var body: some View {
        NavigationLink(destination: DetailedOrderView(order: self.order)) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Table: \(order.tableNo.isEmpty ? "--" : order.tableNo)")
                        .font(.headline)
                    Text("Order: #\(order.orderNo)")
                        .font(.subheadline)
                }
                Spacer()
                OrderStatusLabel(cancelled: order.cancelled, settled: order.settled, size: 15)
            }.padding(10)
        }
    }
}

struct SavedOrderRow_Previews: PreviewProvider {
    static var order = CodableOrder(CodableOrderDTO())
    static var previews: some View {
        SavedOrderRow(order: order, orderNo: 2)
    }
}
