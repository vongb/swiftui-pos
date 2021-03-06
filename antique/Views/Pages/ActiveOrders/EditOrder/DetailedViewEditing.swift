//
//  DetailedViewOrderEditing.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct DetailedViewEditing: View {
    @Binding var items : [OrderItem]
    var item : MenuItem
    
    @EnvironmentObject var menu : Menu
    @Environment(\.presentationMode) var presentationMode
    
    @State private var qty : Int = 1
    @State private var upsized : Bool = false
    @State private var sugarLevel : Int = 4
    @State private var iceLevel : Int = 2
    @State private var specialDiscounted : Bool = false
    
    private var total : Double {
        var basePrice = item.price
        if specialDiscounted {
            basePrice -= item.specialDiscount
        }
        if upsized && item.canUpsize {
            basePrice += item.upsizePrice
        }
        return basePrice * Double(qty)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DetailedItemTitle(item: item, total: self.total)
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    // Upsize
                    if(self.item.canUpsize) {
                        UpsizeItem(upsized: $upsized)
                        Text(String(format: "+$%0.02f ea", self.item.upsizePrice))
                            .font(.caption)
                    }
                    // Special Discount
                    SpecialDiscountItem(specialDiscounted: self.$specialDiscounted)
                    Text(String(format: "-$%.02f ea", self.item.specialDiscount))
                }
                QtyUpdater(qty: $qty)
            }

            if(self.item.hasSugarLevels) {
                Spacer().frame(height: 10)
                // Sugar Levels
                SugarSelector(sugarLevel: $sugarLevel)
            }
            
            if(self.item.hasIceLevels && self.menu.iceLevels[self.item.iceLevelIndex].count > 1) {
                Spacer().frame(height: 10)
                // Ice Levels
                IceSelector(iceLevel: $iceLevel, item: self.item)
            }
            
            Spacer().frame(height: 30)
            
            // Add to Order
            HStack {
                Spacer()
                Button(action: addToOrder) {
                    Text("Add to Order")
                        .font(.headline)
                        .padding(10)
                        .foregroundColor(Color.white)
                }
                .background(Styles.getColor(.brightCyan))
                .cornerRadius(20)
                Spacer()
            }
            Spacer()
        }
        .padding(20)
    }
    func addToOrder() {
        
        let sugar : String
        let ice : String
        if self.item.hasSugarLevels {
            sugar = self.menu.sugarLevels[self.sugarLevel]
        } else {
            sugar = "0%"
        }
        
        if self.item.hasIceLevels {
            if self.item.iceLevelIndex == 0 {
                ice = "Hot"
            } else {
                ice = self.menu.iceLevels[self.iceLevel][Int(self.iceLevel)]
            }
        } else {
            ice = "None"
        }
        
        let newItem = OrderItem(item: item, qty: qty, upsized: upsized, specialDiscounted: specialDiscounted, sugarLevel: sugar, iceLevel: ice)
        for (index, orderItem) in items.enumerated() {
            if OrderItem.hasSameAttributes(newItem, orderItem) {
                items[index].qty = items[index].qty + newItem.qty
                let item = items.remove(at: index)
                items.append(item)
                self.presentationMode.wrappedValue.dismiss()
                return
            }
        }
        self.items.append(newItem)
        self.presentationMode.wrappedValue.dismiss()
    }
}
