//
//  ItemCategoryReport.swift
//  antique
//
//  Created by Vong Beng on 8/7/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ItemCategoryReport: View {
    @ObservedObject var categoryReport = CategoryReport()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Form {
                DatePicker(selection: self.$categoryReport.date, in: ...Date(), displayedComponents: .date) {
                    BlackText(text: "Date")
                }
                Toggle("Include Whole Month", isOn: self.$categoryReport.includeWholeMonth)
                VStack(alignment: .center) {
                    Text("Menu Categories")
                    Picker(selection: self.$categoryReport.sectionSelection, label: Text("Category")) {
                        ForEach(0 ..< self.categoryReport.menuSections.count) { index in
                            Text(self.categoryReport.menuSections[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if categoryReport.loadingItems || categoryReport.filteringItems {
                    HStack {
                        Spacer()
                        Text("Loading Report")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                    .transition(.slide)
                } else {
                    if self.categoryReport.filteredItems.count != 0 {
                        Text("\(self.categoryReport.menuSections[self.categoryReport.sectionSelection]) Total: " + String(format: "$%.02f", self.categoryReport.filteredItemsTotal))
                            .font(.headline)
                        ReportItemHeader()
                        ForEach(self.categoryReport.filteredItems.indices, id: \.self) { index in
                            HStack {
                                Text(String(index + 1))
                                
                                Spacer().frame(width: 30)
                                
                                Text(self.categoryReport.filteredItems[index].item.name)
                                
                                Spacer()
                                
                                Text(String(self.categoryReport.filteredItems[index].qty))
                                
                                Spacer().frame(width: 50)
                                
                                Text(String(format: "$%.02f", self.categoryReport.filteredItems[index].itemTotal))
                            }
                            .padding(10)
                        }
                    } else {
                        Text("No \(self.categoryReport.menuSections[self.categoryReport.sectionSelection].lowercased()) items ordered " + (self.categoryReport.includeWholeMonth ? "this month" : "on this date"))
                    }
                }
            }
        }
        .padding(.horizontal, 5)
        .navigationBarTitle("Income by Category")
        .onAppear(perform: categoryReport.refreshOrders)
        .animation(.spring())
    }
}

struct ItemCategoryReport_Previews: PreviewProvider {
    static var previews: some View {
        ItemCategoryReport()
    }
}
