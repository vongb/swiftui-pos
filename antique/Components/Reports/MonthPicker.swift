//
//  MonthPicker.swift
//  antique
//
//  Created by Vong Beng on 23/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI
import Combine

struct MonthPicker: View {
    @Binding var date : Date
    @ObservedObject var model : MonthSelection
    
    init(date: Binding<Date>) {
        self._date = date
        self.model = MonthSelection(date: self._date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                BlackText(text: "Month/Year:", fontSize: 30)
                Spacer()
                Text("\(self.model.months[self.model.monthSelection]), \(self.model.years[self.model.yearSelection])")
                    .padding(5)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            Picker("Month", selection: self.$model.monthSelection) {
                ForEach(0 ..< self.model.months.count){
                    Text("\(self.model.months[$0])")
                }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            
            Picker("Month", selection: self.$model.yearSelection) {
                ForEach(0 ..< self.model.years.count){
                    Text("\(self.model.years[$0])")
                }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(10)
    }
}
//
//struct MonthPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthPicker()
//    }
//}

extension MonthPicker {
    class MonthSelection : ObservableObject {
        @Published var monthSelection : Int {
            didSet {
                date = getDate()
            }
        }
        @Published var yearSelection : Int {
            didSet {
                date = getDate()
            }
        }
        @Binding var date : Date
        var years : [String]
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

        init(date: Binding<Date>) {
            // Month Selection
            self.monthSelection = Calendar.current.component(.month, from: Date()) - 1
            
            // Years
            var dateComponents = DateComponents()
            dateComponents.year = 2020
            dateComponents.month = 1
            dateComponents.day = 1
            dateComponents.hour = 0
            dateComponents.minute = 1
            
            var startDate = Calendar.current.date(from: dateComponents)!
            let endDate = Date()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            var index = 0
            self.yearSelection = 0
            self.years = [String]()
            while startDate < endDate {
                self.years.append(formatter.string(from: startDate))
                self.yearSelection = index
                index += 1
                startDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate) ?? endDate
            }
            
            // Date
            self._date = date
        }
        
        func getDate() -> Date {
            var comp = DateComponents()
            print(self.yearSelection)
            comp.year = Int(self.years[self.yearSelection]) ?? Calendar.current.component(.year, from: Date())
            comp.month = self.monthSelection + 1
            comp.day = 1
            comp.hour = 0
            comp.minute = 1
            
            return Calendar.current.date(from: comp) ?? Date()
        }
    }
}
