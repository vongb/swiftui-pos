//
//  ReportsView.swift
//  antique
//
//  Created by Vong Beng on 30/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct ReportsView: View {
    @State var reportDate = Date()
    @State var revenue : Double = 0.0
    
    var programStart : DateComponents
    
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }
    
    init() {
        self.programStart = DateComponents()
        programStart.year = 2020
        programStart.month = 1
        programStart.day = 1
    }
    
    var body: some View {
        VStack {
            Form {
                DatePicker("Report Date", selection: $reportDate, in: Calendar.current.date(from: programStart)! ... Date(), displayedComponents: .date)
            }
//            Text("Date is \(reportDate, formatter: dateFormatter)")
            Text("dlskjf")
        }
    }
}

struct ReportsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView()
    }
}
