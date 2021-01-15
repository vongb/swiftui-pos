//
//  CashoutReport.swift
//  antique
//
//  Created by Vong Beng on 6/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct CashoutReport: View {
    @EnvironmentObject var cashouts : Cashouts
    
    @State private var selectedCashout : CodableCashout = CodableCashout()
    @State private var showDetailedCashout : Bool = false
    var body: some View {
        VStack {
            Form {
                Text(String(format: "Total Cashout: $%.02f", self.cashouts.total))
                    .font(.title)
                    .bold()
                DatePicker(selection: self.$cashouts.date, in: ...Date(), displayedComponents: .date) {
                    BlackText(text: "Cashout Date", fontSize: 20)
                }
                Toggle(isOn: self.$cashouts.includeWholeMonth) {
                    Text("Include Whole Month")
                }
                List(cashouts.cashouts, id: \.self) { cashout in
                    NavigationLink(destination: DetailedCashout(cashout: cashout)) {
                        HStack(spacing: 10) {
                            VStack(alignment: .leading) {
                                Text(cashout.title)
                                    .bold()
                                    .foregroundColor(.primary)
                                Text(String(format: "$%.02f", cashout.priceInUSD))
                                    .foregroundColor(Styles.getColor(.lightRed))
                            }
                            Spacer()
                            Image(systemName: "doc.text.magnifyingglass")
                        }
                    }
                }
            }
        }
        .padding()
        .navigationBarTitle("All Cashouts")
        .onDisappear(perform: {self.cashouts.date = Date()})
    }
    
    func updateCurrentCashout(_ cashout: CodableCashout) {
        self.selectedCashout = cashout
        withAnimation {
            self.showDetailedCashout = true
        }
    }
}

struct CashoutReport_Previews: PreviewProvider {
    static var previews: some View {
        CashoutReport()
    }
}
