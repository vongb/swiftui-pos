//
//  DetailedView.swift
//  antique
//
//  Created by Vong Beng on 23/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//

import SwiftUI

struct DetailedView: View {
    @EnvironmentObject var order : Order
    @Environment(\.presentationMode) var presentationMode
    static let colors = [Color(red:0.89, green:0.98, blue:0.96),
                         Color(red:0.19, green:0.89, blue:0.79),
                         Color(red:0.07, green:0.60, blue:0.62),
                         Color(red:0.25, green:0.32, blue:0.31),
                         Color(red:0.95, green:0.51, blue:0.51),
                         Color(red:0.58, green:0.88, blue:0.83)]
    
    static let sugarLevels = ["None", "Less", "Regular", "Extra"]
    
    static let iceLevels : [[String]] = [["Hot"],
                                        ["Hot", "Less", "Regular"],
                                        ["None", "Less", "Regular"]]
    
    var item : MenuItem
    @State private var qty : Int = 1
    @State private var upsized : Bool = false
    @State private var sugarLevel : Int = 2
    @State private var iceLevel : Int = 2
    
    private var total : Double {
        if upsized {
            return (item.price + item.upsizePrice) * Double(qty)
        } else {
            return Double(qty) * item.price
        }
    }
    
    var body: some View {
        ZStack {            
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Text(item.name)
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(Self.colors[3])
                    
                    Spacer()
                    
                    Text(String(format: "$%.02f", total))
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Self.colors[3])
                }
                
                HStack() {
                    if(self.item.canUpsize) {
                        Toggle(isOn: $upsized) {
                            Text("Upsize")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Self.colors[2])
                        }.padding(0)
                    } else {
                        Spacer()
                    }
                    
                    Spacer().frame(width: 40)
                    
                    VStack(spacing: 10) {
                        Text("Quantity")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(Self.colors[2])
                        HStack (spacing: 20){
                            // Decrement QTY
                            Button(action: {
                                self.decrement()
                            }) {
                                Text("-")
                                    .font(.system(size: 25))
                                    .padding(5)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                            }
                            .background(Self.colors[4])
                            .cornerRadius(5)

                                
                            Text(String(qty))
                                .font(.system(size: 30))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .frame(width: 40)
                            
                            // Increment QTY
                            Button(action: {
                                self.increment()
                            }) {
                                Text("+")
                                    .font(.system(size: 25))
                                    .padding(5)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                            }
                            .background(Self.colors[1])
                            .cornerRadius(5)
                        }
                    }
                }
                
                if(self.item.hasSugarLevels) {
                    Spacer().frame(height: 10)
                    // Sugar Levels
                    Section(header:
                        Text("Sugar Level")
                            .padding(5)
                            .foregroundColor(Self.colors[2])
                    ) {
                        Picker("Levels:", selection: $sugarLevel) {
                            ForEach(0 ..< Self.sugarLevels.count){
                                Text("\(Self.sugarLevels[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                if(self.item.hasIceLevels && Self.iceLevels[self.item.iceLevelIndex].count > 1) {
                    // Ice Levels
                    Section(header:
                        Text("Ice Level")
                            .foregroundColor(Self.colors[2])
                    ) {
                        Picker("Levels:", selection: $iceLevel) {
                            ForEach(0 ..< Self.iceLevels[item.iceLevelIndex].count){
                                Text("\(Self.iceLevels[self.item.iceLevelIndex][$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Spacer().frame(height: 30)
                
                // Add to Order
                HStack {
                    Spacer()
                    Button(action: {
                        self.addToOrder()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add to Order")
                            .padding(10)
                            .foregroundColor(Color.white)
                    }.font(.headline)
                        .background(Self.colors[1])
                        .cornerRadius(20)
                    Spacer()
                }
                Spacer()
            }
            .padding(20)
        }
    }
    
    func addToOrder() {
        let sugar : String
        let ice : String
        if(self.item.hasSugarLevels) {
            sugar = Self.sugarLevels[self.sugarLevel]
        } else {
            sugar = "None"
        }
        
        if(self.item.hasIceLevels) {
            if(self.item.iceLevelIndex == 0) {
                ice = "Hot"
            } else {
                ice = Self.iceLevels[self.iceLevel][Int(self.iceLevel)]
            }
        } else {
            ice = "None"
        }
        
        self.order.add(item: self.item, qty: self.qty, sugarLevel: sugar, iceLevel: ice, upsized: self.upsized)
    }
    
    func decrement() {
        if(self.qty > 1) {
            self.qty -= 1
        }
    }
    func increment() {
        self.qty += 1
    }
}

struct DetailedView_Previews: PreviewProvider {
    static let order = Order()
    static var previews: some View {
        DetailedView(item: MenuItem(name: "Test Latte", price: 2.25, hasSugarLevels: false, iceLevelIndex: 1, hasIceLevels: true))
            .environmentObject(order)
    }
}
