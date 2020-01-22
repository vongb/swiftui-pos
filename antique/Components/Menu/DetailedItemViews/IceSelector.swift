//
//  IceSelector.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct IceSelector: View {
    @EnvironmentObject var styles : Styles
    @EnvironmentObject var menu : Menu
    @Binding var iceLevel : Int
    let item : MenuItem
    
    var body: some View {
        Section(header:
            Text("Ice Level")
                .foregroundColor(styles.colors[2])
        ) {
            Picker("Levels:", selection: $iceLevel) {
                ForEach(0 ..< self.menu.iceLevels[item.iceLevelIndex].count){
                    Text("\(self.menu.iceLevels[self.item.iceLevelIndex][$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

//struct IceSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        IceSelector()
//    }
//}
