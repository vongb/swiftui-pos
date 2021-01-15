//
//  EditMenuSection.swift
//  antique
//
//  Created by Vong Beng on 9/7/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct MenuSectionEditor: View {
    @EnvironmentObject var menu : Menu
    @Environment(\.presentationMode) var presentationMode

    var id : String
    @State var menuSection : MenuSection
    @State private var newName : String = ""
    @State private var hideFeedback : Bool = true
    
    private var canMakeChanges : Bool {
        newName != menuSection.name
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Section Name", text: self.$newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if !hideFeedback {
                Text("Section name exists, try again.")
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.slide)
            }
            Button(action: self.save) {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .padding()
            }
            .disabled(!self.canMakeChanges)
            .background(self.canMakeChanges ? Styles.getColor(.brightCyan) : Styles.getColor(.lightGreen))
            .cornerRadius(15)
            Spacer()
        }
        .padding()
        .onAppear(perform: {self.newName = self.menuSection.name})
        .navigationBarTitle("Editing Menu Section")
    }
    
    func save() {
        withAnimation {
            hideFeedback = self.menu.updateSectionName(newName: self.newName, for: self.menuSection)
        }
        if !hideFeedback {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    hideFeedback = true
                }
            }
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

