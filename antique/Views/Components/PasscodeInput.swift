//
//  PasscodeInput.swift
//  antique
//
//  Created by Vong Beng on 31/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

let SIZE : CGFloat = 60

struct PasscodeInput: View {
    let prompt : String
    @Binding var value : String
    @Binding var passcodeDisplay : String
    @Binding var displayColor : Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(prompt)
                .font(.title)
            Text(passcodeDisplay)
                .font(.headline)
                .foregroundColor(displayColor)
//                .offset(x: isFilled ? -5 : 0)
//                .animation(
//                    Animation
//                        .easeInOut(duration: 0.8)
//                        .repeatCount(5, autoreverses: true)
//                        .speed(10)
//                )
            HStack(spacing: 20) {
                PasscodeNumButton(value: 1, passcode: self.$value)
                PasscodeNumButton(value: 2, passcode: self.$value)
                PasscodeNumButton(value: 3, passcode: self.$value)
            }
            HStack(spacing: 20) {
                PasscodeNumButton(value: 4, passcode: self.$value)
                PasscodeNumButton(value: 5, passcode: self.$value)
                PasscodeNumButton(value: 6, passcode: self.$value)
            }
            HStack(spacing: 20) {
                PasscodeNumButton(value: 7, passcode: self.$value)
                PasscodeNumButton(value: 8, passcode: self.$value)
                PasscodeNumButton(value: 9, passcode: self.$value)
            }
            HStack(spacing: 20) {
                Spacer()
                    .frame(width: SIZE)
                PasscodeNumButton(value: 0, passcode: self.$value)
                PasscodeDeleteButton(passcode: self.$value)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .frame(minWidth: 300, maxWidth: 400)
    }
}

struct PasscodeNumButton : View {
    let value : Int
    @Binding var passcode : String
    
    var body : some View {
        Button(action: self.appendPasscode) {
            Text(String(self.value))
                .frame(minWidth: SIZE, minHeight: SIZE)
                .overlay (
                    Circle()
                        .stroke(Color.accentColor, lineWidth: 1)
                )
        }
    }
    
    func appendPasscode() {
        if passcode.count < 4 {
            passcode.append(String(value))
        } else {
            passcode = ""
            passcode.append(String(value))
        }
    }
}

struct PasscodeDeleteButton : View {
    @Binding var passcode : String

    var body : some View {
        Button(action: self.delete) {
            Text(passcode.count == 4 ? "Clear" : "Delete")
                .frame(minWidth: SIZE, minHeight: SIZE)
        }
    }
    
    func delete() {
        if passcode.count >= 4 {
            passcode = ""
        } else if !passcode.isEmpty {
            passcode.removeLast()
        }
    }
}
