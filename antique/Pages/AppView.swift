//
//  AppView.swift
//  antique
//
//  Created by Vong Beng on 30/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var orders : Orders
    
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
            ReportsView()
                .tabItem {
                    Text("Reports")
                }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static let orders = Orders()
    static var previews: some View {
        AppView().environmentObject(orders)
    }
}
