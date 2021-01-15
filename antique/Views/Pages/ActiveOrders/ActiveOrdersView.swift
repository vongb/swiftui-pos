//
//  ActiveOrdersView.swift
//  antique
//
//  Created by Vong Beng on 7/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ActiveOrdersView: View {
    @EnvironmentObject var orders : Orders
    @EnvironmentObject var cashouts : Cashouts
    @State private var showActiveOrders : Bool = true
    @State private var showCashout : Bool = false
    var body: some View {
        NavigationView {
            Form {
                List {
                    Section(header: Text("Orders").font(.headline)) {
                        if orders.savedOrders.count == 0 {
                            Button(action: updateOrders) {
                                Text("Refresh Orders")
                            }
                            Text("No Orders")
                                .bold()
                        } else {
                            Toggle(isOn: $showActiveOrders){
                                Text("Active Orders Only")
                            }
                            .onTapGesture {
                                withAnimation {
                                    self.showActiveOrders.toggle()
                                }
                            }
                            if showActiveOrders {
                                ForEach(orders.savedOrders.filter{!$0.settled && !$0.cancelled} ) { order in
                                    SavedOrderRow(order: order, orderNo: order.orderNo)
                                }
                            } else {
                                ForEach(orders.savedOrders) { order in
                                    SavedOrderRow(order: order, orderNo: order.orderNo)
                                }
                            }
                        }
                    }
                    Section(header: Text("Cashouts").font(.headline)) {
                        Toggle(isOn: $showCashout) {
                            Text("Show Cashouts")
                        }
                        .onTapGesture {
                            withAnimation {
                                self.showCashout.toggle()
                            }
                        }
                        if cashouts.cashouts.count == 0 {
                            Button(action: updateCashouts) {
                                Text("Refresh Cashouts")
                            }
                            Text("No Cashouts")
                                .bold()
                        } else {
                            if showCashout {
                                ForEach(cashouts.cashouts) { cashout in
                                    CashOutRow(cashout: cashout)
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Manage")
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
            }
        }
    }
    
    func updateOrders() {
        orders.refreshSavedOrders()
    }
    
    func updateCashouts() {
        cashouts.refreshCashouts()
    }
}

struct ActiveOrdersView_Previews: PreviewProvider {
    static let orders = Orders()
    static var previews: some View {
        ActiveOrdersView().environmentObject(orders)
    }
}


