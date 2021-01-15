//
//  BarView.swift
//  antique
//
//  Created by Vong Beng on 12/9/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct BarView: View {
    var barWidth: CGFloat = 60
    var horizontalSpacing: CGFloat = 15
    @State private var show: Bool = true
    @Binding var barItems: [BarItem]
    
    private var max: CGFloat {
        var max: Double = 0
        for barItem in barItems {
            if abs(barItem.amount) > max {
                max = abs(barItem.amount)
            }
        }
        return CGFloat(abs(max))
    }
    
    
    private var allBarsWidth: CGFloat {
        CGFloat(barItems.count) * (barWidth + horizontalSpacing) - horizontalSpacing // final bar does not have a space
    }
    
    private func delayAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            show = true
        }
    }
    
    let greenGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))])
    let redGradient: Gradient = Gradient(colors: [Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1))])
    
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { bounds in
                let scrollViewPadding = bounds.size.width / 8
                HStack {
                    Spacer() // To center scrollview
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .bottom, spacing: horizontalSpacing) {
                            ForEach(barItems, id:\.self) { barItem in
                                if show {
                                    let barHeight = abs(bounds.size.height * CGFloat(barItem.amount) / max)
                                    VStack(alignment: .center) {
                                        Capsule()
                                            .frame(height: bounds.size.height)
                                            .frame(width: barWidth / 2)
                                            .foregroundColor(Color.gray.opacity(0.1))
                                            .overlay(
                                                Capsule()
                                                    .fill(
                                                        LinearGradient(gradient: barItem.amount > 0 ? greenGradient : redGradient,
                                                                         startPoint: .bottom,
                                                                         endPoint: .top))
                                                    .frame(width: barWidth / 2)
                                                    .frame(height: barHeight),
                                                alignment: .bottom
                                            )
                                        Text(barItem.label)
                                            .lineLimit(2)
                                            .font(.headline)
                                        Text(String(format: "$%.2f%", barItem.amount))
                                            .lineLimit(1)
                                            .foregroundColor(barItem.amount > 0 ? .green : .red)
                                            .font(.footnote)
                                    }
                                    .frame(width: barWidth)
                                    .padding(.vertical, 24)
                                    .transition(AnyTransition.scale.animation(.spring()))
                                    .animation(.spring())
                                }
                            }
                        }
                    }
                    .frame(maxWidth: (allBarsWidth > bounds.size.width - scrollViewPadding * 2) ? .infinity : allBarsWidth) // prevents scrollview from taking up the whole screen
                    
                    Spacer() // To center scrollview
                }
            }
        }
        .padding(.vertical, 30)
        .onAppear(perform: delayAnimation)
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(barItems: .constant([
                                        BarItem(label: "Mon", amount: -300),
                                        BarItem(label: "Tue", amount: 433),
                                        BarItem(label: "Wed", amount: 489),
                                        BarItem(label: "Fri", amount: -400),
                                        BarItem(label: "Sat", amount: 500),
                                        BarItem(label: "Sun", amount: 600),
                                        BarItem(label: "Mon", amount: -900),
                                        BarItem(label: "Tue", amount: 150),
                                        BarItem(label: "Wed", amount: 200),
                                        BarItem(label: "Thu", amount: 300),
                                        BarItem(label: "Fri", amount: 200),
                                        BarItem(label: "Sat", amount: 400),
                                        BarItem(label: "Sun", amount: 348),
                                        BarItem(label: "Mon", amount: 239),
                                        BarItem(label: "Tue", amount: 583),
                                        BarItem(label: "Wed", amount: 439),
                                        BarItem(label: "Thu", amount: 450),
                                        BarItem(label: "Sun", amount: 238)])
        )
        .frame(maxHeight: 200)
    }
}

struct BarItem: Equatable, Identifiable, Hashable {
    var id = UUID()
    var label: String
    var amount: Double
}
