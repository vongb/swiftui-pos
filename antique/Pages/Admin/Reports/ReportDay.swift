//
//  ReportDay.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ReportDay: View {
    @ObservedObject var orders = Orders(monthOnly: false)
    @ObservedObject var styles = Styles()
    
    @State var monthOnly : Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Form {
                DatePicker(selection: self.$orders.date, in: ...Date(), displayedComponents: .date){
                    BlackText(text: "Report Date", fontSize: 30)
                }
                Toggle("Include Whole Month", isOn: self.$orders.monthOnly)
                Toggle("Include Cash Outs", isOn: self.$orders.includeCashOut)
                OrderReport(orders: self.orders)
            }
        }
        .padding(20)
        .background(styles.colors[0])
        .cornerRadius(20)
        .frame(width: 600)
    }
}

struct ReportDay_Previews: PreviewProvider {
    static let orders  = Orders()
    static var previews: some View {
        ReportDay().environmentObject(orders)
    }
}
