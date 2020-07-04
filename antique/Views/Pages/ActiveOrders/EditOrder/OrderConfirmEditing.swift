//
//  OrderConfirmEditing.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderConfirmEditing: View {
    let contentWidth : CGFloat = 300
    @Binding var editingOrder : Bool
    @Binding var order : CodableOrder
    @State var discountValue : Int
    @State var discountSelection : Int
    
    @State private var showDiscount : Bool = false
    @State private var showCalculator = false
    
    @State private var editingCents = false
    @State private var editingRiels = false
    @EnvironmentObject var orders : Orders
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
            .fill(Styles.getColor(.lightGreen))
            .frame(width: contentWidth + 50, height: (showDiscount || showCalculator) ? 600 : 350)
            .cornerRadius(20)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation{
                    self.editingRiels = false
                    self.editingCents = false
                    self.showCalculator = false
                    self.showDiscount = false
                }
            }
            VStack(alignment: .center, spacing: 10) {
                OrderSubtotalLabel(subtotal: self.order.subtotal)
                OrderTotalLabel(total: self.order.total)
                
                Divider()
                    .frame(width: contentWidth)
                
                ScrollView {
                    HStack(spacing: 25) {
                        if !self.showCalculator {
                            DiscountApplier(showDiscount: self.$showDiscount,
                                            value: $discountValue,
                                            discPercentage: self.$order.discPercentage,
                                            isDiscPercentage: self.$order.isDiscPercentage,
                                            discAmountInUSD: self.$order.discAmountInUSD,
                                            selection: $discountSelection)
                        }
                        
                        if !self.showDiscount {
                            ChangeCalculator(showCalculator: self.$showCalculator,
                                             total: self.order.total,
                                             editingCents: self.$editingCents,
                                             editingRiels: self.$editingRiels)
                        }
                    }
                    
                    Divider()
                        .frame(width: contentWidth)
                    
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
//
//struct OrderConfirmEditing_Previews: PreviewProvider {
//    static let order = Order()
//    static let orders = Orders()
//    static let connection = BLEConnection()
//    static var previews: some View {
//        OrderConfirmEditing().environmentObject(order).environmentObject(connection).environmentObject(orders)
//    }
//}
