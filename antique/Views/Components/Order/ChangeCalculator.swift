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
    @Binding var showCalculator : Bool
    var total : Double
    
    @State private var centsReceived : Int = 0
    @Binding var editingCents : Bool
    
    @State private var khrReceived : Int = 0
    @Binding var editingRiels : Bool
    
    @State private var usdChangeOffset : Int = 0
    
    // Converts KHR to USD with exchange rate provided
    var totalReceivedInUSD : Double {
        return Currency.convertToDollars(cents: centsReceived) + Currency.convertToDollars(riels: khrReceived)
    }
    
    // Calculates change to be tendered. Prioritises USD change.
    // Can be offset in the case USD currency is insufficient at the register.
    var usdChange : Int {
        Int((Double(totalReceivedInUSD) - self.total) + Double(usdChangeOffset))
    }
    
    var khrChange : Int {
        let changeLeftInUSD = totalReceivedInUSD - self.total - Double(usdChange)
        return Currency.convertToRiels(dollars: changeLeftInUSD)
    }
    
    
    var body: some View {
        VStack(spacing: 10) {
            if showCalculator {
                Group {
                    Text("USD Received")
                        .font(.headline)
                    CurrencyTextField(hideDecimal: false, currencyValue: self.$centsReceived, editing: self.$editingCents)
                    
                    Text("KHR Received")
                        .font(.headline)
                    CurrencyTextField(hideDecimal: true, currencyValue: self.$khrReceived, editing: self.$editingRiels)
                }
                
                // Change
                Group {
                    Text("Change")
                        .font(.headline)
                        .bold()
                    Text("Rate: \(Currency.EXCHANGE_RATE) KHR/USD")
                        .font(.caption)
                    HStack {
                        Button(action: self.decrement) {
                            Text("-")
                                .font(.system(size: 25))
                                .padding(5)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .background(Styles.getColor(.lightRed))
                        .cornerRadius(5)
                        
                        Text("\(String(format: "$%.02f", Double(self.usdChange)))")
                            .font(.system(size: 20))
                        
                        Button(action: self.increment) {
                            Text("+")
                                .font(.system(size: 25))
                                .padding(5)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .background(Styles.getColor(.brightCyan))
                        .cornerRadius(5)
                    }
                    
                    Text("៛ \(String(self.khrChange))")
                        .font(.system(size: 20))
                }
                
            }
            Button(action: toggleShowCalculator) {
                Text(showCalculator ? "Done" : "Change Calculator")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(showCalculator ? Color.green : Styles.getColor(.darkCyan))
            .cornerRadius(20)
        }
    }
    
    func toggleShowCalculator() {
        withAnimation {
            showCalculator.toggle()
            
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
    static var previews: some View {
        CCPreviewWrapper()
    }
    
    struct CCPreviewWrapper : View {
        @State var showCalc : Bool = false
        @State var editingRiels : Bool = false
        @State var editingCents : Bool = false
        @State var total : Double = 10.0
        var body : some View {
            ChangeCalculator(showCalculator: $showCalc, total: total, editingCents: $editingCents, editingRiels: $editingRiels)
        }
    }
}
