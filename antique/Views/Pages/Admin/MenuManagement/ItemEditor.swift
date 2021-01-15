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
    
    var id : String = ""
    @State var item = MenuItem()
    var sectionName : String = "Drinks"
    var editingItem : Bool = true
    
    @State private var makeChangesOutcome : Bool = true
    @State private var feedback : String = ""
    
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
    
    @State private var hasIce : Bool = true
    @State private var iceSelection : Int = 0
    
    var title : String {
        if editingItem {
            return "Edit Item"
        } else {
            return "Create Item"
        }
    }
    
    var body: some View {
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
                
                Divider()
                Toggle("Has Sugar Levels?", isOn: self.$hasSugar)
            
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
                Button(action: self.makeChanges) {
                    Text(title)
                        .foregroundColor(.white)
                        .padding()
                }
                .disabled(!self.canMakeChanges)
                .background(self.canMakeChanges ? Styles.getColor(.brightCyan) : Styles.getColor(.lightGreen))
                .cornerRadius(15)
                
                Text(feedback)
                    .font(.caption)
                    .foregroundColor(makeChangesOutcome ? .green : .red)
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .padding()
        .onAppear(perform: setUpEdit)
        .navigationBarTitle(title)
        
    }
    
    func setUpEdit() {
        if self.editingItem {
            self.editingPrice = false
            self.editingUpsizePrice = false
            
            self.name = item.name
            self.priceInCents = Currency.convertToCents(dollars: item.price)
            self.canUpsize = item.canUpsize
            self.upsizePriceInCents = Currency.convertToCents(dollars: item.upsizePrice)
            self.hasSugar = item.hasSugarLevels
            self.hasIce = item.hasIceLevels
            self.iceSelection = item.iceLevelIndex
            self.specialDiscountInCents = Currency.convertToCents(dollars: item.specialDiscount)
            
            self.menuSectionSelection = self.menu.getSectionIndex(name: sectionName)
        }
    }
    
    func makeChanges() {
        let priceInDollars = convertToDollars(self.priceInCents)
        let upsizeInDollars = convertToDollars(self.upsizePriceInCents)
        let specialDisc = convertToDollars(self.specialDiscountInCents)
        let newItem = MenuItem(name: self.name, price: priceInDollars, hasSugarLevels: self.hasSugar, iceLevelIndex: self.iceSelection, hasIceLevels: hasIce, canUpsize: self.canUpsize, upsizePrice: upsizeInDollars, specialDiscount: specialDisc)
        // Updates include refresh
        if editingItem {
            self.menu.updateItem(id: self.id, section: self.menuSectionSelection, item: newItem)
            self.presentationMode.wrappedValue.dismiss()
        } else {
            makeChangesOutcome = self.menu.addItem(section: self.menuSectionSelection, item: newItem)
            reset()
            self.feedback = makeChangesOutcome ? "Created Succesfully" : "Fail to create item"
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                feedback.removeAll()
            }
        }
    }
    
    func reset() {
        name = ""
        
        priceInCents = 0
        specialDiscountInCents = 0
        
        editingPrice = false
        editingSpecialDiscPrice = false
        
        canUpsize = true
        upsizePriceInCents = 50
        editingUpsizePrice = false
    }
    
    private func convertToDollars(_ cents : Int) -> Double {
        return Double(cents) / 100
    }
}

