//
//  DetailedCashoutView.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct DetailedCashout : View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var cashouts : Cashouts

    @State var cashout : CodableCashout
    @State private var title : String = ""
    @State private var price : Int = 0
    @State private var desc : String = ""
    
    @State private var editingCashout : Bool = false
    
    @State var isPriceInRiels : Bool = false
    @State var editingPrice : Bool = false


    var priceDisplay : String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedRiels = numberFormatter.string(from: NSNumber(value: Currency.convertToRiels(dollars: cashout.priceInUSD))) ?? ""
        return String(format: "$%.02f", self.cashout.priceInUSD) + " (approx. \(formattedRiels) ៛)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing : 10) {
            Text("Created: \(day(cashout.date))")
                .font(.caption)
            HStack(spacing: 10) {
                if editingCashout {
                    TextField("Title", text: self.$title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.largeTitle)
                        .transition(.move(edge: .leading))
                } else {
                    Text("Title: \(self.cashout.title)")
                        .font(.largeTitle)
                        .bold()
                        .transition(.move(edge: .leading))
                }
                Spacer()
                if !editingCashout {
                    Button(action: edit) {
                        Image(systemName: "square.and.pencil")
                            .font(.largeTitle)
                    }
                    .padding()
                } else {
                    HStack(spacing: 10) {
                        Button(action: update) {
                            Text("Save")
                                .padding()
                                .foregroundColor(.white)
                        }
                        .background(Color.green)
                        .cornerRadius(20)
                        .transition(.scale)
                        
                        Button(action: cancel) {
                            Text("Cancel")
                                .padding()
                                .foregroundColor(.white)
                        }
                        .background(Color.red)
                        .cornerRadius(20)
                        .transition(.scale)
                    }
                }
            }
            if self.editingCashout {
                HStack {
                    CurrencyTextField(hideDecimal: self.isPriceInRiels, currencyValue: self.$price, editing: self.$editingPrice)
                    Divider()
                        .frame(height: (editingPrice ? 300 : 30))
                    VStack(alignment: .leading) {
                        Toggle("Price in Riels?", isOn: self.$isPriceInRiels.animation())
                        Text("Exchange Rate: \(Currency.EXCHANGE_RATE)៛")
                            .font(.caption)
                    }
                }
                TextField("Description", text: self.$desc)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .transition(.scale)
            } else {
                HStack {
                    Text(priceDisplay)
                        .font(.headline)
                        .bold()
                    Spacer()
                    Text("Exchange Rate: \(Currency.EXCHANGE_RATE)៛")
                        .font(.caption)
                }
                Text("Description: \(self.cashout.description)")
                    .transition(.scale)
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle(editingCashout ? "Editing Cashout" : "Viewing Cashout")
        .onAppear(perform: setUp)
    }
    
    func setUp() {
        self.title = self.cashout.title
        self.price = Currency.convertToCents(dollars: cashout.priceInUSD)
        self.desc = self.cashout.description
    }
    
    func update() {
        price = self.isPriceInRiels ? Currency.convertToCents(riels: self.price) : self.price
        let editedCashOut = CodableCashout(title: title, description: desc, priceInCents: price, date: self.cashout.date)
        cashout = editedCashOut
        self.isPriceInRiels = false
        Bundle.main.updateCashout(editedCashOut)
        cashouts.refreshCashouts()
        endEdit()
    }
    
    func date() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self.cashout.date)
    }
    
    func time() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: self.cashout.date)
    }
    
    func edit() {
        self.title = cashout.title
        self.price = Currency.convertToCents(dollars: cashout.priceInUSD)
        self.isPriceInRiels = false
        self.desc = cashout.description
        withAnimation {
            editingCashout = true
        }
    }
    
    func cancel() {
        self.title = cashout.title
        self.price = Currency.convertToCents(dollars: cashout.priceInUSD)
        self.isPriceInRiels = false
        self.desc = cashout.description
        endEdit()
    }
    
    func endEdit() {
        withAnimation {
            editingCashout = false
        }
        UIApplication.shared.endEditing() // Call to dismiss keyboard
    }
    
    func day(_ date : Date) -> String {
        let dateFormmater = DateFormatter()
        dateFormmater.dateStyle = .medium
        dateFormmater.timeStyle = .medium
        return dateFormmater.string(from: date)
    }
    
}
