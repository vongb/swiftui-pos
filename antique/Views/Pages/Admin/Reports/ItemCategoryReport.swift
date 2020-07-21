//
//  ItemCategoryReport.swift
//  antique
//
//  Created by Vong Beng on 8/7/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ItemCategoryReport: View {
    @ObservedObject var orders : Orders = Orders()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Form {
                Text("Sales by Category").font(.largeTitle).bold()
                DatePicker(selection: self.$orders.date, in: ...Date(), displayedComponents: .date) {
                    BlackText(text: "Date")
                }
                Toggle("Include Whole Month", isOn: self.$orders.includeWholeMonth)
                VStack(alignment: .center) {
                    Text("Menu Categories")
                    Picker(selection: self.$orders.sectionSelection, label: Text("Category")) {
                        ForEach(0 ..< self.orders.menuSections.count) {
                            Text(self.orders.menuSections[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("Ensure item names are unique across all sections").font(.caption)
                }
                
                Text("All Items Total: " + String(format: "$%.02f", self.orders.total))
                    .font(.title)
                    .bold()
                if self.orders.filteredItems.count != 0 {
                    Text("\(self.orders.menuSections[self.orders.sectionSelection]) Total: " + String(format: "$%.02f", self.orders.categoryTotal))
                        .font(.headline)
                    ReportItemHeader()
                    ForEach(self.orders.filteredItems.indices, id: \.self) { index in
                        HStack {
                            Text(String(index + 1))
                            
                            Spacer().frame(width: 30)
                            
                            Text(self.orders.filteredItems[index].item.name)
                            
                            Spacer()
                            
                            Text(String(self.orders.filteredItems[index].qty))
                            
                            Spacer().frame(width: 50)
                            
                            Text(String(format: "$%.02f", self.orders.filteredItems[index].itemTotal))
                        }
                        .padding(10)
                    }
                } else {
                    Text("No \(self.orders.menuSections[self.orders.sectionSelection].lowercased()) ordered " + (self.orders.includeWholeMonth ? "this month" : "on on this date"))
                }
            }
        }
    }
}

struct ItemCategoryReport_Previews: PreviewProvider {
    static var previews: some View {
        ItemCategoryReport()
    }
}
