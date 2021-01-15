//
//  EditExchangeRate.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct EditMisc: View {
    @State var exchangeRate = UserDefKeys.getExchangeRate()
    @State var wifiPassword = UserDefKeys.getWifiPassword()
    
    @State var editingExchangeRate : Bool = false
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Wifi Password: ")
                    TextField("No password set", text: self.$wifiPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Save", action: updateWifiPassword)
                }
                
                HStack {
                    Text("Exchange Rate: $1 = \(String(exchangeRate))៛")
                    Spacer()
                    CurrencyTextField(hideDecimal: true, currencyValue: self.$exchangeRate, editing: self.$editingExchangeRate, editingExchangeRate: true)
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation{
                    UIApplication.shared.endEditing()
                    self.editingExchangeRate = false
                }
            }
            .padding()
            .navigationBarTitle("Wifi & Exchange Rate")
    }
    
    func updateWifiPassword() {
        UserDefaults.standard.set(wifiPassword, forKey: "wifiPassword")
        wifiPassword = UserDefaults.standard.string(forKey: "wifiPassword") ?? "Save failed"
        UIApplication.shared.endEditing()
    }
}

struct EditMisc_Previews: PreviewProvider {
    static var previews: some View {
        EditMisc()
    }
}
