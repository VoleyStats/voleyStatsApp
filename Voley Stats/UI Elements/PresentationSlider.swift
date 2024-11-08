//
//  PresentationSlider.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 2/11/24.
//

import SwiftUI

struct PresentationSlider: View {
    let slides: [Slide]
    let cta_text:String
    let cta_action: ()->()
    let skip_action: ()->()
    @State var current: Int = 0
    var body: some View {
        GeometryReader{geo in
            VStack{
                
                HStack(spacing:0){
                    ForEach(0..<slides.count){i in
                        let offset = -CGFloat(current) * geo.size.width
                        //                    if current == i{
                        
                        VStack{
                            HStack{
                                if current != 0{
                                    Text("back".trad()).onTapGesture {
                                        withAnimation{
                                            current -= 1
                                        }
                                    }
                                }
                                Spacer(minLength: 0)
                                Text("skip".trad()).onTapGesture {
                                    withAnimation{
                                        skip_action()
                                    }
                                }
                                
                            }.padding(.horizontal)
//                            Spacer()
                            VStack{
                                slides[i].image
                                    .resizable().scaledToFit().padding()
                                    .offset(x: offset).animation(.easeInOut, value: current)
                                Text(slides[i].title)
                                    .font(.title).offset(x: offset).animation(.easeInOut, value: current)
                                Text(slides[i].subtitle).offset(x: offset).animation(.easeInOut, value: current)
                            }.padding()
                            Spacer()
                            HStack{
                                ForEach(0..<slides.count){ i in
                                    Circle().frame(width: 5, height: 5).foregroundColor(current == i ? .white : .white.opacity(0.2))
                                }
                            }.padding(10).background(.white.opacity(0.1)).clipShape(Capsule()).frame(maxHeight: 25).padding()
//                            Spacer()
                            if current < slides.count - 1{
                                Text("next").padding().frame(width: geo.size.width/2).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    withAnimation{
                                        current += 1
                                    }
                                }.padding()
                            }else{
                                Text(cta_text).padding().frame(width: geo.size.width/2)
                                    .background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture {
                                        withAnimation{
                                            cta_action()
                                        }
                                }.padding()
                            }
                            
                        }.padding().frame(width: geo.size.width, height: geo.size.height)
                        //                    }
                    }
                }.frame(width: geo.size.width * CGFloat(slides.count), alignment: .leading)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.swatch.dark.high).foregroundStyle(.white)
        }
//        .border(Color.swatch.dark.mid, width: 1)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct Slide{
    var title: String
    var subtitle: String
    var image: Image
}

#Preview {
    PresentationSlider(slides:[
        Slide(title: "this is a test slide", subtitle: "in this subtitle we will test the slider", image: Image("slide_export")),
        Slide(title: "this is the test slide 2", subtitle: "in this subtitle we will test another slider", image: Image("slide_stats")),
        Slide(title: "this is the test slide 2", subtitle: "in this subtitle we will test another slider", image: Image("slide_fill")),
        Slide(title: "this is the test slide 2", subtitle: "in this subtitle we will test another slider", image: Image("slide_backup"))
    ], cta_text: "start capturing stats", cta_action: {}, skip_action: {})
}
