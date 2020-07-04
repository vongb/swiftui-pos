//
//  DiscountApplier.swift
//  antique
//
//  Created by Vong Beng on 5/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct DiscountApplier: View {
    @Binding var showDiscount : Bool {
        didSet {
            applyDiscount()
        }
    }
    @Binding var value : Int {
        didSet {
            applyDiscount()
        }
    }
    @Binding var discPercentage : Int
    @Binding var isDiscPercentage : Bool
    @Binding var discAmountInUSD : Double
    @Binding var selection : Int
    
    let discountTypes = ["%", "៛", "$"]
    
    var label : String {
        let valueLabel = discountTypes[selection]
        if valueLabel != "$" {
            return "Discount: \(String(value))\(valueLabel)"
        } else {
            return "Discount: \(valueLabel) \(String(format: "%.02f", Double(value) / 100.0))"
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if showDiscount {
                Picker(selection: $selection, label: Text("Discount Type")) {
                    ForEach(0 ..< discountTypes.count) { index in
                        Text(self.discountTypes[index]).tag(index)
                    }
                }
                .frame(minWidth: 150, maxWidth: 240)
                .pickerStyle(SegmentedPickerStyle())
                if selection == 0 {
                    // %
                    CurrencyTextField(hideDecimal: true, currencyValue: self.$value, editing: self.$showDiscount, isPercentage: true, showDoneButton: false)
                        .onDisappear(perform: applyDiscount)
                } else if selection == 1 {
                    // Riels
                    CurrencyTextField(hideDecimal: true, currencyValue: self.$value, editing: self.$showDiscount, showDoneButton: false)
                        .onDisappear(perform: applyDiscount)
                } else {
                    // Dollar
                    CurrencyTextField(hideDecimal: false, currencyValue: self.$value, editing: self.$showDiscount, showDoneButton: false)
                        .onDisappear(perform: applyDiscount)
                }
            }
//            Text(label)
            Button(action: handleAction) {
                Text(showDiscount ? "Done" : label)
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(showDiscount ? Color.green : Styles.getColor(.brightCyan))
            .cornerRadius(20)
        }
        
    }
    
    func handleAction() {
        applyDiscount()
        withAnimation {
            showDiscount.toggle()
        }
    }
    
    
    func applyDiscount() {
        self.isDiscPercentage = selection == 0
        if isDiscPercentage {
            discPercentage = value
            discAmountInUSD = 0
        } else {
            discPercentage = 0
            if selection == 1 {
                let exchangeRate = UserDefKeys.getExchangeRate()
                discAmountInUSD = Double(value) / Double(exchangeRate)
            } else {
                discAmountInUSD = Double(value) / 100
            }
        }
    }
}

struct DiscountApplier_Previews: PreviewProvider {
    static var previews: some View {
        DAPreviewWrapper()
    }
    
    struct DAPreviewWrapper : View {
        @State var showDiscount : Bool = false
        @State(initialValue: false) var isDiscPercentage : Bool
        @State(initialValue: 2.5) var discAmtInUSD : Double
        @State(initialValue: 0) var discPercentage : Int
        @State var discountValue : Int = 0
        @State var selection : Int = 0
        var body : some View {
            DiscountApplier(showDiscount: $showDiscount, value: $discountValue, discPercentage: $discPercentage, isDiscPercentage: $isDiscPercentage, discAmountInUSD: $discAmtInUSD, selection: $selection)
        }
    }
}
