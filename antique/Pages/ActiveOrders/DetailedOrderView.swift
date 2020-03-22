//
//  DetailedOrderView.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct DetailedOrderView: View {
    @EnvironmentObject var printer : BLEConnection
    @EnvironmentObject var menu : Menu
    @EnvironmentObject var orders : Orders
    @ObservedObject var styles = Styles()
    @Environment(\.presentationMode) var presentationMode

    @State var order : CodableOrder
    @State var editingOrder : Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                HStack {
                    BlackText(text: "Order No: #\(order.orderNo)", fontSize: 40)
                    Spacer()
                    if !order.cancelled {
                        Button(action: edit) {
                            Text("Edit")
                                .padding(10)
                                .foregroundColor(.white)
                        }
                        .background(styles.colors[2])
                        .cornerRadius(20)
                    }
                }

                HStack {
                    Text(String(format: "Total: $%.02f", self.order.total))
                        .bold()
                        .padding(5)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(styles.colors[2])
                        .cornerRadius(10)
                    
                    OrderStatusLabel(cancelled: order.cancelled, settled: order.settled)
                    
                    Spacer()
                    
                    SettleOrUnsettleButton(order: $order)
                }
            }
            ScrollView {
                Text("Discounts: \(self.order.discPercentage)%")
                
                Text("Subtotal: \(String(format: "$%.02f", self.order.subtotal))")
                
                Divider()
                Group {
                    Text("Time: \(time())")
                    Text("Date: \(date())")
                }
                
                Group {
                    OrderHeader()
                    if order.items.count > 0 {
                        ForEach(order.items) { orderItem in
                            OrderRow(orderItem: orderItem)
                        }
                    } else {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("No Items")
                            Spacer()
                        }
                    }
                    Divider()
                }
                HStack {
                    ReceiptPrinter(codableOrder: order)
                    Spacer()
                    CancelOrderButton(order: $order)
                }
                
            }
        }
        .padding(20)
        .background(styles.colors[0])
        .cornerRadius(20)
        .frame(width: 600)
        .sheet(isPresented: $editingOrder, onDismiss: endEdit) {
            EditOrder(order: self.$order, editingOrder: self.$editingOrder)
                .environmentObject(self.menu)
                .environmentObject(self.styles)
        }
    }
    
    func endEdit() {
        self.order.cancelled = false
        self.order.settled = false
        Bundle.main.updateOrder(order: self.order)
        self.orders.refreshSavedOrders()
    }
    
    func date() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self.order.date)
    }
    
    func time() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: self.order.date)
    }
    
    func edit() {
        editingOrder.toggle()
    }
    
}

struct DetailedOrderView_Previews: PreviewProvider {
    static let orders = Orders()
    static let styles = Styles()
    static let order = CodableOrder(CodableOrderDTO())
    static let printer = BLEConnection()
    static var previews: some View {
        DetailedOrderView(order: order)
            .environmentObject(printer)
            .environmentObject(styles)
            .environmentObject(orders)
    }
}
