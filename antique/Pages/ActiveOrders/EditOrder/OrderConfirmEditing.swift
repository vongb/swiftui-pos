//
//  OrderConfirmEditing.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderConfirmEditing: View {
    @Binding var editingOrder : Bool
    @Binding var order : CodableOrder
    
    @ObservedObject var styles = Styles()
    @EnvironmentObject var orders : Orders
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            OrderTotalLabel(total: self.order.total)
            
            Divider().frame(width: 300)
            
            ChangeCalculator(total: self.order.total)
            
            Divider().frame(width: 300)
            
            // Update Order
            HStack {
                Button(action: saveOrder) {
                    Text("Save Order")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .frame(width: 120)
                .background(styles.colors[4])
                .cornerRadius(20)
                
                Spacer()
                
                Button(action: settleOrder) {
                    Text("Settle Order")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .frame(width: 120)
                .background(Color.green)
                .cornerRadius(20)
            }
        }
        .padding(20)
        .background(styles.colors[0])
        .cornerRadius(20)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func saveOrder(){
        self.order.settled = false
        self.order.cancelled = false
        self.editingOrder = false
    }
    
    func settleOrder() {
        self.order.settled = true
        self.order.cancelled = false
        self.editingOrder = false
    }
}

//struct OrderConfirmEditing_Previews: PreviewProvider {
//    static let order = CodableOrder()
//    static var previews: some View {
//        OrderConfirmEditing(order)
//    }
//}
