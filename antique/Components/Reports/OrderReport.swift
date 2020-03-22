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
    @ObservedObject var styles = Styles()
    var label : String {
        if self.orders.monthOnly {
            return "Monthly Total: "
        } else {
            return "Daily Total: "
        }
    }
    var body: some View {
        VStack(spacing: 10) {
            Text("Income Total: \(String(format: "$%.02f", self.orders.incomeTotal))")
                .modifier(SubtotalModifier())
            if self.orders.includeCashOut {
                Text("Cashout Total: \(String(format: "$%.02f", self.orders.cashoutTotal))")
                    .modifier(CashOutModifier())
            }
            
            Text("\(self.label) \(String(format: "$%.02f", self.orders.total))")
                    .modifier(GrandTotalModifier(total: self.orders.total))
            
            Divider()
            if self.orders.items.count != 0 {
                List {
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
    let styles = Styles()
    func body(content: Content) -> some View {
        return content
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background((self.total >= 0 ? Color.green : self.styles.colors[4]))
            .cornerRadius(10)
    }
}

struct SubtotalModifier : ViewModifier {
    let styles = Styles()
    func body(content: Content) -> some View {
        return content
            .font(.subheadline)
            .padding()
            .foregroundColor(.white)
            .background(self.styles.colors[3])
            .cornerRadius(10)
    }
}

struct CashOutModifier : ViewModifier {
    let styles = Styles()
    func body(content: Content) -> some View {
        return content
            .font(.subheadline)
            .padding()
            .foregroundColor(.white)
            .background(self.styles.colors[4])
            .cornerRadius(10)
    }
}


struct OrderReport_Previews: PreviewProvider {
    static var previews: some View {
        OrderReport()
    }
}
