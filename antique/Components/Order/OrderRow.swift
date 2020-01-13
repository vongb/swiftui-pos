//
//  OrderRow.swift
//  antique
//
//  Created by Vong Beng on 24/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderRow: View {
    var orderItem : OrderItem
    
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
                        .font(.system(size: 10))
                }
                
                if(self.orderItem.item.hasIceLevels) {
                    Text("Ice: \(orderItem.iceLevel)")
                        .font(.system(size: 10))
                }
                if orderItem.upsized {
                    Text("Upsized (+" + String(format: "$%0.2f", orderItem.item.upsizePrice) + ")")
                        .font(.system(size: 10))
                }
            }
            
            Spacer()
            
            Text(String(format: "$%.02f", orderItem.item.price))
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
