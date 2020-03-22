//
//  SavedOrderRow.swift
//  antique
//
//  Created by Vong Beng on 12/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct CashOutRow: View {
    @ObservedObject var styles = Styles()
    
    let cashout : CashOut
    
    var body: some View {
        NavigationLink(destination: DetailedCashOut(self.cashout)) {
            HStack(alignment: .center) {
                Text("\(self.cashout.title)")
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                MaroonText(text: "Cash Out", fontSize: 10)
                    .lineLimit(1)
            }
            .padding(10)
        }
    }
}
