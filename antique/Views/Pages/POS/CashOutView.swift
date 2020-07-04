//
//  CashOutView.swift
//  antique
//
//  Created by Vong Beng on 8/3/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct CashOutView: View {
    @State private var title : String = ""
    @State private var desc : String = ""
    @State private var price : Int = 0
    @State private var editingPrice : Bool = true
    @State private var priceIsRiels : Bool = false
    
    @EnvironmentObject var cashouts : Cashouts
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.white)
                .scaledToFit()
                .onTapGesture {
                    withAnimation {
                        self.editingPrice = false
                    }
                }
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 10) {
                Text("Cash Out")
                    .font(.largeTitle)
                    .bold()
                TextField("Title", text: self.$title)
                    .font(.headline)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    CurrencyTextField(hideDecimal: priceIsRiels, currencyValue: self.$price, editing: self.$editingPrice)
                    Divider()
                        .frame(height: self.editingPrice ? 300 : 30)
                    Toggle(isOn: self.$priceIsRiels.animation(.spring())) {
                        Text("Price In Riels?")
                    }
                }
                TextField("Description", text: self.$desc)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    Spacer()
                    Button(action: cashOut) {
                        Text("Confirm Cash Out")
                            .padding()
                            .foregroundColor(.white)
                    }
                    .disabled(self.title.isEmpty)
                    .background(self.title.isEmpty ? Color.gray : Styles.getColor(.brightCyan))
                    .cornerRadius(20)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .background(Color.white)
    }
    
    func cashOut() {
        Bundle.main.cashOut(createCashOut())
        self.presentationMode.wrappedValue.dismiss()
        self.cashouts.refreshCashouts()
    }
    
    func createCashOut() -> CodableCashout {
        if priceIsRiels {
            return CodableCashout(title: self.title, description: self.desc, priceInRiels: self.price)
        } else {
            return CodableCashout(title: self.title, description: self.desc, priceInCents: self.price)
        }
    }
}

struct CashOutView_Previews: PreviewProvider {
    static var previews: some View {
        CashOutView()
    }
}
