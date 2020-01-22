//
//  CancelOrderButton.swift
//  antique
//
//  Created by Vong Beng on 18/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct CancelOrderButton: View {
    @Binding var order : CodableOrder
    @EnvironmentObject var orders : Orders
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        if !self.order.cancelled {
            return Button(action: cancel) {
                Text("Cancel")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(Color.red)
            .cornerRadius(20)
        } else {
            return Button(action: uncancel) {
                Text("Uncancel")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(Color.red)
            .cornerRadius(20)
        }
    }
    
    func cancel() {
        self.order.cancel()
        updateAndRefreshOrders()
    }
    
    func uncancel() {
        self.order.uncancel()
        updateAndRefreshOrders()
    }
    
    func updateAndRefreshOrders(){
        Bundle.main.updateOrder(order: order)
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
}

//struct CancelOrderButton_Previews: PreviewProvider {
//    @State var order = Order()
//    static var previews: some View {
//        CancelOrderButton(order: $order)
//    }
//}
