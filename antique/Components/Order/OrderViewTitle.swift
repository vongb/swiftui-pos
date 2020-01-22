//
//  SwiftUIView.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderViewTitle: View {
    let orderNo : Int
    let editing : Bool = false
    var body: some View {
        if editing {
            return Text("Editing Order #\(String(self.orderNo))")
        } else {
            return Text("Order #\(String(self.orderNo))")
        }
    }
}

struct OrderViewTitle_Previews: PreviewProvider {
    static var previews: some View {
        OrderViewTitle()
    }
}
