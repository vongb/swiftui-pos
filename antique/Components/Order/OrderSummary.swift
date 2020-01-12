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
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Subtotal")
                Spacer()
                Text(String(format: "$%.02f", order.subtotal))
            }

            HStack {
                Text("Discount")
                
                Spacer()
                
                // Decrement Discount
                Button(action: {
                    self.order.decDiscount()
                }) {
                    Text("-")
                        .padding(5)
                        .foregroundColor(Color.white)
                        .frame(width: 20, height: 20)
                }
                .background(Color.red)
                .cornerRadius(10)

                // Discount Label
                Text(String(self.order.discountPercentage) + "%")
                
                // Increment Discount
                Button(action: {
                    self.order.incDiscount()
                }) {
                    Text("+")
                    .padding(5)
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)
                }
                .background(Color.green)
                .cornerRadius(10)
            }
            
            HStack {
                Text("Grand Total")
                Spacer()
                Text(String(format: "$%.02f", order.total))
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
