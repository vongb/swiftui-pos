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
    
    @State private var confirmingSettle: Bool = false
    @State var discountValue : Int
    @State var discountSelection : Int
    
    @State private var paymentTypes: [String] = UserDefKeys.getPaymentTypes() ?? [""]
    @State private var paymentTypeIndex: Int = 0
    
    @State private var showDiscount : Bool = false
    @State private var showCalculator = false
    
    @State private var editingTableNo : Bool = false
    @State private var editingCents = false
    @State private var editingRiels = false
    
    @EnvironmentObject var orders : Orders
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            OrderSubtotalLabel(subtotal: self.order.subtotal)
            OrderTotalLabel(total: self.order.total)
            
            Divider()
            
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
                
                // Table No
                TableNumberEntry(editing: $editingTableNo, tableID: $order.tableNo)
                
                Divider()
                
                // Update Order
                if !editingTableNo {
                    Button(action: saveOrder) {
                        Text("Save Order")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .frame(width: 120)
                    .background(Styles.getColor(.lightRed))
                    .cornerRadius(20)
                    
                    Text("or")
                    
                    Text("Select Payment Type")
                    Picker("Payment Type", selection: $paymentTypeIndex) {
                        ForEach(0..<paymentTypes.count) { index in
                            Text(paymentTypes[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Button(action: {confirmingSettle = true}) {
                        Text("Settle Order")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .frame(width: 120)
                    .background(Color.green)
                    .cornerRadius(20)
                }
            }
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Styles.getColor(.lightGreen))
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        self.editingRiels = false
                        self.editingCents = false
                        self.showCalculator = false
                        self.showDiscount = false
                    }
                })
        .padding(20)
        .alert(isPresented: $confirmingSettle) {
            Alert(title: Text("Settle Order?"), message: Text("Paid with: \(paymentTypes[paymentTypeIndex])"), primaryButton: .cancel(), secondaryButton: .default(Text("Settle"), action: settleOrder))
        }
    }
    
    func saveOrder(){
        self.order.settled = false
        self.order.cancelled = false
        self.order.paymentType = ""
        self.editingOrder = false
    }
    
    func settleOrder() {
        self.order.settled = true
        self.order.cancelled = false
        self.order.paymentType = paymentTypes[paymentTypeIndex]
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
