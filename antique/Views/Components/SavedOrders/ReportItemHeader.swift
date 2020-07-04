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
        HStack {
            Text("#")
                .bold()
            Spacer().frame(width: 30)
            Text("Item Name")
                .bold()
            Spacer()
            Text("Qty")
                .bold()
            Spacer().frame(width: 50)
            Text("Total")
                .bold()
        }
    }
}

struct ReportItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ReportItemHeader()
    }
}
