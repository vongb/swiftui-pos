//
//  OrderSummaryOrderEditing.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderSummaryOrderEditing: View {
    @Binding var order : CodableOrder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Subtotal")
                Spacer()
                Text(String(format: "$%.02f", self.order.subtotal))
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
                Text(String(self.order.discPercentage) + "%")
                
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
                Text(String(format: "$%.02f", self.order.total))
            }
        }
        .padding(10)
        .background(Color(red:0.64, green:0.83, blue:0.68))
    }
}

//struct OrderSummaryOrderEditing_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderSummaryOrderEditing()
//    }
//}
