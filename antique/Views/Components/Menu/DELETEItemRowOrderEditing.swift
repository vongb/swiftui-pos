////
////  ItemRowEditing.swift
////  antique
////
////  Created by Vong Beng on 19/1/20.
////  Copyright © 2020 Vong Beng. All rights reserved.
////
//
//import SwiftUI
//
//struct ItemRowOrderEditing: View {
//    let item : MenuItem
//
//    var body: some View {
//        NavigationLink(destination : DetailedViewOrderEditing(item: item)) {
//            HStack() {
//                Text(item.name)
//                Spacer()
//                Text(String(format: "$%.02f", item.price))
//                    .foregroundColor(Color(red:0.31, green:0.85, blue:0.56))
//            }
//        }
//    }
//}
//
////struct ItemRowOrderEditing_Previews: PreviewProvider {
////    static var previews: some View {
////        ItemRowOrderEditing(item: MenuItem(name: "Test", price: 1.25))
////    }
////}
