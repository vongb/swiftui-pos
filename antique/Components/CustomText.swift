//
//  TitleText.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct BlackText: View {
    @State var text : String
    @State var fontSize : CGFloat = 20
    var body: some View {
        Text(text)
            .bold()
            .padding(5)
            .font(.system(size: fontSize))
            .foregroundColor(.white)
            .background(Styles.getColor(.darkGrey))
            .cornerRadius(10)
    }
}

struct DarkBlueText : View {
    @State var text : String
    @State var fontSize : CGFloat = 20
    var body : some View {
        Text(text)
            .bold()
            .padding(5)
            .font(.system(size: fontSize))
            .foregroundColor(.white)
            .background(Styles.getColor(.darkCyan))
            .cornerRadius(10)
    }
}

struct MaroonText : View {
    @State var text : String
    @State var fontSize : CGFloat = 20
    var body : some View {
        Text(text)
            .bold()
            .padding(5)
            .font(.system(size: fontSize))
            .foregroundColor(.white)
            .background(Styles.getColor(.lightRed))
            .cornerRadius(10)
    }
}

struct RedText : View {
    @State var text : String
    @State var fontSize : CGFloat = 20
    var body : some View {
        Text(text)
            .bold()
            .padding(5)
            .font(.system(size: fontSize))
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(10)
    }
}

struct GreenText : View {
    @State var text : String
    @State var fontSize : CGFloat = 20
    var body : some View {
        Text(text)
            .bold()
            .padding(5)
            .font(.system(size: fontSize))
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
    }
}


struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        BlackText(text: "Text")
    }
}
