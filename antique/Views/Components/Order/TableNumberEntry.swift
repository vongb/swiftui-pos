//
//  TableNumberEntry.swift
//  antique
//
//  Created by Vong Beng on 21/7/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct TableNumberEntry: View {
    @Binding var editing : Bool
    @Binding var tableID : String
    
    var body: some View {
        VStack( alignment: .center, spacing: 5) {
            if editing {
                Text("Table: \(tableID)")
                    .font(.title)
                    .bold()
                
                HStack(spacing: 5) {
                    TableNumButton(bindedValue: $tableID, value: "1")
                    TableNumButton(bindedValue: $tableID, value: "2")
                    TableNumButton(bindedValue: $tableID, value: "3")
                }

                HStack(spacing: 5) {
                    TableNumButton(bindedValue: $tableID, value: "4")
                    TableNumButton(bindedValue: $tableID, value: "5")
                    TableNumButton(bindedValue: $tableID, value: "6")
                }

                HStack(spacing: 5) {
                    TableNumButton(bindedValue: $tableID, value: "7")
                    TableNumButton(bindedValue: $tableID, value: "8")
                    TableNumButton(bindedValue: $tableID, value: "9")
                }

                HStack(spacing: 5) {
                    TableNumButton(bindedValue: $tableID, value: "TA", setsValue: true)
                    TableNumButton(bindedValue: $tableID, value: "0")
                    TableNumDeleteButton(bindedValue: $tableID)
                }
                
                Button(action: toggle) {
                    Text("Save")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .background(Color.green)
                .cornerRadius(20)
            } else {
                Button(action: toggle) {
                    Text("Table Number: \(tableID)")
                        .padding(10)
                        .foregroundColor(.white)
                }
                .background(Styles.getColor(.darkCyan))
                .cornerRadius(20)
            }
        }
        .padding(10)
    }
    
    func toggle() {
        withAnimation {
            self.editing.toggle()
        }
    }
}

struct TableNumberEntry_Previews: PreviewProvider {
    static var previews: some View {
        TableNumberEntry(editing: .constant(true), tableID: .constant("TA"))
    }
}

// Death to code reuse
// Will fix in v2
struct TableNumButton : View {
    @Binding var bindedValue : String
    let value : String
    var setsValue : Bool = false
    var body: some View {
        Button(action: {
            if self.setsValue {
                self.bindedValue = self.value
            } else {
                self.bindedValue = self.bindedValue + self.value
            }
        }) {
            Text(String(self.value))
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .padding(10)
        }
        .background(Styles.getColor(.darkGreen))
        .cornerRadius(5)
    }
}

struct TableNumDeleteButton : View {
    @Binding var bindedValue : String
    
    var body : some View {
        Button(action: {
            self.bindedValue = String(self.bindedValue.dropLast())
        }) {
            Text("⌫")
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .padding(10)
        }
        .background(Color(red:0.99, green:0.37, blue:0.33))
        .cornerRadius(5)
    }
}
