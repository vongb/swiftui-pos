////
////  DetailedViewOrderEditing.swift
////  antique
////
////  Created by Vong Beng on 19/1/20.
////  Copyright © 2020 Vong Beng. All rights reserved.
////
//
//import SwiftUI
//
//struct DetailedViewOrderEditing: View {
//    @EnvironmentObject var order : Order
//    @EnvironmentObject var menu : Menu
//    @EnvironmentObject var styles : Styles
//    @Environment(\.presentationMode) var presentationMode
//    
//    var item : MenuItem
//    @State private var qty : Int = 1
//    @State private var upsized : Bool = false
//    @State private var sugarLevel : Int = 2
//    @State private var iceLevel : Int = 2
//    
//    private var total : Double {
//        if upsized {
//            return (item.price + item.upsizePrice) * Double(qty)
//        } else {
//            return Double(qty) * item.price
//        }
//    }
//    
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            DetailedItemTitle(item: item, total: self.total)
//            HStack() {
//                if(self.item.canUpsize) {
//                    UpsizeItem(upsized: $upsized)
//                } else {
//                    Spacer()
//                }
//                
//                Spacer().frame(width: 40)
//                
//                QtyUpdater(qty: $qty)
//            }
//            
//            if(self.item.hasSugarLevels) {
//                Spacer().frame(height: 10)
//                // Sugar Levels
//                SugarSelector(sugarLevel: $sugarLevel)
//            }
//            
//            if(self.item.hasIceLevels && self.menu.iceLevels[self.item.iceLevelIndex].count > 1) {
//                Spacer().frame(height: 10)
//                // Ice Levels
//                IceSelector(iceLevel: $iceLevel, item: self.item)
//            }
//            
//            Spacer().frame(height: 30)
//            
//            // Add to Order
//            HStack {
//                Spacer()
//                Button(action: addToOrder) {
//                    Text("Add to Order")
//                        .font(.headline)
//                        .padding(10)
//                        .foregroundColor(Color.white)
//                }
//                .background(styles.colors[1])
//                .cornerRadius(20)
//                Spacer()
//            }
//            Spacer()
//        }
//        .padding(20)
//    }
//    func addToOrder() {
//        let sugar : String
//        let ice : String
//        if(self.item.hasSugarLevels) {
//            sugar = self.menu.sugarLevels[self.sugarLevel]
//        } else {
//            sugar = "None"
//        }
//        
//        if(self.item.hasIceLevels) {
//            if(self.item.iceLevelIndex == 0) {
//                ice = "Hot"
//            } else {
//                ice = self.menu.iceLevels[self.iceLevel][Int(self.iceLevel)]
//            }
//        } else {
//            ice = "None"
//        }
//        
//        self.order.add(item: self.item, qty: self.qty, sugarLevel: sugar, iceLevel: ice, upsized: self.upsized)
//        self.presentationMode.wrappedValue.dismiss()
//    }
//}
//
////struct DetailedViewOrderEditing_Previews: PreviewProvider {
////    static var previews: some View {
////        DetailedViewOrderEditing()
////    }
////}
