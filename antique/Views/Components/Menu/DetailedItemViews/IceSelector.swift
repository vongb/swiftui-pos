//
//  IceSelector.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

// Ice selectors
// Ice levels and indexes come from Menu and items in menu.json respectively
struct IceSelector: View {
    @Binding var iceLevel : Int
    
    @EnvironmentObject var menu : Menu
    
    let item : MenuItem
    
    var body: some View {
        Section(header:
            Text("Ice Level")
                .foregroundColor(Styles.getColor(.darkCyan))
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
