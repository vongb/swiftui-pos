//
//  TableNumberEntry.swift
//  antique
//
//  Created by Vong Beng on 21/7/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct TableNumberEntry: View {
    let tables : [String] = UserDefaults.standard.array(forKey: "tables") as? [String] ?? [0...20].map{ "\($0)" }
    @Binding var tableID : String
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TableNumberEntry_Previews: PreviewProvider {
    static var previews: some View {
        TableNumberEntry(tableID: .constant("10"))
    }
}
