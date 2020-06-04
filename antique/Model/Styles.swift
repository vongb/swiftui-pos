//
//  Styles.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import Foundation
import SwiftUI

struct Styles {
    enum Colors {
        case lightGreen
        case brightCyan
        case darkCyan
        case darkGrey
        case lightRed
    }
    
    static let colors : [Colors : Color] =
        [.lightGreen : Color(red:0.89, green:0.98, blue:0.96),
         .brightCyan : Color(red:0.19, green:0.89, blue:0.79),
         .darkCyan : Color(red:0.07, green:0.60, blue:0.62),
         .darkGrey : Color(red:0.25, green:0.32, blue:0.31),
         .lightRed : Color(red:0.95, green:0.51, blue:0.51)]
    
    static func getColor(_ color: Colors) -> Color {
        return Self.colors[color] ?? Color.black
    }
}
