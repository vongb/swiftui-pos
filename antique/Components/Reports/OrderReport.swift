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
    
    var body: some View {
        VStack(spacing: 10) {
            if self.orders.monthOnly {
                Text("Monthly Total \(String(format: "$%.02f", self.orders.total))")
                    .bold()
                    .font(.system(size: 40))
                    .padding(5)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            } else {
                Text("Daily Total \(String(format: "$%.02f", self.orders.total))")
                    .bold()
                    .font(.system(size: 40))
                    .padding(5)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
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

struct OrderReport_Previews: PreviewProvider {
    static var previews: some View {
        OrderReport()
    }
}
