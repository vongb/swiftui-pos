//
//  ManageMenuSections.swift
//  antique
//
//  Created by Vong Beng on 9/7/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ManageMenuSections: View {
    @EnvironmentObject var menu : Menu
    @State private var newSectionName : String = ""
    @State private var showDeleteAlert = false
    @State private var sectionCreatedSuccess = true
    @State private var offset : IndexSet = IndexSet()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("New Section", text: $newSectionName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: createMenuSection) {
                    Text("Create")
                        .font(.headline)
                        .foregroundColor(newSectionName.isEmpty ? .gray : .accentColor)
                }
                .disabled(newSectionName.isEmpty)
            }
            .padding()
            
            if !sectionCreatedSuccess {
                Text("Name already exists! Try again.")
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.slide)
                    .animation(.default)
            }
            
            Divider()
            
            List {
                ForEach(self.menu.items, id: \.self) { section in
                    NavigationLink(destination: MenuSectionEditor(id: section.id.uuidString, menuSection: section)) {
                        VStack(alignment: .leading) {
                            Text(section.name)
                                .font(.headline)
                            Text("\(section.items.count) items")
                                .font(.caption)
                        }
                    }
                }
                .onDelete(perform: confirmDelete)
                .onMove(perform: menu.moveSection)
            }
            .navigationBarItems(trailing: EditButton())
        }
        .padding()
        .navigationBarTitle("Manage Menu Sections")
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Confirm"), message: Text("Deleting menu section will delete all items"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {self.menu.deleteSection(self.offset)}))
        }
    }
    
    private func confirmDelete(_ offsets: IndexSet) {
        showDeleteAlert.toggle()
        self.offset = offsets
    }
    
    private func createMenuSection() {
        withAnimation {
            self.sectionCreatedSuccess = self.menu.appendNewSection(self.newSectionName)
        }
        if sectionCreatedSuccess {
            newSectionName.removeAll()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    sectionCreatedSuccess = true
                }
            }
        }
    }
}

struct ManageMenuSections_Previews: PreviewProvider {
    static var previews: some View {
        ManageMenuSections()
    }
}
