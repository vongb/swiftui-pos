//
//  PasscodeCreator.swift
//  antique
//
//  Created by Vong Beng on 31/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import SwiftUI

class PasscodeAuthenticator : ObservableObject {
    @Published var value : String = "" {
        didSet {
            passcodeDisplay = makePasscodeDisplay(value)
            if isFilled(value) {
                authenticate()
                if !authenticated {
                    passcodeDisplayColor = .red
                }
            } else {
                passcodeDisplayColor = .accentColor
            }
        }
    }
    @Published var authenticated : Bool = false
    @Published var passcodeDisplayColor : Color = .accentColor
    @Published var passcodeDisplay : String = "○   ○   ○   ○"
    
    func reset() {
        value = ""
        authenticated = false
    }
    
    private func isFilled(_ string : String) -> Bool {
        return string.count == 4
    }
    
    private func makePasscodeDisplay(_ string : String) -> String {
        var display = ""
        let SPACING = "   "
        for i in 0 ..< string.count {
            display.append("●")
            if i != 3 {
                display.append(SPACING)
            }
        }
        for i in string.count ..< 4 {
            display.append("○")
            if i != 3 {
                display.append(SPACING)
            }
        }
        return display
    }
    
    private func authenticate() {
        authenticated = value == KeychainWrapper.standard.string(forKey: UserDefKeys.adminPasscodeKey) ?? ""
    }
}
