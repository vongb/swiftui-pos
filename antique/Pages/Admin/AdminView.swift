//
//  ReportsView.swift
//  antique
//
//  Created by Vong Beng on 30/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//
import LocalAuthentication
import SwiftUI

enum ActiveSheet {
    case incomeReport, cashoutReport, addItem, editItem
}

struct AdminView: View {
    @State private var isUnlocked = false
    
    @State private var showSheet = false
    @State private var activeSheet : ActiveSheet = .incomeReport
    
    @State private var editItemID : String = ""
    @State private var itemForEdit : MenuItem = MenuItem(name: "", price: 0)
    @State private var sectionSelection : Int = 0
    
    @State private var reset = false
    
    @EnvironmentObject var menu : Menu
    @EnvironmentObject var cashouts : Cashouts
    private var styles = Styles()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if self.isUnlocked {
                Text("Administrator")
                    .bold()
                    .font(.largeTitle)
                Divider()
                HStack {
                    Text("Reports")
                        .font(.title)
                    Spacer()
                }
                
                HStack {
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .incomeReport
                    }) {
                        Text("Reports")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding()
                    }
                    .background(Color.green)
                    .cornerRadius(10)
                    
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .cashoutReport
                    }) {
                        Text("Cashouts")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding()
                    }
                    .background(styles.colors[4])
                    .cornerRadius(10)
                }
                
                HStack {
                    Text("Menu Item Management")
                        .font(.title)
                    Spacer()
                }
                HStack {
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .addItem
                    }) {
                        Text("Add Item")
                                .foregroundColor(.white)
                                .font(.body)
                                .padding()
                    }
                    .background(styles.colors[1])
                    .cornerRadius(10)
                    
                    Spacer()
                    Button(action: {self.reset = true}) {
                        Text("Reset Menu")
                                .foregroundColor(.white)
                                .font(.body)
                                .padding()
                    }
                    .background(styles.colors[4])
                    .cornerRadius(10)
                }
                ViewItems(editItemID: self.$editItemID, editingItem: self.$showSheet, activeSheet: self.$activeSheet, itemForEdit: self.$itemForEdit, menuSectionSelection: self.$sectionSelection)
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
        .sheet(isPresented: self.$showSheet) {
            if self.activeSheet == .incomeReport {
                ReportDay()
            } else if self.activeSheet == .addItem {
                ItemEditor()
                    .environmentObject(self.menu)
            } else if self.activeSheet == .editItem {
                ItemEditor(id: self.editItemID, item: self.itemForEdit, sectionSelection: self.sectionSelection).environmentObject(self.menu)
            } else if self.activeSheet == .cashoutReport {
                CashoutReport()
                    .environmentObject(self.cashouts)
            }
        }
        .alert(isPresented: self.$reset) {
            Alert(title: Text("Confirm"), message: Text("Are you sure you want to reset the menu"), primaryButton: .destructive(Text("Reset")) {
                self.resetMenu()
            }, secondaryButton: .cancel())
        }
        .padding()
    }
    
    func resetMenu() {
        menu.resetMenu()
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Accessing Confidential Information"

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.isUnlocked = false
                    }
                }
            }
        } else {
            self.isUnlocked = false
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static let orders = Orders()
    static var previews: some View {
        AdminView()
    }
}
