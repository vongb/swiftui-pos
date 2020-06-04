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
    
    @State private var menuSectionSelection : Int = 0 {
        didSet {
            if self.menuSectionSelection == 0 {
                hasIce = true
                iceSelection = 0
            } else {
                hasIce = false
                iceSelection = 0
            }
            self.hasSugar = self.menuSectionSelection < 3
        }
    }
    
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
    
    var editingItem : Bool = false
    var title : String {
        if editingItem {
            return "Edit Item"
        } else {
            return "Create Item"
        }
    }
    
    let item : MenuItem
    let sectionSelection : Int
    
    init() {
        self.item = MenuItem(name: "", price: 0)
        self.sectionSelection = 0
        
        self.id = ""
        self.name = ""
        self.priceInCents = 0
        self.editingPrice = false
        self.canUpsize = true
        self.upsizePriceInCents = 50
        self.editingUpsizePrice = false
        self.menuSectionSelection = 0
        self.hasSugar = true
        self.hasIce = true
        self.iceSelection = 0
        self.editingItem = false
    }
    
    init(id: String, item: MenuItem, sectionSelection: Int) {
        self.id = id
        self.editingItem = true
        self.item = item
        self.sectionSelection = sectionSelection
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Edit Item")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                if editingItem {
                    DeleteItemButton(id: self.id).environmentObject(self.menu)
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
                            CurrencyTextField(currencyIsRiels: false, currencyValue: self.$priceInCents, editing: self.$editingPrice)
//                            Text("Special Discount:")
//                            CurrencyTextField(currencyIsRiels: false, currencyValue: self.$specialDiscountInCents, editing: self.$editingSpecialDiscPrice)
                            if canUpsize {
                                Text("Upsize Price")
                                    .transition(.opacity)
                                CurrencyTextField(currencyIsRiels: false, currencyValue: self.$upsizePriceInCents, editing: self.$editingUpsizePrice)
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
                    Text("Item Type")
                    Picker(selection: self.$menuSectionSelection.animation(.spring()), label: Text("Menu Section")) {
                        ForEach(0..<self.menu.items.count) {
                            Text(self.menu.items[$0].name)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
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
            self.menuSectionSelection = sectionSelection
            self.hasSugar = item.hasSugarLevels
            self.hasIce = item.hasIceLevels
            self.iceSelection = item.iceLevelIndex
            self.specialDiscountInCents = Int(item.specialDiscount * 100)
        }
    }
    
    func makeChanges() {
        let priceInDollars = Double(self.priceInCents) / 100
        let upsizeInDollars = Double(self.upsizePriceInCents) / 100
        let specialDisc = Double(self.specialDiscountInCents) / 100
        let newItem = MenuItem(name: self.name, price: priceInDollars, hasSugarLevels: self.hasSugar, iceLevelIndex: self.iceSelection, hasIceLevels: hasIce, canUpsize: self.canUpsize, upsizePrice: upsizeInDollars, specialDiscount: specialDisc)
        if !editingItem {
            self.menu.addItem(section: self.menuSectionSelection, item: newItem)
        } else {
            self.menu.update(id: self.id, section: self.menuSectionSelection, item: newItem)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddItem_Previews: PreviewProvider {
    static let menu = Menu()
    static var previews: some View {
        ItemEditor().environmentObject(menu)
    }
}
