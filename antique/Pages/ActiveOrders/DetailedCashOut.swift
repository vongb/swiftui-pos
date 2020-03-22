//
//  DetailedOrderView.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct DetailedCashOut : View {
    @EnvironmentObject var menu : Menu
    @EnvironmentObject var orders : Orders
    let styles = Styles()
    @Environment(\.presentationMode) var presentationMode

    let cashout : CashOut
    @State private var title : String = ""
    @State private var price : Int = 0
    @State private var desc : String = ""
    
    @State var editingCashout : Bool = false
    @State var priceInRiels : Bool = false
    @State var editingPrice : Bool = false
    
    var priceDisplay : Double {
        if priceInRiels {
            return Double(price) / 4000
        } else {
            return Double(price) / 100
        }
    }
    
    init(_ cashOut: CashOut) {
        self.cashout = cashOut
        self.priceInRiels = false
        self.editingCashout = false
        self.editingPrice = false
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing : 10) {
            Text("Cash Out")
                .font(.largeTitle)
                .bold()
            HStack {
                if editingCashout {
                    TextField("Title", text: self.$title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.largeTitle)
                        .transition(.move(edge: .leading))
                } else {
                    Text("\(self.title)")
                        .font(.headline)
                        .bold()
                        .transition(.move(edge: .leading))
                }
                Spacer()
                if !editingCashout {
                    Button(action: toggle) {
                        Text("Edit")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(self.styles.colors[2])
                    .cornerRadius(20)
                    .transition(.scale)
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
                        
                        Button(action: toggle) {
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
            } else {
                Text(String(format: "Total: $%.02f", self.priceDisplay))
                    .modifier(CashOutModifier())
            }
            
            if self.editingCashout {
                TextField("Description", text: self.$desc)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .transition(.scale)
            } else {
                Text(self.desc)
                    .transition(.scale)
            }
            Spacer()
        }
        .padding()
        .background(styles.colors[0])
        .cornerRadius(20)
        .frame(width: 600)
        .onAppear(perform: setUp)
    }
    
    func setUp() {
        self.title = self.cashout.title
        self.price = Int(self.cashout.priceInUSD * 100)
        self.desc = self.cashout.description
    }
    
    func update() {
        let priceInUSD = (self.priceInRiels ? Int(Double(self.price / 4000) * 100) : self.price)
        let editedCashOut = CashOut(title: self.title, description: self.desc, priceInCents: priceInUSD, date: self.cashout.date)
        Bundle.main.updateCashOut(editedCashOut)
        self.orders.refreshSavedOrders()
        toggle()
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
    
    func toggle() {
        withAnimation {
            editingCashout.toggle()
        }
    }
    
}
