//
//  ReportDay.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ReportDay: View {
    @ObservedObject var report = Report()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Form {
                DatePicker(selection: self.$report.date, in: ...Date(), displayedComponents: .date){
                    BlackText(text: "Report Date", fontSize: 30)
                }
                Toggle("Include Whole Month", isOn: self.$report.includeWholeMonth)
                Toggle("Include Cashouts", isOn: self.$report.includeCashouts)
                OrderReport(orders: self.report.orders, cashouts: self.report.cashouts, includeCashOut: self.$report.includeCashouts)
            }
        }
        .padding()
    }
}

struct ReportDay_Previews: PreviewProvider {
    static let orders  = Orders()
    static var previews: some View {
        ReportDay().environmentObject(orders)
    }
}
