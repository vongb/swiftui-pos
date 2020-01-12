//
//  HorizontalDivider.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct HorizontalDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .frame(height: 1)
    }
}

struct HorizontalDivider_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalDivider()
    }
}
