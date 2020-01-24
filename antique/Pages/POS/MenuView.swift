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

    var body: some View {
        // Displays menu in sections
        NavigationView {
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
            }
            .navigationBarTitle("Menu")
            .listStyle(GroupedListStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
