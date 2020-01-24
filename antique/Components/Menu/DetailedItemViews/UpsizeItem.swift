//
//  UpsizeItem.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct UpsizeItem: View {
    @Binding var upsized : Bool
    @ObservedObject var styles = Styles()
    
    var body: some View {
        Toggle(isOn: self.$upsized) {
            Text("Upsize")
            .font(.system(size: 20))
            .fontWeight(.bold)
            .foregroundColor(styles.colors[2])
        }
        .padding(0)    }
}

//struct UpsizeItem_Previews: PreviewProvider {
//    static var upsize = false
//    static var previews: some View {
//        UpsizeItem(upsized: upsize)
//    }
//}
