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
                Text(String(format: "Cashouts: $%.02f", self.cashouts.total))
                    .font(.largeTitle)
                    .bold()
                DatePicker(selection: self.$cashouts.date, in: ...Date(), displayedComponents: .date) {
                    BlackText(text: "Cashout Date", fontSize: 20)
                }
                Toggle(isOn: self.$cashouts.includeWholeMonth) {
                    Text("Include Whole Month")
                }
                List(cashouts.cashouts, id: \.self) { cashout in
                    Button(action: {self.updateCurrentCashout(cashout)}) {
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
        .sheet(isPresented: self.$showDetailedCashout) {
            DetailedCashOut(self.selectedCashout)
                .environmentObject(self.cashouts)
        }
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
