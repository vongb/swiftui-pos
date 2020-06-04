//
//  OrderRow.swift
//  antique
//
//  Created by Vong Beng on 24/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderRow: View {
    var orderItem : OrderItem = OrderItem()
    private var unitPrice : Double {
        var unitP : Double = orderItem.item.price
        if orderItem.upsized {
            unitP += orderItem.item.upsizePrice
        }
        if orderItem.specialDiscounted {
            unitP -= orderItem.item.specialDiscount
        }
        return unitP
    }
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(orderItem.item.name)
                    .font(.system(size: 15))
                    .bold()
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 100, maxWidth: 400, alignment: .leading)
                
                if(self.orderItem.item.hasSugarLevels) {
                    Text("Sugar: \(orderItem.sugarLevel)")
                        .font(.caption)
                }
                
                if(self.orderItem.item.hasIceLevels) {
                    Text("Ice: \(orderItem.iceLevel)")
                        .font(.caption)
                }
                if orderItem.upsized {
                    Text(String(format: "Upsized (+$%0.02f ea)", orderItem.item.upsizePrice))
                        .font(.caption)
                }
                if orderItem.specialDiscounted {
                    Text(String(format: "Special Discount (-$%0.02f ea)", orderItem.item.specialDiscount))
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Text(String(format: "$%.02f", unitPrice))
                .font(.system(size: 15))
                .bold()
            
            Text("x\(orderItem.qty)")
                .font(.system(size: 15))
                .bold()
                .frame(width: 30)
            
            Text(String(format: "$%.02f", orderItem.total))
                .font(.system(size: 15))
                .bold()
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 50)
        }
        .padding(10)
    }
}

struct OrderRow_Previews: PreviewProvider {
    static let item = OrderItem(item:
        MenuItem(name: "Test Latte", price: 2.25, hasSugarLevels: false, iceLevelIndex: 1, hasIceLevels: true)
    )
    static var previews: some View {
        OrderRow(orderItem : item)
    }
}
