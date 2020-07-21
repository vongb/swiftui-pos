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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Manage Menu Sections")
                .font(.largeTitle)
                .bold()
            Divider()
            
            ScrollView {
                HStack {
                    TextField("New Section", text: $newSectionName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        self.menu.appendNewSection(self.newSectionName)
                        self.newSectionName = ""
                    }) {
                        Text("Create")
                            .font(.headline)
                    }
                }
                .padding()
                Text("Ensure Section Name is Unique").font(.caption)
                ForEach(self.menu.items, id: \.self) { section in
                    EditMenuSectionRow(menuSection: self.$menu.items[self.menu.getSectionIndex(name: section.name)])
                }
                Spacer()
            }
        }
        .padding()
        
    }
}

struct ManageMenuSections_Previews: PreviewProvider {
    static var previews: some View {
        ManageMenuSections()
    }
}
