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
    static let colors = [Color(red:0.89, green:0.98, blue:0.96),
                        Color(red:0.19, green:0.89, blue:0.79),
                        Color(red:0.07, green:0.60, blue:0.62),
                        Color(red:0.25, green:0.32, blue:0.31),
                        Color(red:0.95, green:0.51, blue:0.51),
                        Color(red:0.58, green:0.88, blue:0.83)]
    var order : CodableOrder
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Order No: #\(order.orderNo)")
                    .bold()
                    .padding(5)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .background(Self.colors[3])
                    .cornerRadius(10)
                    
                Spacer().frame(height: 10)
                
                HStack {
                    Text("Total: \(String(format: "$%.02f", self.order.total))")
                        .bold()
                        .padding(5)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(Self.colors[2])
                        .cornerRadius(10)
                    if !order.settled {
                        Text("UNPAID")
                            .bold()
                            .padding(5)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .background(Self.colors[4])
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
                Divider()
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
                ReceiptPrinter(order: order)
                Spacer()
                if !order.settled {
                    Button(action: updateSettlement) {
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
        .background(Self.colors[0])
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
    
    func updateSettlement() {
        let newOrder = CodableOrder(orderNo: order.orderNo, itemsOrdered: order.itemsOrdered, discPercentage: order.discPercentage, total: order.total, subtotal: order.subtotal, date: order.date, settled: true)
        Bundle.main.updateOrderSettlement(order: newOrder)
        orders.refreshSavedOrders()
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
