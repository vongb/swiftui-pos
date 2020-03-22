//
//  SettleOrderButton.swift
//  antique
//
//  Created by Vong Beng on 18/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct SettleOrUnsettleButton: View {
    @Binding var order : CodableOrder
    @EnvironmentObject var orders : Orders
    @ObservedObject var styles = Styles()

    var body: some View {
        if !order.cancelled {
            if order.settled {
                return AnyView(Button(action: unsettle) {
                    Text("Unsettle Order")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .background(styles.colors[4])
                .cornerRadius(20))
            } else {
                return AnyView(Button(action: settle) {
                    Text("Settle Order")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .background(Color.green)
                .cornerRadius(20))
            }
        } else {
            return AnyView(Text(""))
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
