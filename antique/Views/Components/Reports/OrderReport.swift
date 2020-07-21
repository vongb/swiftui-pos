//
//  OrderReport.swift
//  antique
//
//  Created by Vong Beng on 23/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderReport: View {
    @ObservedObject var orders : Orders = Orders()
    @ObservedObject var cashouts : Cashouts = Cashouts()
    @Binding var includeCashOut : Bool
    var label : String {
        if self.orders.includeWholeMonth {
            return "Monthly Total: "
        } else {
            return "Daily Total: "
        }
    }
    
    var total : Double {
        if includeCashOut {
            return orders.total - cashouts.total
        } else {
            return orders.total
        }
    }
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 10) {
            Text("Income Total: \(String(format: "$%.02f", self.orders.total))")
                .modifier(SubtotalModifier())
            if self.includeCashOut {
                Text("Cashout Total: \(String(format: "$%.02f", self.cashouts.total))")
                    .modifier(CashOutModifier())
            }
            
            Text("\(self.label) \(String(format: "$%.02f", self.total))")
                    .modifier(GrandTotalModifier(total: self.total))
            Text("Ensure item names are unique across all sections").font(.caption)
            
            Divider()
            if self.orders.items.count != 0 {
                List {
                    Text("Most Popular Menu Items")
                        .font(.headline)
                    ReportItemHeader()
                    ForEach(self.orders.items.indices, id: \.self) { index in
                        HStack {
                            Text(String(index + 1))
                            
                            Spacer().frame(width: 30)
                            
                            Text(self.orders.items[index].item.name)
                            
                            Spacer()
                            
                            Text(String(self.orders.items[index].qty))
                            
                            Spacer().frame(width: 50)
                            
                            Text(String(format: "$%.02f", self.orders.items[index].itemTotal))
                        }
                        .padding(10)
                    }
                }
            } else {
                Text("No Orders")
            }
        }
    }
}

struct GrandTotalModifier : ViewModifier {
    var total : Double
    func body(content: Content) -> some View {
        return content
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(self.total >= 0 ? Color.green : (Styles.getColor(.lightRed)))
            .cornerRadius(10)
    }
}

struct SubtotalModifier : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.subheadline)
            .padding()
            .foregroundColor(.white)
            .background(Styles.getColor(.darkGrey))
            .cornerRadius(10)
    }
}

struct CashOutModifier : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.subheadline)
            .padding()
            .foregroundColor(.white)
            .background(Styles.getColor(.lightRed))
            .cornerRadius(10)
    }
}


//struct OrderReport_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderReport()
//    }
//}
