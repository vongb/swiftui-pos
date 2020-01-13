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
    @EnvironmentObject var orders : Orders
    @EnvironmentObject var styles : Styles
    @Environment(\.presentationMode) var presentationMode

    var order : CodableOrder
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                BlackText(text: "Order No: #\(order.orderNo)", fontSize: 40)
                    
                Spacer().frame(height: 10)
                
                HStack {
                    DarkBlueText(text: "Total: \(String(format: "$%.02f", self.order.total))", fontSize: 30)
                    if !order.settled {
                        Text("UNPAID")
                            .bold()
                            .padding(5)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .background(styles.colors[4])
                            .cornerRadius(10)
                    }
                }
                Text("Discounts: \(self.order.discPercentage)%")
                
                Text("Subtotal: \(String(format: "$%.02f", self.order.subtotal))")
            }
            
            Spacer().frame(height: 10)
            Divider()
            Group {
                Text("Time: \(time())")
                Text("Date: \(date())")
            }
            
            Group {
                OrderHeader()
                if order.itemsOrdered.count > 0 {
                    ForEach(order.itemsOrdered) { orderItem in
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
            HStack{
                ReceiptPrinter(codableOrder: order)
                Spacer()
                if order.settled {
                    Button(action: unsettle) {
                        Text("Unsettle Order")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .background(styles.colors[4])
                    .cornerRadius(20)
                } else {
                    Button(action: settle) {
                        Text("Settle Order")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .background(Color.green)
                    .cornerRadius(20)
                    
                }
            }
        }
        .padding(20)
        .background(styles.colors[0])
        .cornerRadius(20)
        .frame(width: 600)
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
    
    func settle() {
        let newOrder = CodableOrder(orderNo: order.orderNo, itemsOrdered: order.itemsOrdered, discPercentage: order.discPercentage, total: order.total, subtotal: order.subtotal, date: order.date, settled: true)
        Bundle.main.updateOrderSettlement(order: newOrder)
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func unsettle() {
        let newOrder = CodableOrder(orderNo: order.orderNo, itemsOrdered: order.itemsOrdered, discPercentage: order.discPercentage, total: order.total, subtotal: order.subtotal, date: order.date, settled: false)
        Bundle.main.updateOrderSettlement(order: newOrder)
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct DetailedOrderView_Previews: PreviewProvider {
    static let order = CodableOrder()
    static let printer = BLEConnection()
    static var previews: some View {
        DetailedOrderView(order: order)
            .environmentObject(printer)
    }
}
