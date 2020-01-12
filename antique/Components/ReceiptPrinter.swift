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
    static let colors = [Color(red:0.89, green:0.98, blue:0.96),
                        Color(red:0.19, green:0.89, blue:0.79),
                        Color(red:0.07, green:0.60, blue:0.62),
                        Color(red:0.25, green:0.32, blue:0.31),
                        Color(red:0.95, green:0.51, blue:0.51),
                        Color(red:0.58, green:0.88, blue:0.83)]
    var order: CodableOrder
    
    var body: some View {
        VStack {
            // Connect to Printer/Print Receipt
            Text("Receipt")
                .font(.system(size: 20))
            
            Spacer().frame(height: 10)
            
            if printer.connected {
                Button(action: self.printReceipt) {
                    Text("Print Receipt")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .disabled(!self.printer.connected)
                .background(Self.colors[1])
                .cornerRadius(20)
            } else {
                Button(action: self.printer.startCentral) {
                    Text("Connect to Printer")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .background(Self.colors[4])
                .cornerRadius(20)
            }
        }
    }
    
    func printReceipt() {
//        let orderToPrint = CodableOrder(orderNo: order.orderNo, itemsOrdered: order.itemsOrdered, discPercentage: order.discPercentage, total: order.total, subtotal: order.subtotal, date: order.date)
        let receipt = Receipt(order: order)
        self.printer.sendToPrinter(message: receipt.receipt())
    }
}

struct ReceiptPrinter_Previews: PreviewProvider {
    static let order = CodableOrder()
    static let printer = BLEConnection()
    static var previews: some View {
        ReceiptPrinter(order: order).environmentObject(printer)
    }
}
