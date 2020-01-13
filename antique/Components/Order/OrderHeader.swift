//
//  OrderViewHeader.swift
//  antique
//
//  Created by Vong Beng on 24/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderHeader : View {
    var body: some View {
        HStack() {
            Text("Item Name")
                .bold()
            
            Spacer()
            
            Text("Unit Price")
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Text("Qty")
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 30)
            
            Text("Price")
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 50)


        }
        .padding(10)
    }
}

struct OrderHeader_Previews: PreviewProvider {
    static var previews: some View {
        OrderHeader()
    }
}
