//
//  OrderTotal.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderTotalLabel: View {
    var total : Double = 0
    
    var body: some View {
        VStack {
            Text("Grand Total")
                .font(.system(size: 30))
                .bold()
            Text(String(format: "$%.02f", self.total))
                .font(.system(size: 30))
                .bold()
                .foregroundColor(.green)
        }
    }
}

struct OrderTotalLabel_Previews: PreviewProvider {
    static var previews: some View {
        OrderTotalLabel()
    }
}
