//
//  TitleText.swift
//  antique
//
//  Created by Vong Beng on 13/1/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct BlackText: View {
    @ObservedObject var styles = Styles()
    @State var text : String
    @State var fontSize : CGFloat = 20
    var body: some View {
        Text(text)
            .bold()
            .padding(5)
            .font(.system(size: fontSize))
            .foregroundColor(.white)
            .background(styles.colors[3])
            .cornerRadius(10)
    }
}

struct DarkBlueText : View {
    @ObservedObject var styles = Styles()
    @State var text : String
    @State var fontSize : CGFloat = 20
    var body : some View {
        Text(text)
            .bold()
            .padding(5)
            .font(.system(size: fontSize))
            .foregroundColor(.white)
            .background(styles.colors[2])
            .cornerRadius(10)
    }
}

struct MaroonText : View {
    @ObservedObject var styles = Styles()
    @State var text : String
    @State var fontSize : CGFloat = 20
    var body : some View {
        Text(text)
            .bold()
            .padding(5)
            .font(.system(size: fontSize))
            .foregroundColor(.white)
            .background(styles.colors[4])
            .cornerRadius(10)
    }
}

struct RedText : View {
    @ObservedObject var styles = Styles()
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
    @ObservedObject var styles = Styles()
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
