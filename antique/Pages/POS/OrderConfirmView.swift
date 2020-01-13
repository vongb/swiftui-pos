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
    @EnvironmentObject var styles : Styles
    @Environment(\.presentationMode) var presentationMode
    
    let exchangeRate : Double = 4000
    
    @State var usdReceived : String = "0"
    @State var khrReceived : String = "0"
    @State var usdChangeOffset : Int = 0
    var canSettle : Bool {
        totalReceivedInUSD >= self.order.total
    }
    
    var totalReceivedInUSD : Double {
        var usd : Double
        var khr : Double
        if !usdReceived.isEmpty {
            usd = (usdReceived as NSString).doubleValue
        } else {
            usd = 0
        }
        if !khrReceived.isEmpty {
            khr = (khrReceived as NSString).doubleValue
        } else {
            khr = 0
        }
        return usd + khr / exchangeRate
    }
    var usdChange : Int {
        Int((Double(totalReceivedInUSD) - self.order.total) + Double(usdChangeOffset))
    }
    var khrChange : Int {
        let changeLeft = totalReceivedInUSD - self.order.total - Double(usdChange)
        return Int((changeLeft * exchangeRate).rounded(.up))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Group {
                Text("Grand Total")
                    .font(.system(size: 30))
                    .bold()
                Text(String(format: "$%.02f", self.order.total))
                    .font(.system(size: 30))
                    .bold()
                    .foregroundColor(.green)
            }
            
            Divider().frame(width: 300)
            
            Group {
                Text("USD Received")
                TextField("Amount", text: $usdReceived, onEditingChanged: { (editingChanged) in
                        if editingChanged {
                            self.usdReceived = ""
                        } else {
                            if (self.usdReceived.isEmpty) {
                                self.usdReceived = "0"
                            }
                        }
                }) {
                    UIApplication.shared.endEditing()
                }
                    .onReceive(Just(usdReceived)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.usdReceived = filtered
                        }
                    }
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 100, maxWidth: 300)
                
                Text("KHR Received")
                TextField("Amount", text: $khrReceived, onEditingChanged: { (editingChanged) in
                        if editingChanged {
                            self.khrReceived = ""
                        } else {
                            if (self.khrReceived.isEmpty) {
                                self.khrReceived = "0"
                            }
                        }
                    }) {
                        UIApplication.shared.endEditing()
                    }
                    .onReceive(Just(usdReceived)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.khrReceived = filtered
                        }
                    }
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 100, maxWidth: 300)
            }
            
            // Change
            Group {
                Text("Change")
                    .font(.system(size: 25))
                    .bold()
                HStack {
                    Button(action: self.decrement) {
                        Text("-")
                            .font(.system(size: 25))
                            .padding(5)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                    .background(styles.colors[4])
                    .cornerRadius(5)
                    
                    Text("USD \(String(self.usdChange))")
                        .font(.system(size: 20))
                    
                    Button(action: self.increment) {
                        Text("+")
                            .font(.system(size: 25))
                            .padding(5)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                    .background(styles.colors[1])
                    .cornerRadius(5)
                }
                
                Text("KHR \(String(self.khrChange))")
                    .font(.system(size: 20))
            }
            
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
                        if canSettle {
                            Text("Settle Order")
                                .padding(10)
                                .foregroundColor(.white)
                        } else {
                            Text("Settle Order")
                            .padding(10)
                            .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 120)
                    .disabled(!canSettle)
                    .background(Color.green)
                    .cornerRadius(20)
                    
                }
            }
            ReceiptPrinter(codableOrder: getCodable(), justPrint: false)
        }
        .padding(20)
        .background(styles.colors[0])
        .cornerRadius(20)
    }
    
    func decrement() {
        if(usdChange > 0) {
            usdChangeOffset -= 1
        }
    }
    
    func increment() {
        usdChangeOffset += 1
    }
    
    func saveOrder() {
        self.order.settleOrder(orderNo: orders.nextOrderNo, settled: false)
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func settleOrder() {
        self.order.settleOrder(orderNo: orders.nextOrderNo)
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func getCodable() -> CodableOrder {
        return CodableOrder(orderNo: orders.nextOrderNo,itemsOrdered: order.items, discPercentage: order.discountPercentage, total: order.total, subtotal: order.subtotal, date: order.date)
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
