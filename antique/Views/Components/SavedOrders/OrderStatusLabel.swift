//
//  OrderStatusLabel.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderStatusLabel: View {
    var cancelled : Bool
    var settled : Bool
    var size : CGFloat = 25

    var body: some View {
        if cancelled {
            return AnyView(RedText(text: "CANCELLED", fontSize: size))
        } else if settled {
            return AnyView(BlackText(text: "PAID", fontSize: size))
        } else {
            return AnyView(MaroonText(text: "UNPAID", fontSize: size))
        }
    }
}

struct OrderStatusLabel_Previews: PreviewProvider {
    static var previews: some View {
        OrderStatusLabel(cancelled: false, settled: false)
    }
}
