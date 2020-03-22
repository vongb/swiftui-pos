//
//  ChangeCalculator.swift
//  antique
//
//  Created by Vong Beng on 18/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI
import Combine

// Calculates Change in USD + KHR based on order total and cash received
struct ChangeCalculator: View {
    var total : Double
    
    @State var centsReceived : Int = 0
    @Binding var editingCents : Bool
    
    @State var khrReceived : Int = 0
    @Binding var editingRiels : Bool
    
    @State var usdChangeOffset : Int = 0
    
    @ObservedObject var styles = Styles()

    let EXCHANGE_RATE : Double = 4000
    
    // Converts KHR to USD with exchange rate provided
    var totalReceivedInUSD : Double {
        return Double(centsReceived / 100) + (Double(khrReceived) / EXCHANGE_RATE)
    }
    
    // Calculates change to be tendered. Prioritises USD change.
    // Can be offset in the case USD currency is insufficient at the register.
    var usdChange : Int {
        Int((Double(totalReceivedInUSD) - self.total) + Double(usdChangeOffset))
    }
    var khrChange : Int {
        let changeLeft = totalReceivedInUSD - self.total - Double(usdChange)
        return Int((changeLeft * EXCHANGE_RATE).rounded(.up))
    }
    
    
    var body: some View {
        VStack {
            Group {
                Text("USD Received")
                CurrencyTextField(currencyIsRiels: false, currencyValue: self.$centsReceived, editing: self.$editingCents)
                
                Text("KHR Received")
                CurrencyTextField(currencyIsRiels: true, currencyValue: self.$khrReceived, editing: self.$editingRiels)
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
        }
    }
    
    private func decrement() {
        if(usdChange > 0) {
            usdChangeOffset -= 1
        }
    }
    
    private func increment() {
        usdChangeOffset += 1
    }
}

struct ChangeCalculator_Previews: PreviewProvider {
    static let styles = Styles()
    static var previews: some View {
        ChangeCalculator(total: 5.9, editingCents: .constant(true), editingRiels: .constant(false)).environmentObject(styles)
    }
}
