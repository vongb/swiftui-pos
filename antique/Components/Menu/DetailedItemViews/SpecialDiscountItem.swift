//
//  UpsizeItem.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct SpecialDiscountItem: View {
    @Binding var specialDiscounted : Bool
    
    var body: some View {
        Toggle(isOn: self.$specialDiscounted) {
            Text("Special Discount")
            .font(.system(size: 20))
            .fontWeight(.bold)
            .foregroundColor(Styles.getColor(.darkCyan))
        }
        .padding(0)    }
}

//struct UpsizeItem_Previews: PreviewProvider {
//    static var upsize = false
//    static var previews: some View {
//        UpsizeItem(upsized: upsize)
//    }
//}
