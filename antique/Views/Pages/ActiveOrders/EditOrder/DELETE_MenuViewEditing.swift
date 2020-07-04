////
////  MenuViewEditing.swift
////  antique
////
////  Created by Vong Beng on 19/1/20.
////  Copyright © 2020 Vong Beng. All rights reserved.
////
//
//import SwiftUI
//
//struct MenuViewEditing: View {
////    @EnvironmentObject var order : Order
//    @EnvironmentObject var menu : Menu
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(menu.items) { section in
//                    Section(header: Text(section.name)) {
//                        ForEach(section.items) { item in
//                            ItemRowOrderEditing(item: item)
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Menu")
//            .listStyle(GroupedListStyle())
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
//
////struct MenuViewEditing_Previews: PreviewProvider {
////    static var previews: some View {
////        MenuViewEditing()
////    }
////}
