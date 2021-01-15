//
//  AdminPageTwo.swift
//  antique
//
//  Created by Vong Beng on 2/8/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var menu : Menu
    @EnvironmentObject var authenticator : PasscodeAuthenticator
    @State var items: [BarItem] = [BarItem(label: "Mon", amount: 300),
                                  BarItem(label: "Tue", amount: 433),
                                  BarItem(label: "Wed", amount: 489),
                                  BarItem(label: "Thu", amount: -200),
                                  BarItem(label: "Fri", amount: 400),
                                  BarItem(label: "Sat", amount: 500),
                                  BarItem(label: "Sun", amount: 600),
                                  BarItem(label: "Mon", amount: 900),
                                  BarItem(label: "Tue", amount: 150),
                                  BarItem(label: "Wed", amount: 200),
                                  BarItem(label: "Thu", amount: 300),
                                  BarItem(label: "Fri", amount: 200),
                                  BarItem(label: "Sat", amount: 400),
                                  BarItem(label: "Sun", amount: 348),
                                  BarItem(label: "Mon", amount: 239),
                                  BarItem(label: "Tue", amount: 583),
                                  BarItem(label: "Wed", amount: 439),
                                  BarItem(label: "Thu", amount: 450),
                                  BarItem(label: "Fri", amount: -250),
                                  BarItem(label: "Sat", amount: -120),
                                  BarItem(label: "Sun", amount: 238)]
    func refreshItems() {
        for index in items.indices {
            items[index].amount = Double.random(in: -800...1200)
        }
    }
    
    var body: some View {
        VStack {
            if authenticator.authenticated {
                NavigationView {
                    List {
                        Section(header: Text("Reports")) {
                            NavigationLink("Profits", destination: ProfitReport())
                            NavigationLink("Income by Category", destination: ItemCategoryReport())
                            NavigationLink("Payment Report", destination: PaymentTypeReport()
                            )
                            NavigationLink("All Orders", destination: AllOrdersReport())
                            NavigationLink("All Cashouts", destination: CashoutReport())
                        }
                        
                        Section(header: Text("Menu")) {
                            NavigationLink("Edit Menu Items", destination: ViewItems())
                            NavigationLink("Create Menu Item", destination: ItemEditor(editingItem: false))
                            NavigationLink("Edit Menu Sections", destination: ManageMenuSections())
                            NavigationLink("Manage Payment Types", destination: ManagePaymentTypes())
                        }
                        
                        Section(header: Text("Other")) {
                            NavigationLink("Passcode", destination: ChangePasscode())
                            NavigationLink("Wifi & Exchange Rate", destination: EditMisc())
                        }
                    }
                    .navigationBarTitle("Administrator")
                }
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
            } else {
                PasscodeInput(prompt: "Enter Passcode",
                              value: $authenticator.value,
                              passcodeDisplay: $authenticator.passcodeDisplay,
                              displayColor: $authenticator.passcodeDisplayColor)
            }
        }
        .onAppear(perform: {self.authenticator.reset()})
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
            .environmentObject(Menu())
            .environmentObject(PasscodeAuthenticator())
    }
}
