//
//  Switch.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 28/5/24.
//

import SwiftUI

struct Switch: View {
    @Binding var isOn:Bool
    var isOnIcon:Image
    var isOffIcon:Image
    var buttonColor:Color
    var backgroundColor:Color
    var body: some View {
        HStack{
            isOffIcon.padding()
                .background(!isOn ? buttonColor : .clear).clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture {
                    withAnimation(.spring){
                        isOn.toggle()
                    }
                }
            isOnIcon.padding()
                .background(isOn ? buttonColor : .clear).clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture {
                    withAnimation(.spring){
                        isOn.toggle()
                    }
                }
        }.padding(5).background(backgroundColor).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
