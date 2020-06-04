//
//  EditExchangeRate.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct EditMisc: View {
    @State var exchangeRate = UserDefaults.standard.value(forKey: UserDefKeys.exchangeRateKey) as? Int ?? 4000
    @State var wifiPassword = UserDefaults.standard.string(forKey: UserDefKeys.wifiPasswordKey) ?? ""
    
    @State var editingExchangeRate : Bool = false
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Wifi & Exchange Rate").font(.largeTitle)
                Divider()
                
                HStack {
                    Text("Wifi Password: ")
                    TextField("No password set", text: self.$wifiPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Save", action: updateWifiPassword)
                }
                
                HStack {
                    Text("Exchange Rate: $1 = \(String(exchangeRate))៛")
                    Spacer()
                    CurrencyTextField(currencyIsRiels: true, currencyValue: self.$exchangeRate, editing: self.$editingExchangeRate, editingExchangeRate: true)
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
