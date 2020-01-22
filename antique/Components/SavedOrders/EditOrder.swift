//
//  EditOrder.swift
//  antique
//
//  Created by Vong Beng on 18/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct EditOrder: View {
    @Binding var order : CodableOrder
    
    var body: some View {
        Button(action: edit) {
            Text("Edit")
        }
    }
    
    func edit() {
        
    }
}

//struct EditOrder_Previews: PreviewProvider {
//    static var previews: some View {
//        EditOrder()
//    }
//}
