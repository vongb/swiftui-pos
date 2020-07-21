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
    case incomeReport, cashoutReport, orderReport, categoryReport, addItem, manageMenuSections, updatePasscode, editMisc
}

struct AdminView: View {
    @ObservedObject var authenticator = PasscodeAuthenticator()
    
//    @State private var showSheet = false
//    @State private var activeSheet : ActiveSheet = .incomeReport
    
    // SHEET BOOLEANS
    @State private var showIncomeReport : Bool = false
    @State private var showCashoutReport = false
    @State private var showOrderReport = false
    @State private var showCategoryReport = false
    @State private var showAddItem = false
    @State private var showManageMenuSections = false
    @State private var showUpdatePasscode = false
    @State private var showEditMisc = false
    
    
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
//                        self.activeSheet = .incomeReport
//                        self.showSheet = true
                        self.showIncomeReport = true
                    }) {
                        Text("Reports")
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: .green))
                    .sheet(isPresented: $showIncomeReport) {
                        ReportDay()
                    }
                    
                    Button(action: {
//                        self.activeSheet = .categoryReport
//                        self.showSheet = true
                        self.showCategoryReport = true
                    }) {
                        Text("Categories")
                            .multilineTextAlignment(.center)
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.brightCyan)))
                    .sheet(isPresented: $showCategoryReport) {
                        ItemCategoryReport()
                    }
                    
                    Button(action: {
//                        self.activeSheet = .cashoutReport
//                        self.showSheet = true
                        self.showCashoutReport = true
                    }) {
                        Text("Cashouts")
                        .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.lightRed)))
                    .sheet(isPresented: $showCashoutReport) {
                        CashoutReport()
                            .environmentObject(self.cashouts)
                    }
                    
                    Button(action: {
//                        self.showSheet = true
//                        self.activeSheet = .orderReport
                        self.showOrderReport = true
                    }) {
                        Text("Orders")
                        .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.darkGreen)))
                    .sheet(isPresented: $showOrderReport) {
                        AllOrdersReport()
                            .environmentObject(self.printer)
                            .environmentObject(self.menu)
                            .environmentObject(self.orders)
                    }
                    
                    Spacer()
                    
                    
                    // MISCELLANEOUS
                    Button(action: {
//                        self.activeSheet = .updatePasscode
//                        self.showSheet = true
                        self.showUpdatePasscode = true
                    }) {
                        Text("Set Passcode")
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.brightCyan)))
                    .sheet(isPresented: $showUpdatePasscode, content: {
                        ChangePasscode()
                    })
                    
                    Button(action: {
//                        self.showSheet = true
//                        self.activeSheet = .editMisc
                        self.showEditMisc = true
                    }) {
                        Text("Wifi & Exchange Rate")
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.darkGrey)))
                    .sheet(isPresented: $showEditMisc, content: {
                        EditMisc()
                    })
                }
                
                // MENU MANAGEMENT
                HStack {
                    Text("Menu Item Management")
                        .font(.title)
                    Spacer()
                }
                HStack {
                    Button(action: {
//                        self.activeSheet = .addItem
//                        self.showSheet = true
                        self.showAddItem = true
                    }) {
                        Text("Add Item")
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.brightCyan)))
                    .sheet(isPresented: $showAddItem, content: {
                        ItemEditor(id: "", item: .constant(MenuItem()), editingItem: false)
                            .environmentObject(self.menu)
                    })
                    
                    Button(action: {
//                        self.activeSheet = .manageMenuSections
//                        self.showSheet = true
                        self.showManageMenuSections = true
                    }) {
                        Text("Manage Sections")
                            .modifier(AdminButtonTextModifier())
                    }
                    .modifier(AdminButtonModifier(backgroundColor: Styles.getColor(.darkGreen)))
                    .sheet(isPresented: $showManageMenuSections, content: {
                        ManageMenuSections()
                            .environmentObject(self.menu)
                    })
                    
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
//        .sheet(isPresented: self.$showSheet) {
//            if self.activeSheet == .orderReport {
//                AllOrdersReport()
//                    .environmentObject(self.printer)
//                    .environmentObject(self.menu)
//                    .environmentObject(self.orders)
//            } else if self.activeSheet == .categoryReport {
//                ItemCategoryReport()
//            } else if self.activeSheet == .addItem {
//                ItemEditor(id: "", item: .constant(MenuItem()), editingItem: false)
//                    .environmentObject(self.menu)
//            } else if self.activeSheet == .manageMenuSections {
//                ManageMenuSections()
//                    .environmentObject(self.menu)
//            } else if self.activeSheet == .cashoutReport {
//                CashoutReport()
//                    .environmentObject(self.cashouts)
//            } else if self.activeSheet == .updatePasscode {
//                ChangePasscode()
//            } else if self.activeSheet == .editMisc {
//                EditMisc()
//            } else if self.activeSheet == .incomeReport {
//                ReportDay()
//            }
//        }
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
