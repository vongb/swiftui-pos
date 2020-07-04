//
//  OrderConfirmOrderEditing.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderConfirmEditingButton: View {
    @Binding var editingOrder : Bool
    @Binding var order : CodableOrder
    private var discountAmount : Int {
        if order.isDiscPercentage {
            return order.discPercentage
        } else {
            return Int(order.discAmountInUSD * 100)
        }
    }
    private var discountSelection : Int {
        if order.isDiscPercentage {
            return 0
        } else {
            return 2
        }
    }
    var body: some View {
        NavigationLink(destination : OrderConfirmEditing(editingOrder: self.$editingOrder, order: self.$order, discountValue: discountAmount, discountSelection: discountSelection)) {
            HStack {
                Text("Confirm Order")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(10)
            .background(self.order.items.count == 0 ? Color.gray : Color.green)
        }
        .disabled(self.order.items.count == 0)
    }
}

//struct OrderConfirmOrderEditing_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderConfirmOrderEditing()
//    }
//}
