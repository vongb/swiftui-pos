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
    case incomeReport, cashoutReport, addItem, editItem, updatePasscode, editMisc
}

struct AdminView: View {
    @ObservedObject var authenticator = PasscodeAuthenticator()
    
    @State private var showSheet = false
    @State private var activeSheet : ActiveSheet = .incomeReport
    
    @State private var editItemID : String = ""
    @State private var itemForEdit : MenuItem = MenuItem(name: "", price: 0)
    @State private var sectionSelection : Int = 0
    
    @State private var reset = false
    
    @EnvironmentObject var menu : Menu
    @EnvironmentObject var cashouts : Cashouts

    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if self.authenticator.authenticated {
                Text("Administrator")
                    .bold()
                    .font(.largeTitle)
                Divider()
                HStack {
                    Text("Reports")
                        .font(.title)
                    Spacer()
                    Text("Other")
                        .font(.title)
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
                    .background(Styles.getColor(.lightRed))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .updatePasscode
                    }) {
                        Text("Set Passcode")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding()
                    }
                    .background(Styles.getColor(.brightCyan))
                    .cornerRadius(10)
                    
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .editMisc
                    }) {
                        Text("Wifi & Exchange Rate")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding()
                    }
                    .background(Styles.getColor(.darkGrey))
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
                    .background(Styles.getColor(.brightCyan))
                    .cornerRadius(10)
                    
                    Spacer()
                    Button(action: {self.reset = true}) {
                        Text("Reset Menu")
                                .foregroundColor(.white)
                                .font(.body)
                                .padding()
                    }
                    .background(Styles.getColor(.lightRed))
                    .cornerRadius(10)
                }
                ViewItems(editItemID: self.$editItemID, editingItem: self.$showSheet, activeSheet: self.$activeSheet, itemForEdit: self.$itemForEdit, menuSectionSelection: self.$sectionSelection)
            } else {
                PasscodeInput(prompt: "Enter Passcode",
                              value: $authenticator.value,
                              passcodeDisplay: $authenticator.passcodeDisplay,
                              displayColor: $authenticator.passcodeDisplayColor)
            }
        }
        .onAppear(perform: self.resetAuthentication)
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
            } else if self.activeSheet == .updatePasscode {
                ChangePasscode()
            } else if self.activeSheet == .editMisc {
                EditMisc()
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
    
    func resetAuthentication() {
        self.authenticator.reset()
    }
    
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//
//        // check whether biometric authentication is possible
//        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
//            // it's possible, so go ahead and use it
//            let reason = "Accessing Confidential Information"
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                // authentication has now completed
//                DispatchQueue.main.async {
//                    if success {
//                        self.isUnlocked = true
//                    } else {
//                        self.isUnlocked = false
//                    }
//                }
//            }
//        } else {
//            self.isUnlocked = false
//        }
//    }
}

struct AdminView_Previews: PreviewProvider {
    static let orders = Orders()
    static var previews: some View {
        AdminView()
    }
}
