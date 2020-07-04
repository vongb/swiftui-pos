//
//  OrderSummary.swift
//  antique
//
//  Created by Vong Beng on 24/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderSummary: View {
    @EnvironmentObject var order : Order
    @State var isRiels : Bool = true
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Subtotal")
                    .font(.callout)
                Spacer()
                Text(String(format: "$%.02f", order.subtotal))
                    .font(.headline)
            }
        }
        .padding(10)
        .background(Color(red:0.64, green:0.83, blue:0.68))
    }
}

struct OrderSummary_Previews: PreviewProvider {
    static let order = Order()
    static var previews: some View {
        OrderSummary().environmentObject(order)
    }
}
