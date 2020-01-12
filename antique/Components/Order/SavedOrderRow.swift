//
//  SavedOrderRow.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct SavedOrderRow: View {
    static let colors = [Color(red:0.89, green:0.98, blue:0.96),
                        Color(red:0.19, green:0.89, blue:0.79),
                        Color(red:0.07, green:0.60, blue:0.62),
                        Color(red:0.25, green:0.32, blue:0.31),
                        Color(red:0.95, green:0.51, blue:0.51),
                        Color(red:0.58, green:0.88, blue:0.83)]
    
    let order : CodableOrder
    let orderNo : Int
    
    var body: some View {
        NavigationLink(destination: DetailedOrderView(order: self.order)) {
            HStack(alignment: .center) {
                Text("# \(order.orderNo)")
                Spacer()
                if !order.settled {
                    Text("Active")
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(3)
                } else {
                    Text("Paid")
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Self.colors[3])
                        .cornerRadius(3)
                }
            }.padding(10)
        }
    }
}

struct SavedOrderRow_Previews: PreviewProvider {
    static var order = CodableOrder(orderNo: 1, settled: false)
    static var previews: some View {
        SavedOrderRow(order: order, orderNo: 2)
    }
}
