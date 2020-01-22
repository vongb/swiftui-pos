//
//  ReportDay.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ReportDay: View {
    @ObservedObject var orders = Orders()
    @EnvironmentObject var styles : Styles
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Form {
                DatePicker(selection: self.$orders.date, in: ...Date(), displayedComponents: .date){
                    Text("Report Date:")
                        .bold()
                        .padding(5)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(styles.colors[3])
                        .cornerRadius(10)
                }
                Text("Daily Total: \(String(format: "$%.02f", self.orders.dailyTotal))")
                    .bold()
                    .font(.system(size: 40))
                    .padding(5)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
//                Text("Date: \(self.orders.date, formatter: self.orders.formatter)")
//                    .bold()
                List {
                    HStack {
                        Text("#")
                            .bold()
                        Spacer().frame(width: 30)
                        Text("Item Name")
                            .bold()
                        Spacer()
                        Text("Qty")
                            .bold()
                        Spacer().frame(width: 50)
                        Text("Total")
                            .bold()
                    }
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
