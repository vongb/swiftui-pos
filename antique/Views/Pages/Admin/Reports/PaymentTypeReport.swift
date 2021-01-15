//
//  PaymentTypeReport.swift
//  antique
//
//  Created by Vong Beng on 13/9/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct PaymentTypeReport: View {
    @ObservedObject private var paymentReport: PaymentReport = PaymentReport()
    
    var body: some View {
        VStack(alignment: .center) {
            DatePicker(selection: self.$paymentReport.date, in: ...Date(), displayedComponents: .date) {
                BlackText(text: "Report Date", fontSize: 30)
            }
            .frame(maxHeight: 80)
            Toggle(isOn: self.$paymentReport.includeWholeMonth) {
                Text("Include Whole Month")
            }
            VStack(alignment: .center) {
                if paymentReport.isLoading {
                    Text("Calculating")
                } else {
                    BarView(barItems: $paymentReport.paymentIncomes)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                }
                Spacer()
            }
            .transition(
                AnyTransition.scale
                    .animation(.spring())
            )
            Spacer()
        }
        .padding(15)
        .navigationBarTitle("Payment Reports")
        .animation(.spring())
        .onAppear(perform: paymentReport.refreshOrders)
        
    }
}

struct PaymentTypeReport_Previews: PreviewProvider {
    static var previews: some View {
        PaymentTypeReport()
    }
}
