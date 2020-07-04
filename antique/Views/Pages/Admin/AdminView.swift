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
    case incomeReport, cashoutReport, orderReport, addItem, updatePasscode, editMisc
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
    @EnvironmentObject var printer : BLEConnection
    @EnvironmentObject var orders : Orders

    
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
                
                // REPORTS
                HStack {
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .incomeReport
                    }) {
                        Text("Reports")
                        .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: .green))
                    
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .cashoutReport
                    }) {
                        Text("Cashouts")
                        .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.lightRed)))
                    
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .orderReport
                    }) {
                        Text("Orders")
                        .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.darkGreen)))
                    
                    Spacer()
                    
                    
                    // MISCELLANEOUS
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .updatePasscode
                    }) {
                        Text("Set Passcode")
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.brightCyan)))
                    
                    Button(action: {
                        self.showSheet = true
                        self.activeSheet = .editMisc
                    }) {
                        Text("Wifi & Exchange Rate")
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.darkGrey)))
                }
                
                // MENU MANAGEMENT
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
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.brightCyan)))
//                    Button(action: {
//                        self.showSheet = true
//                        self.activeSheet = .viewItems
//                    }) {
//                        Text("View Items")
//                            .modifier(AdminButtonTextModifier())
//                    }
//                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.darkGreen)))
                    Spacer()
                    Button(action: {self.reset = true}) {
                        Text("Reset Menu")
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.lightRed)))
                }
                ViewItems()
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
                ItemEditor(id: "", item: .constant(MenuItem()), editingItem: false)
                    .environmentObject(self.menu)
            } else if self.activeSheet == .cashoutReport {
                CashoutReport()
                    .environmentObject(self.cashouts)
            } else if self.activeSheet == .updatePasscode {
                ChangePasscode()
            } else if self.activeSheet == .editMisc {
                EditMisc()
            } else if self.activeSheet == .orderReport {
                AllOrdersReport()
                    .environmentObject(self.printer)
                    .environmentObject(self.menu)
                    .environmentObject(self.orders)
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
}

struct AdminView_Previews: PreviewProvider {
    static let orders = Orders()
    static var previews: some View {
        AdminView()
    }
}

struct AdminButtonModifier : ViewModifier {
    var backgroundColor : Color
    func body(content: Content) -> some View {
        return content
            .background(self.backgroundColor)
            .cornerRadius(10)
    }
}

struct AdminButtonTextModifier : ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.white)
            .font(.body)
            .padding()
    }
}
