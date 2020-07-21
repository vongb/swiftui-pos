//
//  EditMenuSection.swift
//  antique
//
//  Created by Vong Beng on 9/7/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct EditMenuSectionRow: View {
    @EnvironmentObject var menu : Menu
    @Binding var menuSection : MenuSection
    @State private var editing : Bool = false
    @State private var showingAlert : Bool = false
    @State private var newName : String = ""
    
    var body: some View {
        Button(action: { self.editing = true }) {
            Text(self.menuSection.name)
            Spacer()
                Image(systemName: "square.and.pencil")
                    .font(.largeTitle)
        }
        .sheet(isPresented: $editing) {
            VStack(alignment: .center) {
                Text("Editing Section")
                    .font(.largeTitle)
                    .bold()
                Divider()
                HStack {
                    TextField("Section Name", text: self.$newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // DELETE
                    Button(action: {self.showingAlert = true}) {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                    }
                }
                
                HStack(alignment: .center) {
                    Button(action: self.save) {
                        Text("Save Changes")
                            .foregroundColor(.green)
                    }
                    
                    Divider().frame(height: 20)
                    
                    Button(action: self.cancelEdit) {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }
                }
                Spacer()
            }
            .padding()
            .alert(isPresented: self.$showingAlert) {
                Alert(title: Text("Are you sure?"),
                      message: Text("Deleting a section deletes all its items."),
                      primaryButton: .destructive(Text("Delete"), action: {
                        self.menu.deleteSection(self.menuSection.name)
                      }),
                      secondaryButton: .cancel())
            }
        }
        .padding()
        .onAppear(perform: {self.newName = self.menuSection.name})
        
    }
    
    func save() {
        self.menu.updateSectionName(newName: self.newName, for: self.menuSection)
        withAnimation {
            self.editing = false
        }
    }
    
    func cancelEdit() {
        newName = menuSection.name
        withAnimation {
            editing = false
        }
    }
}
