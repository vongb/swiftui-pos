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
    @ObservedObject var styles = Styles()
    @Environment(\.presentationMode) var presentationMode

    var codableOrder : CodableOrder
    var justPrint : Bool = true
    
    var body: some View {
        VStack {
            // Connect to Printer/Print Receipt
            Text("Receipt")
                .font(.system(size: 20))
            
            Spacer().frame(height: 10)
            
            if printer.connected {
                if justPrint {
                    Button(action: self.printReceipt) {
                        Text("Print Receipt")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .disabled(!self.printer.connected)
                    .background(styles.colors[1])
                    .cornerRadius(20)
                } else {
                    HStack {
                    Button(action: self.saveAndPrint) {
                        Text("Save & Print")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .disabled(!self.printer.connected)
                    .background(styles.colors[4])
                    .cornerRadius(20)
                    
                        Spacer().frame(width: 50)
                    
                    Button(action: self.settleAndPrint) {
                        Text("Settle & Print")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .disabled(!self.printer.connected)
                    .background(styles.colors[1])
                    .cornerRadius(20)
                    }
                }
            } else {
                if !self.printer.scanning {
                    Button(action: self.printer.startScan) {
                        Text("Connect to Printer")
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .background(styles.colors[4])
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
        order.settleOrder(orderNo: orders.nextOrderNo, settled: false)
        printReceipt()
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func settleAndPrint() {
        order.settleOrder(orderNo: orders.nextOrderNo, settled: true)
        printReceipt()
        orders.refreshSavedOrders()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func printReceipt() {
        let receipt = Receipt(order: codableOrder)
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
