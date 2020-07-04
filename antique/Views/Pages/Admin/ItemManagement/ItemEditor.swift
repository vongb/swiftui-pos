//
//  AddItem.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI
import Combine

struct ItemEditor: View {
    @EnvironmentObject var menu : Menu
    @Environment(\.presentationMode) var presentationMode
    
    var id : String
    @Binding var item : MenuItem
    var sectionName : String = "Drinks"
    var editingItem : Bool = true
    
    @State private var name : String = ""
    
    @State private var priceInCents : Int = 0
    @State private var specialDiscountInCents : Int = 0
    
    @State private var editingPrice : Bool = false
    @State private var editingSpecialDiscPrice : Bool = false
    
    @State private var canUpsize : Bool = true
    @State private var upsizePriceInCents : Int = 50
    @State private var editingUpsizePrice : Bool = false
    
    private var canMakeChanges : Bool {
        return !name.isEmpty
    }
    
    @State private var menuSectionSelection : Int = 0
    
    @State private var hasSugar : Bool = true
    private var canShowSugar : Bool {
        // Removes has sugar option if item is soft drink or food.
        withAnimation { return self.menuSectionSelection < 3 }
    }
    
    @State private var hasIce : Bool = true
    @State private var iceSelection : Int = 0
    private var canShowIce : Bool {
        // Removes ice option if item is not a drink
        withAnimation{ return self.menuSectionSelection == 0 }
    }
    
    var title : String {
        if editingItem {
            return "Edit Item"
        } else {
            return "Create Item"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                if editingItem {
                    DeleteItemButton(id: self.id)
                        .environmentObject(self.menu)
                }
            }
            Divider()
            
            ScrollView {
                Group {
                    TextField("Item Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.largeTitle)
                    HStack(spacing: 10) {
                        VStack(alignment: .leading) {
                            Text("Price:")
                            CurrencyTextField(hideDecimal: false, currencyValue: self.$priceInCents, editing: self.$editingPrice)
                            Text("Special Discount:")
                            CurrencyTextField(hideDecimal: false, currencyValue: self.$specialDiscountInCents, editing: self.$editingSpecialDiscPrice)
                            if canUpsize {
                                Text("Upsize Price")
                                    .transition(.opacity)
                                CurrencyTextField(hideDecimal: false, currencyValue: self.$upsizePriceInCents, editing: self.$editingUpsizePrice)
                                    .transition(.opacity)
                            }
                        }
                        Divider().frame(height: (self.canUpsize ? 100 : 50))
                        Toggle("Can Upsize?", isOn: self.$canUpsize)
                            .onTapGesture {
                                withAnimation{
                                    self.canUpsize.toggle()
                                }
                            }
                    }
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 20)
                
                Group {
                    if !editingItem {
                    Text("Item Type")
                        Picker(selection: self.$menuSectionSelection.animation(.spring()), label: Text("Menu Section")) {
                            ForEach(0..<self.menu.items.count) {
                                Text(self.menu.items[$0].name)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    if canShowSugar {
                        Divider()
                        Toggle("Has Sugar Levels?", isOn: self.$hasSugar)
                            .transition(.scale)
                    }
                    
                    if canShowIce {
                        Divider()
                        Toggle("Has Ice Levels?", isOn: self.$hasIce.animation(.spring()))
                        if hasIce {
                            Picker(selection: self.$iceSelection, label: Text("Ice Level Types")) {
                                ForEach(0..<self.menu.iceLevels.count) {
                                    Text(self.menu.iceLevels[$0].joined(separator: "-"))
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    Button(action: self.makeChanges) {
                        Text("Save Changes")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .disabled(!self.canMakeChanges)
                    .background(self.canMakeChanges ? Styles.getColor(.brightCyan) : Styles.getColor(.lightGreen))
                    .cornerRadius(15)
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .padding()
        .onAppear(perform: setUpEdit)
    }
    
    func setUpEdit() {
        if self.editingItem {
            self.editingPrice = false
            self.editingUpsizePrice = false
            
            self.name = item.name
            self.priceInCents = Int(item.price * 100)
            self.canUpsize = item.canUpsize
            self.upsizePriceInCents = Int(item.upsizePrice * 100)
            self.hasSugar = item.hasSugarLevels
            self.hasIce = item.hasIceLevels
            self.iceSelection = item.iceLevelIndex
            self.specialDiscountInCents = Int(item.specialDiscount * 100)
            
            self.menuSectionSelection = self.menu.getSectionIndex(name: sectionName)
        }
    }
    
    func makeChanges() {
        let priceInDollars = convertToDollars(self.priceInCents)
        let upsizeInDollars = convertToDollars(self.upsizePriceInCents)
        let specialDisc = convertToDollars(self.specialDiscountInCents)
        let newItem = MenuItem(name: self.name, price: priceInDollars, hasSugarLevels: self.hasSugar, iceLevelIndex: self.iceSelection, hasIceLevels: hasIce, canUpsize: self.canUpsize, upsizePrice: upsizeInDollars, specialDiscount: specialDisc)
        // Updates include refresh
        if !editingItem {
            self.menu.addItem(section: self.menuSectionSelection, item: newItem)
        } else {
            self.menu.update(id: self.id, section: self.menuSectionSelection, item: newItem)
        }
        self.item = newItem
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func convertToDollars(_ cents : Int) -> Double {
        return Double(cents) / 100
    }
}

