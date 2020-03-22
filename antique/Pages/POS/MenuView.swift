//
//  MenuView.swift
//  antique
//
//  Created by Vong Beng on 25/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var menu : Menu
    @EnvironmentObject var orders : Orders
    @State private var showingCashout : Bool = false
    var body: some View {
        // Displays menu in sections
        NavigationView {
            if menu.items.count != 0 {
                List {
                    ForEach(menu.items) { section in
                        Section(header:
                            Text(section.name)
                                .bold()
                                .font(.system(size: 25))
                        ) {
                            ForEach(section.items) { item in
                                ItemRow(item: item)
                            }
                        }
                    }
                    Button(action: {self.showingCashout.toggle()}) {
                        Text("Cash Out")
                    }
                }
                .navigationBarTitle("Menu")
                .listStyle(GroupedListStyle())
            } else {
                Text("No Items, Please Reset Menu in Admin View")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: self.$showingCashout) {
            CashOutView().environmentObject(self.orders)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
