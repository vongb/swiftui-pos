//
//  ReportDay.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ProfitReport: View {
    @ObservedObject var report = Report()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Form {
                DatePicker(selection: self.$report.date, in: ...Date(), displayedComponents: .date){
                    BlackText(text: "Report Date", fontSize: 30)
                }
                Toggle("Include Whole Month", isOn: self.$report.includeWholeMonth)
                Toggle("Include Cashouts", isOn: self.$report.includeCashouts)
                HStack {
                    Text("Categories:")
                    Spacer()
                    Button(report.collapsedCategories ? "Show" : "Collapse", action: {
                        withAnimation {
                            report.collapsedCategories.toggle()
                        }
                    })
                }
                if !report.collapsedCategories {
                    ForEach(report.includeCategory.indices, id: \.self) { index in
                        Toggle(report.menuSections[index], isOn: $report.includeCategory[index])
                            .padding(.leading, 15)
//                            .transition(.scale)
//                            .animation(.default)
                    }
                }
            }
            Divider()
            ScrollView {
                if report.itemsOrderedIsLoading {
                    HStack() {
                        Spacer()
                        Text("Generating Report...")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    .transition(AnyTransition.scale.animation(.spring()))
                } else {
                    VStack(alignment: .center, spacing: 15) {
                        if report.itemsOrdered.count != 0 {
                            Text("Filtered Items Total: " + String(format: "$%.02f", self.report.profits))
                                .font(.title)
                            Text(report.excludedSections)
                                .font(.caption)
                                .bold()
                            
                            Text("Income by Menu Sections")
                                .font(.headline)
                            
                            HStack {
                                BarView(barItems: .constant(report.sectionTotals))
                                    .frame(height: 300)
                                if report.includeCashouts {
                                    Divider()
                                    BarView(barItems: .constant([BarItem(label: "Cash Outs", amount: -report.cashouts.total)]))
                                        .frame(width: 100, height: 300)
                                }
                            }
                            Spacer()
                            ReportItemHeader()
                            ForEach(report.itemsOrdered.indices, id: \.self) { index in
                                HStack(spacing: 15) {
                                    Text(String(index + 1))
                                    
                                    Text(report.itemsOrdered[index].item.name)
                                    
                                    Spacer()
                                    
                                    Text(String(report.itemsOrdered[index].qty))
                                    
                                    VStack(alignment: .trailing) {
                                        Text(String(format: "$%.02f", report.itemsOrdered[index].itemTotal))
                                            .frame(minWidth: 100)
                                            .multilineTextAlignment(.trailing)
                                    }
                                }
                            }
                        } else {
                            Text("No orders found for " + (self.report.includeWholeMonth ? "this month" : "this date"))
                        }
                    }
                    .padding(24)
                    .transition(AnyTransition.scale.animation(.spring()))
                }
                Spacer()
            }
        }
        .padding(.horizontal, 5)
        .navigationBarTitle("Profit Report")
        .onAppear(perform: report.refreshSavedOrders)
        .animation(.spring())
    }
}

struct ReportDay_Previews: PreviewProvider {
    static let orders  = Orders()
    static var previews: some View {
        ProfitReport()
            .environmentObject(orders)
    }
}
