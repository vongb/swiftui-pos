//
//  SavedOrderRow.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct SavedOrderRow: View {
    @EnvironmentObject var styles : Styles
    
    let order : CodableOrder
    let orderNo : Int
    
    var body: some View {
        NavigationLink(destination: DetailedOrderView(order: self.order)) {
            HStack(alignment: .center) {
                Text("# \(order.orderNo)")
                Spacer()
                if !order.settled {
                    Text("Active")
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(3)
                } else {
                    Text("Paid")
                        .padding(5)
                        .foregroundColor(.white)
                        .background(styles.colors[3])
                        .cornerRadius(3)
                }
            }.padding(10)
        }
    }
}

struct SavedOrderRow_Previews: PreviewProvider {
    static var order = CodableOrder(orderNo: 1, settled: false)
    static var previews: some View {
        SavedOrderRow(order: order, orderNo: 2)
    }
}
