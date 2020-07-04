//
//  ChangePasscode.swift
//  antique
//
//  Created by Vong Beng on 31/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ChangePasscode: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var oldPasscodeAuth = PasscodeAuthenticator()
    @ObservedObject var passcodeCreator = PasscodeCreator()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(passcodeCreator.newPasscodeSet ? "Passcode Updated!" : "Set Passcode")
                .font(.largeTitle)
            if !oldPasscodeAuth.authenticated {
                PasscodeInput(prompt: "Enter Old Passcode",
                              value: $oldPasscodeAuth.value,
                              passcodeDisplay: $oldPasscodeAuth.passcodeDisplay,
                              displayColor: $oldPasscodeAuth.passcodeDisplayColor)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .animation(.default)
            } else if !passcodeCreator.newPasscodeSet {
                if !passcodeCreator.newValueFilled {
                    PasscodeInput(prompt: "Enter New Passcode",
                                  value: $passcodeCreator.newValue,
                                  passcodeDisplay: $passcodeCreator.newValueDisplay,
                                  displayColor: $passcodeCreator.newValueColor)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        .animation(.default)
                } else {
                    PasscodeInput(prompt: "Confirm Passcode",
                                  value: $passcodeCreator.confirmedValue,
                                  passcodeDisplay: $passcodeCreator.confirmedValueDisplay,
                                  displayColor: $passcodeCreator.confirmedValueColor)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        .animation(.default)
                    Button("Go Back", action: {
                        self.passcodeCreator.newValue = ""
                        self.passcodeCreator.confirmedValue = ""
                    })
                }
            } else {
                Text("Updated Passcode: \(self.passcodeCreator.newValue)")
            }
        }
    }
}

struct ChangePasscode_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasscode()
    }
}
