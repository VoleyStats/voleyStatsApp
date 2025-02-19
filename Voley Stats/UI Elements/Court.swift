import SwiftUI

struct Court: View{
    @Binding var rotation: [Player?]
    var numberPlayers: Int
    var showName: Bool = false
    var editable: Bool = false
    var width: CGFloat = 300
    var height: CGFloat = 350
    var teamPlayers: [Player] = []
    @State var showModal: Bool = false
    @State var rotationIdx: Int = 0
    var rect: some View = Rectangle().fill(.orange)
    
    var body: some View{
        ZStack{
            
            VStack{
                if numberPlayers == 4 {
                    VStack{
                        HStack{
                            rect.overlay(playerData(player: rotation.count > 2 ? rotation[2] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 2
                                        showModal.toggle()
                                    }
                                }
                        }.frame(width: width, height: height/4)
                        HStack{
                            VStack{
                                rect.overlay(playerData(player: rotation.count > 3 ? rotation[3] : nil))
                                    .onTapGesture{
                                        if editable {
                                            rotationIdx = 3
                                            showModal.toggle()
                                        }
                                    }
                            }
                            VStack{
                                rect.overlay(playerData(player: rotation.count > 1 ? rotation[1] : nil))
                                    .onTapGesture{
                                        if editable {
                                            rotationIdx = 1
                                            showModal.toggle()
                                        }
                                    }
                            }
                        }.frame(width: width, height: height/2)
                        HStack{
                            rect.overlay(playerData(player: rotation.count > 0 ? rotation[0] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 0
                                        showModal.toggle()
                                    }
                                }
                        }.frame(width: width, height: height/4)
                    }.frame(width: width, height: height).padding()
                } else if numberPlayers >= 6{
                    VStack{
                        HStack{
                            rect.overlay(playerData(player: rotation.count > 3 ? rotation[3] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 3
                                        showModal.toggle()
                                    }
                                }
                            rect.overlay(playerData(player: rotation.count > 2 ? rotation[2] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 2
                                        showModal.toggle()
                                    }
                                }
                            rect.overlay(playerData(player: rotation.count > 1 ? rotation[1] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 1
                                        showModal.toggle()
                                    }
                                }
                        }
                        HStack{
                            rect.overlay(playerData(player: rotation.count > 4 ? rotation[4] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 4
                                        showModal.toggle()
                                    }
                                }
                            rect.overlay(playerData(player: rotation.count > 5 ? rotation[5] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 5
                                        showModal.toggle()
                                    }
                                }
                            rect.overlay(playerData(player: rotation.count > 0 ? rotation[0] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 0
                                        showModal.toggle()
                                    }
                                }
                        }.frame(height: height*2/3)
                    }.frame(width: width, height: height).padding()
                } else if numberPlayers == 3{
                    VStack{
                        HStack{
                            rect.overlay(playerData(player: rotation.count > 1 ? rotation[1] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 1
                                        showModal.toggle()
                                    }
                                }
                        }.frame(height: height*1/3)
                        HStack{
                            rect.overlay(playerData(player: rotation.count > 2 ? rotation[2] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 2
                                        showModal.toggle()
                                    }
                                }
                            rect.overlay(playerData(player: rotation.count > 0 ? rotation[0] : nil))
                                .onTapGesture{
                                    if editable {
                                        rotationIdx = 0
                                        showModal.toggle()
                                    }
                                }
                        }
                    }.frame(width: width, height: height).padding()
                }
            }
            if !editable{
                Rectangle().fill(.white.opacity(0.01))
            }
        }.clipped()
//            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(showModal ? VStack{
                HStack{
                    Button(action:{
                        showModal.toggle()
                    }){
                        Image(systemName: "multiply")
                    }.padding().font(.title3)
                }.frame(maxWidth: .infinity, alignment: .trailing)
                Text("pick.player".trad()).font(.title3)
                ScrollView(.vertical){
                    let p = teamPlayers.filter{!rotation.contains($0) && $0.position != .libero}.sorted(by: {$0.number < $1.number})
                    VStack{
                        if rotation[rotationIdx] != nil{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8).fill(.orange)
                                HStack{
                                    Text("\(rotation[rotationIdx]!.number) \(rotation[rotationIdx]!.name)").foregroundColor(.white).padding()
                                    Image(systemName: "multiply").foregroundColor(.white).padding().frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                                        rotation[rotationIdx] = nil
                                    }
                                }
                            }
                        }
                        HStack{
                            let pr = p.count % 2 == 0 ? p.count : p.count + 1
                            VStack{
                                ForEach(p.prefix(pr/2), id:\.id){player in
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8).fill(.blue)
                                        Text("\(player.number) \(player.name)").foregroundColor(.white)
                                    }.onTapGesture {
                                        rotation[rotationIdx] = player
                                        showModal.toggle()
                                        
                                    }.frame(height: 40)
                                }
                            }.frame(maxHeight: .infinity, alignment: .top)
                            VStack{
                                ForEach(p.suffix(p.count/2), id:\.id){player in
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8).fill(.blue)
                                        Text("\(player.number) \(player.name)").foregroundColor(.white)
                                    }.onTapGesture {
                                        rotation[rotationIdx] = player
                                        showModal.toggle()
                                        
                                    }.frame(height: 40)
                                }
                            }.frame(maxHeight: .infinity, alignment: .top)
                            
                        }.padding(.vertical).frame(maxWidth: .infinity)
                    }
                }.padding(.horizontal).frame(maxWidth: .infinity)
            }.background(Color.swatch.dark.high) : nil)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: width, maxHeight: height)
    }
    @ViewBuilder
    func playerData(player: Player?) -> some View {
        VStack{
            if player != nil{
                Text("\(player!.number)")
                if showName{
                    Text("\(player!.name)")
                }
            }else{
                Text("")
            }
        }
    }
}

//struct Court_Previews: PreviewProvider {
//    @State var rot:[Player]? = [Player]()
//    static var previews: some View {
//        Court(rotation: $rot)
//    }
//}
