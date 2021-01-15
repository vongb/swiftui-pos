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
    @State private var paymentTypes: [String] = UserDefKeys.getPaymentTypes() ?? [""]
    @State private var paymentTypeIndex: Int = 0
    
    @Binding var order : CodableOrder
    @EnvironmentObject var orders : Orders
    var canUnsettle : Bool = false
    
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if !order.cancelled {
                if !order.settled {
                    if !confirmingSettle {
                        Button(action: {withAnimation {self.confirmingSettle = true}}) {
                            Text("Settle Order")
                                .padding(10)
                                .foregroundColor(.white)
                        }
                        .background(Styles.getColor(.darkGreen))
                        .cornerRadius(20)
                    } else {
                        Text("Select Payment Type")
                        Picker("Payment Type", selection: $paymentTypeIndex) {
                            ForEach(0..<paymentTypes.count) { index in
                                Text(paymentTypes[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Button(action: {
                            withAnimation {
                                settle()
                            }
                        }) {
                            Text("Settle Order")
                                .padding(10)
                                .foregroundColor(.white)
                        }
                        .background(Color.green)
                        .cornerRadius(20)
                    }
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
    }
    
    func unsettle() {
        order.unsettle()
        updateAndRefreshOrders()
    }
    
    func settle() {
        order.paymentType = paymentTypes[paymentTypeIndex]
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
