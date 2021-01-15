//
//  ReportItemHeader.swift
//  antique
//
//  Created by Vong Beng on 23/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ReportItemHeader: View {
    var body: some View {
        HStack(spacing: 15) {
            Text("#")
                .bold()
            
            Text("Item Name")
                .bold()
            Spacer()
            Text("Qty")
                .bold()
            
            VStack (alignment: .trailing) {
                Text("Total")
                    .bold()
                    .frame(minWidth: 100)
            }
        }
    }
}

struct ReportItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ReportItemHeader()
    }
}
