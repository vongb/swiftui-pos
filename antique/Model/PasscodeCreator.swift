//
//  PasscodeCreator.swift
//  antique
//
//  Created by Vong Beng on 31/5/20.
//  Copyright © 2020 Vong Beng. All rights reserved.


import Foundation
import SwiftUI

class PasscodeCreator : ObservableObject {
    @Published var newValue : String = "" {
        didSet {
            newValueDisplay = makePasscodeDisplay(newValue)
            newValueFilled = isFilled(newValue)
        }
    }
    @Published var confirmedValue : String = "" {
        didSet {
            confirmedValueDisplay = makePasscodeDisplay(confirmedValue)
            confirmedValueFilled = isFilled(confirmedValue)
            if confirmedValueFilled {
                setNewPasscode()
                if !newPasscodeSet {
                    confirmedValueColor = Color.red
                }
            } else {
                confirmedValueColor = Color.accentColor
            }
        }
    }
    
    @Published var newValueColor : Color
    @Published var confirmedValueColor : Color
    
    @Published var newValueDisplay : String
    @Published var confirmedValueDisplay : String
    
    @Published var newValueFilled : Bool
    @Published var confirmedValueFilled : Bool
    
    @Published var newPasscodeSet : Bool
    
    init() {
        newValueColor = .accentColor
        confirmedValueColor = .accentColor
        
        newValueDisplay = "○   ○   ○   ○"
        confirmedValueDisplay = "○   ○   ○   ○"
        
        newValueFilled = false
        confirmedValueFilled = false
        
        newPasscodeSet = false
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
    
    private func setNewPasscode() {
        if newValue == confirmedValue {
            newPasscodeSet = KeychainWrapper.standard.set(newValue, forKey: UserDefKeys.adminPasscodeKey)
        }
    }
    
    private func isFilled(_ string : String) -> Bool {
        return string.count == 4
    }
}
