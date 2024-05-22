//
//  PricingCard.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 16/5/24.
//

import SwiftUI

struct PricingCard: View {
    var name: String
    var color: Color
    var icon: String
    var price: String
    var advantages: [String]
    var width: CGFloat = 250
    var height: CGFloat = 350
    var body: some View {
        ZStack(alignment: .top){
            RoundedRectangle(cornerRadius: 15)
                
//                    .fill(Color.swatch.dark.high)
                .stroke(color, lineWidth: 15)
                .background(Color.swatch.dark.high)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width: width, height: height)
            RoundedRectangle(cornerRadius: 15).fill(color).frame(width: width, height: height/3)
            ZStack{
                Circle().fill(Color.swatch.dark.high)
                Text("$\(price)").foregroundStyle(color).font(.custom("", size: height/13)).fontWeight(.bold)
            }.frame(width: width/2).padding(.top, height/4)
            VStack{
                VStack{
                    Image(systemName: icon).font(.custom("", size: width/7))
                    Text(name)//.font(.title)
                }.padding().frame(height: height/3, alignment: .top)
                VStack{
                    VStack{
                        ForEach(advantages, id: \.self){adv in
                            Text(adv).foregroundStyle(.white).font(.caption)
                        }
                    }.frame(maxHeight: (height/3))
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 8).stroke(color)
//                        Text("purchase.now".trad()).foregroundStyle(.white)
//                    }.frame(maxWidth: width).padding()
                    Button(action: {}){
                        Text("purchase.now".trad())
                        Image(systemName: "chevron.right")
                    }.foregroundStyle(color).padding().overlay(RoundedRectangle(cornerRadius: 8).stroke(color, style: StrokeStyle(lineWidth: 3)))
                }.frame(height: (height/3)*2, alignment: .center)
                
//                Spacer()
            }//.padding(.bottom).frame(height: height, alignment: .top)
        }
    }
}

#Preview {
    PricingCard(name: "Test", color: .yellow, icon: "multiply", price: "1.99", advantages: ["advantage 1", "Advantage 2"])
}
