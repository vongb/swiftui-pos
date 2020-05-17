//
//  AppView.swift
//  antique
//
//  Created by Vong Beng on 30/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    // Make tableview backgrounds transparent
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    
    // Main App Landing Page
    var body: some View {
        TabView {
            POSView()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Sale")
                }
            ActiveOrdersView()
                .tabItem{
                    Image(systemName: "flag")
                    Text("Manage")
                }
            AdminView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
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
