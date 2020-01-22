//
//  AppView.swift
//  antique
//
//  Created by Vong Beng on 30/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        TabView {
            POSView()
                .tabItem {
                    Text("Sale")
                }
            ActiveOrdersView()
                .tabItem{
                    Text("Active Orders")
                }
            AdminView()
                .tabItem {
                    Text("Admin")
                }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
