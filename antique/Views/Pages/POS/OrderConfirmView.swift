//
//  OrderConfirmView.swift
//  antique
//
//  Created by Vong Beng on 25/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI
import Combine

struct OrderConfirmView: View {
    let contentWidth : CGFloat = 400
    @EnvironmentObject var order : Order
    @EnvironmentObject var orders : Orders
    @Environment(\.presentationMode) var presentationMode
    
    @State private var discountValue : Int = 0
    @State private var showDiscount : Bool = false
    @State private var showCalculator : Bool = false
    
    @State private var editingTableNo : Bool = true
    @State private var editingCents : Bool = false
    @State private var editingRiels : Bool = false
    @State private var discountSelection : Int = 0
    
    @State private var confirmingSettle : Bool = false
    var height : CGFloat {
        showDiscount || showCalculator || editingTableNo ? 600 : 350
    }
    
    var codableOrder : CodableOrder {
        CodableOrder(orderNo: orders.nextOrderNo,
                     tableNo: order.tableNo,
                     items: order.items,
                     discPercentage: order.discPercentage,
                     isDiscPercentage: order.isDiscPercentage,
                     discAmountInUSD: order.discAmountInUSD,
                     date: order.date,
                     settled: false,
                     cancelled: false)
    }
    
    @State private var showChangeCalc : Bool = false
        var body: some View {
            ZStack(alignment: .top) {
                Rectangle()
                        .fill(Styles.getColor(.lightGreen))
                        .frame(width: contentWidth + 50, height: height)
                        .cornerRadius(20)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation{
                                self.editingRiels = false
                                self.editingCents = false
                                self.showCalculator = false
                                self.showDiscount = false
                                self.editingTableNo = false
                            }
                        }
                VStack(alignment: .center, spacing: 10) {
                    OrderSubtotalLabel(subtotal: self.order.subtotal)
                    OrderTotalLabel(total: self.order.total)
                
                    Divider()
                        .frame(width: contentWidth)
                        
                    ScrollView {
                        
                        HStack(spacing: 50) {
                            if !self.showCalculator {
                                DiscountApplier(showDiscount: self.$showDiscount, value: $discountValue, discPercentage: self.$order.discPercentage, isDiscPercentage: self.$order.isDiscPercentage, discAmountInUSD: self.$order.discAmountInUSD, selection: $discountSelection)
                            }
                            
                            if !self.showDiscount {
                                ChangeCalculator(showCalculator: self.$showCalculator, total: self.order.total, editingCents: self.$editingCents, editingRiels: self.$editingRiels)
                            }
                        }
                        
                        Divider()
                            .frame(width: contentWidth)
                        
                        // Table Number
                        TableNumberEntry(editing: $editingTableNo, tableID: $order.tableNo)
                        
                        if !editingTableNo {
                            // Save or Settle
                            HStack(spacing: 50) {
                                // Save Order
                                Button(action: saveOrder) {
                                    Text("Save Order")
                                        .padding(10)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 120)
                                .background(Styles.getColor(.lightRed))
                                .cornerRadius(20)

                                // Confirm Order Button
                                Button(action: { self.confirmingSettle = true }) {
                                    Text("Settle Order")
                                        .padding(10)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 120)
                                .background(Color.green)
                                .cornerRadius(20)
                            }
                            ReceiptPrinter(codableOrder: codableOrder)
                        }
                    }
                }
                .padding()
                .alert(isPresented: $confirmingSettle) {
                    Alert(title: Text("Settle Order?"), primaryButton: .default(Text("Confirm"), action: self.settleOrder), secondaryButton: .cancel())
            }
        }
    }
    
    func saveOrder() {
        self.orders.date = Date()
        self.orders.refreshSavedOrders() // Refresh for updated order number
        self.order.settleOrder(orderNo: orders.nextOrderNo, settled: false)
        updateAndRefresh()
    }
    
    func settleOrder() {
        self.orders.date = Date()
        self.orders.refreshSavedOrders()  // Refresh for updated order number
        self.order.settleOrder(orderNo: orders.nextOrderNo)
        updateAndRefresh()
    }
    
    func updateAndRefresh() {
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct OrderConfirmView_Previews: PreviewProvider {
    static let order = Order()
    static let orders = Orders()
    static let connection = BLEConnection()
    static var previews: some View {
        OrderConfirmView().environmentObject(order).environmentObject(connection).environmentObject(orders)
    }
}
