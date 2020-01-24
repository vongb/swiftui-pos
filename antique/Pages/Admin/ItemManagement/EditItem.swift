//
//  EditItem.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct EditItem: View {
    @ObservedObject var styles = Styles()
    @EnvironmentObject var menu : Menu
    @Environment(\.presentationMode) var presentationMode
    
    var item : MenuItem
    
    @State var isEditing : Bool = false
    @State var attemptingDelete : Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                BlackText(text: item.name, fontSize: 40)
                Spacer().frame(width: 50)
                
                if !attemptingDelete {
                    if !isEditing {
                        Button(action: {self.isEditing = true}) {
                            Text("Edit")
                                .font(.system(size: 25))
                                .padding(10)
                                .foregroundColor(.white)
                                .background(self.styles.colors[1])
                                .cornerRadius(5)
                        }
                        Button(action: { self.attemptingDelete = true }) {
                            Text("Delete")
                                .font(.system(size: 25))
                                .padding(10)
                                .foregroundColor(.white)
                                .background(self.styles.colors[4])
                                .cornerRadius(5)
                        }
                    } else {
                        Button(action: save) {
                            Text("Save Changes")
                                .font(.system(size: 25))
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(5)
                        }
                    }
                } else {
                    VStack {
                        Text("Confirm Delete")
                            .font(.system(size: 20))
                            .bold()
                            .padding(5)
                        HStack {
                            Button(action: delete) {
                                Text("Yes")
                                    .font(.system(size: 25))
                                    .padding(10)
                                    .foregroundColor(.white)
                                    .background(Color.red)
                                    .cornerRadius(5)
                            }
                            Button(action: {self.attemptingDelete = false}) {
                                Text("No")
                                    .font(.system(size: 25))
                                    .padding(10)
                                    .foregroundColor(.white)
                                    .background(self.styles.colors[3])
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            
        }
        .padding(10)
    }
    
    func delete(){
        // per form delete
        self.menu.refreshMenuItems()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func save(){
        isEditing = false
        // write to file
        // refresh menu
    }
}

struct EditItem_Previews: PreviewProvider {
    static let styles = Styles()
    static let item = MenuItem(name: "Iced Chocolate", price: 1.5)
    static var previews: some View {
        EditItem(item: item).environmentObject(styles)
    }
}
