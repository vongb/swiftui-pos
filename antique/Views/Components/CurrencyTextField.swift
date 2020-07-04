//
//  CurrencyTextField.swift
//  antique
//
//  Created by Vong Beng on 3/2/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct CurrencyTextField: View {
    let hideDecimal : Bool
    @Binding var currencyValue : Int
    @Binding var editing : Bool
    var editingExchangeRate : Bool = false
    var isPercentage : Bool = false
    var height : CGFloat = 25
    var showDoneButton : Bool = true
    private var label : String {
        if isPercentage {
            return "%"
        } else if hideDecimal {
            return "៛"
        } else {
            return "$"
        }
    }
    
    private var displayMoney : String {
        if self.currencyValue == 0 {
            if hideDecimal {
                return "0"
            } else {
                return "0.00"
            }
        } else {
            var display : Double = 0
            if hideDecimal {
                return String(self.currencyValue)
            } else {
                display = Double(self.currencyValue) / 100.0
                return String(format: "%.02f", display)
            }
        }
    }
    
    private var borderCol : Color {
        if editing {
            return Color.green
        } else {
            return Color.blue
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 5) {
                Text(self.label)
                    .foregroundColor(self.borderCol)
                    .font(.system(size: 30))
                    .frame(width: 30)
                
                Text(self.displayMoney)
                    .padding(5)
                    .font(.system(size: 25))
                    .frame(minWidth: 200, maxWidth: .infinity, minHeight: self.height, maxHeight: self.height)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(self.borderCol, lineWidth: 1)
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.toggle()
                        UIApplication.shared.endEditing()
                    }
                    
                if editing && showDoneButton {
                    Button(action: self.toggle) {
                        Text("✓")
                            .bold()
                            .padding(5)
                            .foregroundColor(.white)
                            .frame(width: 50, height: self.height)
                    }
                    .background(Color.green)
                    .cornerRadius(5)
                    .transition(.move(edge: .trailing))
                }
            }
            .frame(width: 310)
            if editing {
                VStack(spacing: 5) {
                    HStack(spacing: 5) {
                        NumButton(value: 1, currency: self.$currencyValue, isPercentage: self.isPercentage)
                        NumButton(value: 2, currency: self.$currencyValue, isPercentage: self.isPercentage)
                        NumButton(value: 3, currency: self.$currencyValue, isPercentage: self.isPercentage)
                    }

                    HStack(spacing: 5) {
                        NumButton(value: 4, currency: self.$currencyValue, isPercentage: self.isPercentage)
                        NumButton(value: 5, currency: self.$currencyValue, isPercentage: self.isPercentage)
                        NumButton(value: 6, currency: self.$currencyValue, isPercentage: self.isPercentage)
                    }

                    HStack(spacing: 5) {
                        NumButton(value: 7, currency: self.$currencyValue, isPercentage: self.isPercentage)
                        NumButton(value: 8, currency: self.$currencyValue, isPercentage: self.isPercentage)
                        NumButton(value: 9, currency: self.$currencyValue, isPercentage: self.isPercentage)
                    }

                    HStack(spacing: 5) {
                        DoubleZeroButton(currency: self.$currencyValue, isPercentage: self.isPercentage)
                        NumButton(value: 0, currency: self.$currencyValue, isPercentage: self.isPercentage)
                        DeleteButton(currency: self.$currencyValue)
                    }
                }
                .transition(.opacity)
            }
        }
    }
    
    func toggle() {
        if editingExchangeRate {
            UserDefaults.standard.set(Int(self.currencyValue), forKey: UserDefKeys.exchangeRateKey)
        }
        withAnimation {
            self.editing.toggle()
        }
    }
}

struct NumButton : View {
    let value : Int
    @Binding var currency : Int
    var isPercentage : Bool
    var body : some View {
        Button(action: self.add) {
            Text(String(self.value))
                .foregroundColor(.white)
                .frame(minWidth: 50, maxWidth: 80)
                .padding(10)
        }
        .background(Styles.getColor(.darkGreen))
        .cornerRadius(5)
    }
    
    func add() {
        let newValue = self.currency * 10 + self.value
        if newValue > 100 && isPercentage {
            self.currency = 100
        } else {
            self.currency = newValue
        }
    }
}

struct DoubleZeroButton : View {
    @Binding var currency : Int
    var isPercentage : Bool
    var body : some View {
        Button(action: self.addHundred) {
            Text("00")
                .foregroundColor(.white)
                .frame(minWidth: 50, maxWidth: 80)
                .padding(10)
        }
        .background(Styles.getColor(.darkGreen))
        .cornerRadius(5)
    }
    
    func addHundred() {
        let newValue = self.currency * 100
        if newValue > 100 && isPercentage {
            self.currency = 100
        } else {
            self.currency = newValue
        }
    }
}

struct DeleteButton : View {
    @Binding var currency : Int
    
    var body : some View {
        Button(action: self.delete) {
            Text("⌫")
                    .foregroundColor(.white)
                    .frame(minWidth: 50, maxWidth: 80)
                    .padding(10)
        }
        .background(Color(red:0.99, green:0.37, blue:0.33))
        .cornerRadius(5)
    }
    
    func delete() {
        self.currency = (self.currency - self.currency % 10) / 10
    }
}

struct CurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyTextField(hideDecimal: true, currencyValue: .constant(0), editing: .constant(true))
    }
}
