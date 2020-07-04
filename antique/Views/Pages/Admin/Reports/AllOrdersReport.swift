//
//  OrderReport.swift
//  antique
//
//  Created by Vong Beng on 8/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct AllOrdersReport: View {
    @EnvironmentObject var printer : BLEConnection
    @EnvironmentObject var menu : Menu
    @EnvironmentObject var orders : Orders
    
    @State private var confirmingSettleAll : Bool = false
    @State private var viewingOrder : Bool = false
    @State private var selectedOrder : CodableOrder = CodableOrder(orderNo: 0, date: Date())
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("Orders")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button(action: {
                        self.confirmingSettleAll = true
                    }) {
                        Text("Settle All")
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    .background(Styles.getColor(.lightRed))
                    .cornerRadius(25)
                }
                DatePicker(selection: self.$orders.date, in: ...Date(), displayedComponents: .date) {
                    BlackText(text: "Order Date", fontSize: 20)
                }
                List(self.orders.savedOrders, id: \.self) { order in
                    Button(action: {self.updateSelectedOrder(order)}) {
                        HStack(spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("Order #\(order.orderNo)")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                Text(String(format: "$%.02f", order.total))
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            if order.cancelled {
                                Text("Canceled")
                                    .foregroundColor(Styles.getColor(.darkCyan))
                                .font(.caption)
                            } else if order.settled {
                                Text("Paid")
                                    .foregroundColor(.green)
                                    .font(.caption)
                            } else {
                                Text("Active")
                                    .foregroundColor(Styles.getColor(.lightRed))
                                .font(.caption)
                            }
                            Image(systemName: "doc.text.magnifyingglass")
                        }
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: self.$viewingOrder) {
            DetailedOrderView(order: self.selectedOrder, canUnsettle: true)
                .environmentObject(self.printer)
                .environmentObject(self.menu)
                .environmentObject(self.orders)
        }
        .alert(isPresented: $confirmingSettleAll) {
            Alert(title: Text("Settle All Orders?"), primaryButton: .default(Text("Settle"), action: {
                self.orders.settleAll()
            }), secondaryButton: .cancel())
        }
    }
    
    func updateSelectedOrder(_ order : CodableOrder) {
        self.selectedOrder = order
        withAnimation {
            self.viewingOrder = true
        }
    }
}

struct AllOrdersReport_Previews: PreviewProvider {
    static var previews: some View {
        AllOrdersReport()
    }
}
