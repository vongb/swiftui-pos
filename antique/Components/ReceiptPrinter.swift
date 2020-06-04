//
//  ReceiptPrinter.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ReceiptPrinter: View {
    @EnvironmentObject var printer : BLEConnection
    @EnvironmentObject var orders : Orders
    @EnvironmentObject var order : Order
    @Environment(\.presentationMode) var presentationMode

    var codableOrder : CodableOrder
    
    var body: some View {
        VStack {
            // Connect to Printer/Print Receipt
            Text("Receipt")
                .font(.system(size: 20))
            
            Spacer().frame(height: 10)
            
            if printer.connected {
                    HStack {
                    Button(action: self.saveAndPrint) {
                        Text("Save & Print")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .disabled(!self.printer.connected)
                    .background(Styles.getColor(.lightRed))
                    .cornerRadius(20)
                    
                        Spacer().frame(width: 50)
                    
                    Button(action: self.settleAndPrint) {
                        Text("Settle & Print")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .disabled(!self.printer.connected)
                    .background(Styles.getColor(.brightCyan))
                    .cornerRadius(20)
                    }
//                }
            } else {
                if !self.printer.scanning {
                    Button(action: self.printer.startScan) {
                        Text("Connect to Printer")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .background(Styles.getColor(.lightRed))
                    .cornerRadius(20)
                    
                } else {
                    Text("Scanning")
                    Button(action: self.printer.stopScan) {
                        Text("Stop Scan")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .background(Color.yellow)
                    .cornerRadius(20)
                }
                
            }
        }
    }
    
    func saveAndPrint() {
        let settleDate : Date = Date()
        order.settleOrder(orderNo: orders.nextOrderNo, settled: false, settleDate: settleDate)
        printReceipt(settleDate: settleDate)
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func settleAndPrint() {
        let settleDate : Date = Date()
        order.settleOrder(orderNo: orders.nextOrderNo, settled: true, settleDate: settleDate)
        printReceipt(settleDate: settleDate)
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func printReceipt(settleDate : Date = Date()) {
        let receipt = Receipt(order: codableOrder, date: settleDate)
        self.printer.sendToPrinter(message: receipt.receipt())
    }
}

struct ReceiptPrinter_Previews: PreviewProvider {
    static let order = CodableOrder(CodableOrderDTO())
    static let printer = BLEConnection()
    static var previews: some View {
        ReceiptPrinter(codableOrder: order).environmentObject(printer)
    }
}
