//
//  OrderConfirm.swift
//  antique
//
//  Created by Vong Beng on 25/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderConfirm: View {
    @EnvironmentObject var order : Order
    var body: some View {
        NavigationLink(destination : OrderConfirmView()) {
            HStack {
                if order.items.count == 0 {
                    Text("Confirm Order")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.gray)
                } else {
                    Text("Confirm Order")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(10)
            .background(Color.green)
        }
        .disabled(self.order.items.count == 0)
    }
}

struct OrderConfirm_Previews: PreviewProvider {
    static var previews: some View {
        OrderConfirm()
    }
}
