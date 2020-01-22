//
//  OrderConfirmOrderEditing.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct OrderConfirmEditingButton: View {
    @Binding var editingOrder : Bool
    var total : Double
    
    var body: some View {
        NavigationLink(destination : OrderConfirmEditing(editingOrder: self.$editingOrder, total: self.total)) {
            HStack {
                if self.total == 0 {
                    Text("Confirm Order")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.gray)
                } else {
                    Text("Confirm Order")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(10)
            .background(Color.green)
        }
        .disabled(self.total == 0)
    }
}

//struct OrderConfirmOrderEditing_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderConfirmOrderEditing()
//    }
//}
