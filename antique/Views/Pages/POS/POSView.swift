//
//  ContentView.swift
//  antique
//
//  Created by Vong Beng on 17/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct POSView: View {
    
    var body: some View {
        HStack {
            MenuView()
            OrderView()
        }
    }
}

struct POSView_Previews: PreviewProvider {
    static var previews: some View {
        POSView()
    }
}
