//
//  ReportsMonth.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ReportMonth: View {
//    @ObservedObject var orders = Orders(monthOnly: <#T##Bool#>: false)
    @ObservedObject var styles = Styles()
    
    var body: some View {
        VStack(spacing: 10){
//            Form {
//                MonthPicker(date: self.$orders.date)
//                OrderReport(daily: false, items: self.items)
//            }
            Text("Under Development")
        }
        .padding(20)
        .background(styles.colors[0])
        .cornerRadius(20)
        .frame(width: 600)
    }
}

struct ReportMonth_Previews: PreviewProvider {
    static var previews: some View {
        ReportMonth()
    }
}
