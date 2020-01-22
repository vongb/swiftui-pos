//
//  OrderConfirmEditing.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderConfirmEditing: View {
    @Binding var editingOrder : Bool
    var total : Double
    
    @EnvironmentObject var styles : Styles
    @EnvironmentObject var orders : Orders
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            OrderTotalLabel(total: self.total)
            
            Divider().frame(width: 300)
            
            ChangeCalculator(total: self.total)
            
            Divider().frame(width: 300)
            
            // Update Order
            HStack {
                Button(action: self.updateAndRefreshOrders) {
                    Text("Save Order")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .frame(width: 120)
                .background(styles.colors[2])
                .cornerRadius(20)
            }
        }
        .padding(20)
        .background(styles.colors[0])
        .cornerRadius(20)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func updateAndRefreshOrders() {
        self.editingOrder = false
    }
}

//struct OrderConfirmEditing_Previews: PreviewProvider {
//    static let order = CodableOrder()
//    static var previews: some View {
//        OrderConfirmEditing(order)
//    }
//}
