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
    @Environment(\.presentationMode) var presentationMode

    var codableOrder : CodableOrder
    
    var body: some View {
        VStack {
            // Connect to Printer/Print Receipt
            Text("Receipt")
                .font(.system(size: 20))
            
            Spacer().frame(height: 10)
            
            if printer.connected {
                Button(action: print) {
                    Text("Print")
                        .padding(10)
                        .foregroundColor(.white)
                }
//                .disabled(!self.printer.connected)
                .background(Styles.getColor(.brightCyan))
                .cornerRadius(20)
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
    
    func print() {
        let receipt = Receipt(order: codableOrder)
        printer.sendToPrinter(message: receipt.receipt())
    }
}

struct ReceiptPrinter_Previews: PreviewProvider {
    static let order = CodableOrder(CodableOrderDTO())
    static let printer = BLEConnection()
    static var previews: some View {
        ReceiptPrinter(codableOrder: order).environmentObject(printer)
    }
}
