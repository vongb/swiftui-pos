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
    
    var codableOrder : CodableOrder {
        CodableOrder(orderNo: orders.nextOrderNo, items: order.items, discPercentage: order.discPercentage, date: order.date, settled: false, cancelled: false)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            OrderTotalLabel(total: self.order.total)
            
            Divider().frame(width: 300)
            
            ChangeCalculator(total: self.order.total)
            
            Divider().frame(width: 300)
            
            Group {
                HStack {
                    // Save Order
                    Button(action: self.saveOrder) {
                        Text("Save Order")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .frame(width: 120)
                    .background(styles.colors[4])
                    .cornerRadius(20)

                    Spacer().frame(width: 50)

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
            ReceiptPrinter(codableOrder: getCodable(), justPrint: false)
        }
        .padding(20)
        .background(styles.colors[0])
        .cornerRadius(20)
        .onTapGesture {
            UIApplication.shared.endEditing()
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
        return CodableOrder(CodableOrderDTO(orderNo: orders.nextOrderNo,items: order.items, discPercentage: order.discPercentage, date: order.date))
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
