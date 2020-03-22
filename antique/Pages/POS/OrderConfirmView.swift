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
    @EnvironmentObject var order : Order
    @EnvironmentObject var orders : Orders
    @ObservedObject var styles = Styles()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var editingCents : Bool = false
    @State private var editingRiels : Bool = false
    
    var codableOrder : CodableOrder {
        CodableOrder(orderNo: orders.nextOrderNo, items: order.items, discPercentage: order.discPercentage, date: order.date, settled: false, cancelled: false)
    }
    
    @State private var showChangeCalc : Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(styles.colors[0])
                .frame(width: 400, height: ((self.editingCents || self.editingRiels) ? 600 : 500))
                .cornerRadius(20)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation{
                        self.editingRiels = false
                        self.editingCents = false
                    }
                }
            VStack(alignment: .center, spacing: 10) {
                    OrderTotalLabel(total: self.order.total)
                
                    Divider().frame(width: 300)
                    
                ScrollView {
                    ChangeCalculator(total: self.order.total, editingCents: self.$editingCents, editingRiels: self.$editingRiels)
                    
                    Divider().frame(width: 300)
                    
                    Group {
                        HStack(spacing: 50) {
                            // Save Order
                            Button(action: self.saveOrder) {
                                Text("Save Order")
                                    .padding(10)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 120)
                            .background(styles.colors[4])
                            .cornerRadius(20)

                            // Confirm Order Button
                            Button(action: self.settleOrder) {
                                Text("Settle Order")
                                    .padding(10)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 120)
                            .background(Color.green)
                            .cornerRadius(20)
                        }
                    }
                    ReceiptPrinter(codableOrder: getCodable())
                }
            }
            .padding()
        }
    }
    
    func saveOrder() {
        self.order.settleOrder(orderNo: orders.nextOrderNo, settled: false)
        updateAndRefresh()
    }
    
    func settleOrder() {
        self.order.settleOrder(orderNo: orders.nextOrderNo)
        updateAndRefresh()
    }
    
    func updateAndRefresh() {
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func getCodable() -> CodableOrder {
        return CodableOrder(CodableOrderDTO(orderNo: orders.nextOrderNo,items: order.items, discPercentage: order.discPercentage, date: Date()))
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
