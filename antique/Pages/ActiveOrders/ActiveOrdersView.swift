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
    @State var onlyShowActive : Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                
                if orders.savedOrders.count == 0 {
                    Button(action: updateOrders) {
                        Text("Refresh Orders")
                    }
                    Text("No Orders")
                        .bold()
                } else {
                    List {
                        Toggle(isOn: $onlyShowActive){
                            Text("Active Orders Only")
                        }
                        if onlyShowActive {
                            ForEach(orders.savedOrders.filter{!$0.settled} ) { order in
                                SavedOrderRow(order: order, orderNo: order.orderNo)
                            }
                        } else {
                            ForEach(orders.savedOrders) { order in
                                SavedOrderRow(order: order, orderNo: order.orderNo)
                            }
                        }
                    }
                    .navigationBarTitle("Orders")
                    .navigationViewStyle(DoubleColumnNavigationViewStyle())
                }
            }
        }
    }
    
    func updateOrders() {
        orders.refreshSavedOrders()
    }
}

struct ActiveOrdersView_Previews: PreviewProvider {
    static let orders = Orders()
    static var previews: some View {
        ActiveOrdersView().environmentObject(orders)
    }
}
