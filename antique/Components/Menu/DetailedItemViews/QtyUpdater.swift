//
//  QtyUpdater.swift
//  antique
//
//  Created by Vong Beng on 19/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct QtyUpdater: View {
    @ObservedObject var styles = Styles()
    @Binding var qty : Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Quantity")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(styles.colors[2])
            HStack (spacing: 20){
                // Decrement QTY
                Button(action: decrement) {
                    Text("-")
                        .font(.system(size: 25))
                        .padding(5)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .background(styles.colors[4])
                .cornerRadius(5)

                    
                Text(String(qty))
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .frame(width: 40)
                
                // Increment QTY
                Button(action: increment) {
                    Text("+")
                        .font(.system(size: 25))
                        .padding(5)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .background(styles.colors[1])
                .cornerRadius(5)
            }
        }
    }
    
    func decrement() {
        if(self.qty > 1) {
            self.qty -= 1
        }
    }
    func increment() {
        self.qty += 1
    }
}

//struct QtyUpdater_Previews: PreviewProvider {
//    static var previews: some View {
//        QtyUpdater()
//    }
//}
