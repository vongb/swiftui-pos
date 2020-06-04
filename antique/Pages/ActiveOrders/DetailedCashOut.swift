//
//  DetailedOrderView.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct DetailedCashOut : View {
    let EXCHANGE_RATE : Int = UserDefaults.standard.value(forKey: UserDefKeys.exchangeRateKey) as? Int ?? 4000
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var cashouts : Cashouts

    var cashout : CodableCashout
    @State private var title : String = ""
    @State private var price : Int = 0
    @State private var desc : String = ""
    
    @State var editingCashout : Bool = false
    @State var priceInRiels : Bool = false
    @State var editingPrice : Bool = false
    
    @State private var prevTitle : String = ""
    @State private var prevPrice : Int = 0
    @State private var prevDesc : String = ""
    
    var priceDisplay : Double {
        if priceInRiels {
            return Double(price / EXCHANGE_RATE)
        } else {
            return Double(price) / 100
        }
    }
    
    init(_ cashOut: CodableCashout) {
        self.cashout = cashOut
        self.priceInRiels = false
        self.editingCashout = false
        self.editingPrice = false
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing : 10) {
            Text((editingCashout ? "Editing Cash Out" : "Viewing Cash Out"))
                .font(.largeTitle)
                .bold()
            Divider()
            HStack {
                if editingCashout {
                    TextField("Title", text: self.$title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.largeTitle)
                        .transition(.move(edge: .leading))
                } else {
                    Text("Title: \(self.title)")
                        .font(.headline)
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
                    CurrencyTextField(currencyIsRiels: self.priceInRiels, currencyValue: self.$price, editing: self.$editingPrice)
                    Divider()
                        .frame(height: (editingPrice ? 300 : 30))
                    Toggle("Price in Riels?", isOn: self.$priceInRiels.animation())
                }
                TextField("Description", text: self.$desc)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .transition(.scale)
            } else {
                Text(String(format: "Total: $%.02f", self.priceDisplay))
                    .bold()
                Text("Description: \(self.desc)")
                    .transition(.scale)
            }
            Spacer()
        }
        .padding()
        .onAppear(perform: setUp)
    }
    
    func setUp() {
        self.title = self.cashout.title
        self.price = Int(self.cashout.priceInUSD * 100)
        self.desc = self.cashout.description
        self.prevTitle = self.title
        self.prevPrice = self.price
        self.prevDesc = self.desc
    }
    
    func update() {
        let priceInUSD = (self.priceInRiels ? Int(Double(self.price / EXCHANGE_RATE) * 100) : self.price)
        let editedCashOut = CodableCashout(title: self.title, description: self.desc, priceInCents: priceInUSD, date: self.cashout.date)
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
        prevTitle = self.title
        prevPrice = self.price
        prevDesc = self.desc
        withAnimation {
            editingCashout = true
        }
    }
    
    func cancel() {
        self.title = prevTitle
        self.price = self.prevPrice
        self.desc = self.prevDesc
        endEdit()
    }
    
    func endEdit() {
        UIApplication.shared.endEditing() // Call to dismiss keyboard
        withAnimation {
            editingCashout = false
        }
    }
    
}
