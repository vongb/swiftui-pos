//
//  OrderSubtotalLabel.swift
//  antique
//
//  Created by Vong Beng on 5/6/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderSubtotalLabel: View {
    var subtotal : Double
    
    var body: some View {
        HStack {
            Text("Subtotal")
                .font(.subheadline)
            Text(String(format: "$%.02f", self.subtotal))
                .font(.subheadline)
        }
    }
}

struct OrderSubtotalLabel_Previews: PreviewProvider {
    static var previews: some View {
        OrderSubtotalLabel(subtotal: 0)
    }
}
