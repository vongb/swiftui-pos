//
//  OrderTotal.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderTotalLabel: View {
    var total : Double
    
    var body: some View {
        HStack {
            Text("Grand Total")
                .font(.largeTitle)
                .bold()
            Text(String(format: "$%.02f", self.total))
                .font(.largeTitle)
                .bold()
                .foregroundColor(.green)
        }
    }
}

struct OrderTotalLabel_Previews: PreviewProvider {
    static var previews: some View {
        OrderTotalLabel(total: 0)
    }
}
