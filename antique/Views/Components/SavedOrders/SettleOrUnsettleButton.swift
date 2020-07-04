//
//  SettleOrderButton.swift
//  antique
//
//  Created by Vong Beng on 18/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct SettleOrUnsettleButton: View {
    @State private var confirmingSettle : Bool = false
    @Binding var order : CodableOrder
    @EnvironmentObject var orders : Orders
    var canUnsettle : Bool = false
    
    var body: some View {
        Group {
            if !order.cancelled {
                if !order.settled {
                    Button(action: {withAnimation {self.confirmingSettle = true}}) {
                        Text("Settle Order")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .background(Color.green)
                    .cornerRadius(20)
                } else if canUnsettle {
                    Button(action: unsettle) {
                        Text("Unsettle Order")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .background(Styles.getColor(.lightRed))
                    .cornerRadius(20)
                }
            }
        }
        .alert(isPresented: $confirmingSettle) {
            Alert(title: Text("Settle Order?"), message: Text("Order cannot be unsettled"), primaryButton: .default(Text("Settle"), action: {
                self.settle()
            }), secondaryButton: .cancel())
        }
    }
    
    func unsettle() {
        order.unsettle()
        updateAndRefreshOrders()
    }
    
    func settle() {
        order.settle()
        updateAndRefreshOrders()
    }
    
    func updateAndRefreshOrders(){
        Bundle.main.updateOrder(order: order)
        orders.refreshSavedOrders()
    }
}

//struct SettleOrderButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SettleOrderButton()
//    }
//}
