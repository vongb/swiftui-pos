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
    
    @State var editingCents = false
    @State var editingRiels = false

    @EnvironmentObject var orders : Orders
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Styles.getColor(.lightGreen))
                .frame(width: 350, height: ((self.editingCents || self.editingRiels) ? 600 : 500))
                .cornerRadius(20)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation{
                        self.editingRiels = false
                        self.editingCents = false
                    }
                }
            VStack(alignment: .center, spacing: 10) {
                Spacer().frame(height: 10)
                OrderTotalLabel(total: self.order.total)
                
                Divider().frame(width: 300)
                
                ScrollView {
                    ChangeCalculator(total: self.order.total, editingCents: self.$editingCents, editingRiels: self.$editingRiels)
                    
                    Divider().frame(width: 300)
                    
                    // Update Order
                    HStack(spacing: 25) {
                        Button(action: saveOrder) {
                            Text("Save Order")
                                .padding(10)
                                .foregroundColor(.white)
                        }
                        .frame(width: 120)
                        .background(Styles.getColor(.lightRed))
                        .cornerRadius(20)
                        
                        Button(action: settleOrder) {
                            Text("Settle Order")
                                .padding(10)
                                .foregroundColor(.white)
                        }
                        .frame(width: 120)
                        .background(Color.green)
                        .cornerRadius(20)
                    }
                    Spacer().frame(height: 15)
                }
            }
        }
        .padding()
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
