//
//  PrintReceipt.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct PrintReceipt: View {
    @EnvironmentObject var printer : BLEConnection
    @EnvironmentObject var styles : Styles
    
    @State var justPrint : Bool = true
    
    var body: some View {
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
                Button(action: self.printReceipt) {
                    Text("Save & Print")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .disabled(!self.printer.connected)
                .background(styles.colors[4])
                .cornerRadius(20)
                
                Spacer()
                
                Button(action: self.printReceipt) {
                    Text("Settle & Print")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .disabled(!self.printer.connected)
                .background(styles.colors[4])
                .cornerRadius(20)
            }
        }
    }
    
    func printReceipt() {
        let receipt = Receipt(order: order)
        self.printer.sendToPrinter(message: receipt.receipt())
    }
}

struct PrintReceipt_Previews: PreviewProvider {
    static var previews: some View {
        PrintReceipt()
    }
}
