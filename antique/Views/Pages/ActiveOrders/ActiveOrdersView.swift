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
    @State private var onlyShowActive : Bool = true
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
                            Toggle(isOn: $onlyShowActive){
                                Text("Active Orders Only")
                            }
                            .onTapGesture {
                                withAnimation {
                                    self.onlyShowActive.toggle()
                                }
                            }
                            if onlyShowActive {
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
                        if cashouts.cashouts.count == 0 {
                            Button(action: updateCashouts) {
                                Text("Refresh Cashouts")
                            }
                            Text("No Cashouts")
                                .bold()
                        } else {
                            ForEach(cashouts.cashouts) { cashout in
                                CashOutRow(cashout: cashout)
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


