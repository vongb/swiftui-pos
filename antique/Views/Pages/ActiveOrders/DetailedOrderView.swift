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
    @Environment(\.presentationMode) var presentationMode

    @State var order : CodableOrder
    @State var editingOrder : Bool = false
    @State var canUnsettle : Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                HStack {
                    BlackText(text: "Order No: #\(order.orderNo)", fontSize: 40)
                    Spacer()
                    if !order.cancelled && !order.settled {
                        Button(action: edit) {
                            Text("Edit")
                                .padding(10)
                                .foregroundColor(.white)
                        }
                        .background(Styles.getColor(.darkCyan))
                        .cornerRadius(20)
                    }
                }

                HStack {
                    Text(String(format: "Total: $%.02f", self.order.total))
                        .bold()
                        .padding(5)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(Styles.getColor(.darkCyan))
                        .cornerRadius(10)
                    
                    OrderStatusLabel(cancelled: order.cancelled, settled: order.settled)
                    
                    Spacer()
                    
//                    if !order.settled {
                        SettleOrUnsettleButton(order: $order, canUnsettle: self.canUnsettle)
//                    }
                }
            }
            // Body
            ScrollView {
                HStack {
                    Text("Discounts:")
                    Spacer()
                    Text("\(self.order.discountDisplay)")
                }
                Divider()
                HStack {
                    Text("Subtotal:")
                    Spacer()
                    Text("\(String(format: "$%.02f", self.order.subtotal))")
                }
                Divider()
                Group {
                    HStack {
                        Text("Time:")
                        Spacer()
                        Text("\(time())")
                    }
                    HStack {
                        Text("Date:")
                        Spacer()
                        Text("\(date())")
                    }
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
        .background(Styles.getColor(.lightGreen))
        .cornerRadius(20)
        .frame(width: 600)
        .sheet(isPresented: $editingOrder, onDismiss: endEdit) {
            EditOrder(order: self.$order, editingOrder: self.$editingOrder, canDelete: true)
                .environmentObject(self.menu)
        }
    }
    
    func endEdit() {
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
    static let order = CodableOrder(CodableOrderDTO())
    static let printer = BLEConnection()
    static var previews: some View {
        DetailedOrderView(order: order)
            .environmentObject(printer)
            .environmentObject(orders)
    }
}
