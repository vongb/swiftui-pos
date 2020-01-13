//
//  ReportDay.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ReportDay: View {
    @State var reportDate = Date()
    @State var revenue : Double = 0.0
    
    @EnvironmentObject var orders : Orders
    var dailyTotal : Double {
        var total : Double = 0.0
        orders.savedOrders.forEach{ order in
            total += order.total
        }
        return total
    }
    
    var itemsOrdered : [ItemOrdered] {
        var temp = [ItemOrdered]()
        orders.savedOrders.forEach{ order in
            order.itemsOrdered.forEach{ orderItem in
                var found = false
                for index in 0..<temp.count {
                    if temp[index].item.name == orderItem.item.name {
                        temp[index].qty += orderItem.qty
                        found = true
                        break
                    }
                }
                if !found {
                    temp.append(ItemOrdered(item: orderItem.item, qty: orderItem.qty))
                }
            }
        }
        return temp.sorted(by: {$0.qty > $1.qty})
    }
    
    let months : [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var formatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Total: \(String(format: "$%.02f", dailyTotal))")
                .bold()
                .font(.system(size: 40))
                .padding(5)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
            BlackText(text: "Date: \(formatter.string(from: Date()))")
            List {
                ForEach(itemsOrdered) { item in
                    HStack {
                        Text(item.item.name)
                        Spacer()
                        Text(String(item.qty))
                    }
                    .padding(10)
                }
            }
        }
        .padding(10)
    }
}

struct ReportDay_Previews: PreviewProvider {
    static let orders  = Orders()
    static var previews: some View {
        ReportDay().environmentObject(orders)
    }
}
