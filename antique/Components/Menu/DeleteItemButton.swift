//
//  DeleteItemButton.swift
//  antique
//
//  Created by Vong Beng on 8/3/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct DeleteItemButton: View {
    let id : String
    @State private var attemptingDelete : Bool = false
    @EnvironmentObject var menu : Menu
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            if attemptingDelete {
                Text("Confirm Delete")
                    .font(.headline)
                    .transition(.opacity)
            }
            HStack(spacing: 10) {
                Button(action: delete) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                }
                
                if attemptingDelete {
                    Button(action: toggle) {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(Color.blue)
                    .cornerRadius(10)
                    .transition(.move(edge: .trailing))
                }
            }
        }
    }
    
    func delete() {
        if attemptingDelete {
            self.menu.remove(self.id)
            withAnimation {attemptingDelete = false }
            self.presentationMode.wrappedValue.dismiss()
        } else {
            toggle()
        }
    }
    
    func toggle() {
        withAnimation {
            self.attemptingDelete.toggle()
        }
    }
}

struct DeleteItemButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteItemButton(id: "sdf").environmentObject(Menu())
    }
}
