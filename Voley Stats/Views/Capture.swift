import SwiftUI

struct Capture: View {
    @ObservedObject var viewModel: CaptureModel
    var sq: CGFloat = 90
    let actions: [[Action]] = Action.all().map{$0.filter{$0.type != 4}}
    let statb = RoundedRectangle(cornerRadius: 15, style: .continuous)
    @State var showChange = false
    @State var rotArray:[Int] = [0,0,0,0,0,0]
    @State var rot:[Player]=[]
    var body: some View {
        VStack {
            HStack {
                ZStack{
                    statb.fill(.blue)
                    Text("\(viewModel.point_us)").font(Font.body)
                }.overlay(Image("Voleibol").scaleEffect(0.01, anchor: .center).opacity(viewModel.serve==1 ? 1 : 0).padding().offset(x: 23.0, y: -23.0))
                    .overlay{
                        HStack{
                            ForEach(0..<viewModel.timeOuts.0, id:\.self){t in
                                Image(systemName: "t.circle.fill")
                            }
                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                    }
                    .onTapGesture{
                        viewModel.adjust.toggle()
                    }
                ZStack{
                    statb.fill(.pink)
                    Text("\(viewModel.point_them)").font(Font.body)
                }.clipped().overlay(Image("Voleibol").scaleEffect(0.01, anchor: .center).opacity(viewModel.serve==2 ? 1 : 0).padding().offset(x: 20.0, y: -20.0))
                    .overlay{
                        HStack{
                            ForEach(0..<viewModel.timeOuts.1, id:\.self){t in
                                Image(systemName: "t.circle.fill")
                            }
                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                    }
                    .onTapGesture{
                        viewModel.adjust.toggle()
                    }
                ZStack{
                    statb.fill(.gray)
                    Text("time.out".trad())
                }.clipped().onTapGesture {
                    viewModel.showTimeout.toggle()
                }
                ZStack{
                    statb.fill(.blue)
                    Text("change.player".trad()).foregroundColor(.white)
                    
                }.clipped().onTapGesture {
                    if viewModel.player?.position == .libero{
                        viewModel.liberoIdx.toggle()
                        viewModel.players()
                    }else{
                        if viewModel.canChange(){
                            showChange.toggle()
                        } else {
                            viewModel.cantChange.toggle()
                        }
                    }
                }.alert(isPresented: $viewModel.cantChange){
                    Alert(title: Text("cant.change".trad()), message: Text("select.player".trad()))
                
                }
                ZStack{
                    statb.fill(.pink)
                    Text("their.player".trad()).foregroundColor(.white)
                    
                }.clipped().onTapGesture {
                    viewModel.player = Player(name: "their.player".trad(), number: 0, team: 0,active:1, birthday: Date(), id: 0)
                }
                ZStack{
                    statb.fill(.white.opacity(0.2))
                    //VStack {
//                        Text("rotation".trad()).font(.body)
//                        rot =
//                        let players: [Player] = viewModel.team.players()
                        Court(rotation: $viewModel.rotationArray, numberPlayers: viewModel.match.n_players, width: 90, height: 70)
                            .onTapGesture {
                                rotArray = viewModel.rotation.get(rotate: viewModel.rotationTurns).map{$0?.id ?? 0}
                                viewModel.showRotation = true
                            }

                    //}.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                    Rectangle().fill(.clear)
                }.clipped()
            }.frame(maxHeight: sq).padding(.horizontal)
            HStack {
                ZStack{
                    statb.fill(.gray)
                    HStack{
                        ZStack{
                            statb.fill(viewModel.player?.id == nil ? .black.opacity(0.4) : viewModel.player?.id == 0 ? .pink : .blue)
                            HStack{
                                if (viewModel.player != nil && viewModel.player?.id != 0){
                                    Text("\(viewModel.player?.number ?? 0)")
                                }
                                Text(" \(viewModel.player?.name ?? "player".trad())")
                            }
                            
                        }
                        ZStack{
                            statb.fill(viewModel.action?.color() ?? .black.opacity(0.4))
                            Text("\(viewModel.action?.name.trad().capitalized ?? "action".trad())")
                        }
                        ZStack{
                            statb.fill(viewModel.pointTo()?.1 == 1 ? .blue : viewModel.pointTo()?.1 == 2 ? .pink : .black.opacity(0.4))
                            Text("\(viewModel.pointTo()?.0.trad() ?? "to".trad())")
                        }
                    }.frame(maxHeight: sq/2).padding()
                }
                
                HStack {
                    ZStack{
                        statb.fill(.pink)
                        Text("clear".trad()).foregroundColor(.white)
                        
                    }.onTapGesture {
                        viewModel.clear()
                    }
                    ZStack{
                        statb.fill(.pink)
                        Text("undo".trad()).foregroundColor(.white)
                        
                    }.onTapGesture {
                        viewModel.undo()
                    }
                    ZStack{
                        statb.fill(.blue)
                        
                        Text("enter".trad()).foregroundColor(.white)
                    }.onTapGesture {
                        viewModel.saveAction()
                    }
                }.frame(maxWidth: sq*4)
            }.frame(maxHeight: sq).padding(.horizontal)
            
            HStack (alignment: .top) {
                VStack {
                    Text("current.lineup".trad()).font(.title3)
//                    Divider().overlay(.white).padding(.bottom)
                    ForEach(viewModel.lineupPlayers.sorted(by: { $0.number < $1.number }), id:\.id){player in
                        ZStack{
                            statb.stroke(viewModel.player?.id == player.id ? .white : .clear, lineWidth: 3).background(statb.fill(.blue))
                            VStack {
                                Text("\(player.number)")
                                Text("\(player.name)")
                                if viewModel.setter.id == player.id{
                                    Text("setter").font(.caption)
                                }
                            }.foregroundColor(.white).font(Font.body)
                        }
                        .highPriorityGesture(TapGesture().onEnded{ _ in
                            viewModel.player = player
                        })
//                        .onTapGesture {
//                            viewModel.player = player
//                        }
                        .gesture(DragGesture()
                            .onEnded{v in
                                switch(v.translation.width, v.translation.height) {
                                        
                                    case (-200...200, ...0):
                                        viewModel.player = player
                                        viewModel.action = Action.find(id: 6)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            viewModel.saveAction()
                                        }
//                                    case (-200...200, 0...):
//                                        print("down")
                                    default: print("default")
                                }
                            })
                        .onTapGesture(count: 2){
                            viewModel.player = player
                            viewModel.action = Action.find(id: 5)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.saveAction()
                            }
                        }
                        .gesture(DragGesture()
                            .onEnded{v in
                                switch(v.translation.width, v.translation.height) {
                                        
                                    case (-200...200, ...0):
                                        viewModel.player = player
                                        viewModel.action = Action.find(id: 6)
                                        viewModel.saveAction()
//                                    case (-200...200, 0...):
//                                        print("down")
                                    default: print("default")
                                }
                            })
                        .onTapGesture(count: 2){
                            viewModel.player = player
                            viewModel.action = Action.find(id: 5)
                            viewModel.saveAction()
                        }
                        .overlay(Image("Voleibol").scaleEffect(0.01, anchor: .center).opacity(player == viewModel.server ? 1 : 0).padding().offset(x: 40.0, y: -20.0))
                    }
                }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2))).padding(.trailing, 5).frame(maxWidth: sq*2)
                if viewModel.stage != .K3 && viewModel.set.directionDetail{
                    HStack{
                        if viewModel.stage == .K2{
                            VStack{
                                Text("actions".trad()).font(.title3)
                                ForEach(Action.getByArea(area: .serve), id:\.id){action in
                                    ZStack{
                                        statb.stroke(viewModel.action?.id == action.id ? .white : .clear, lineWidth: 3).background(statb.fill(action.color()))
                                        Text("\(action.name.trad().capitalized)").foregroundColor(.white).padding(5)
                                    }.frame(maxWidth: sq).onTapGesture {
                                        viewModel.action = action
                                    }
                                }
                            }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)))//.frame(maxWidth: sq)//.padding([.horizontal, .bottom])
                        }
                        if viewModel.stage == .K1{
                            VStack{
                                Text("actions".trad()).font(.title3)
                                ForEach(Action.getByArea(area: .receive), id:\.id){action in
                                    ZStack{
                                        statb.stroke(viewModel.action?.id == action.id ? .white : .clear, lineWidth: 3).background(statb.fill(action.color()))
                                        Text("\(action.name.trad().capitalized)").foregroundColor(.white).padding(5)
                                    }.frame(maxWidth: sq).onTapGesture {
            //                            viewModel.player = viewModel.server
                                        viewModel.action = action
                                    }
                                }
                            }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)))//.padding([.horizontal, .bottom])
                        }
                        DirectionsCourt(viewModel: DirectionsCourtModel(direction: $viewModel.direction, isServe: viewModel.stage != .K3, numberPlayers: viewModel.match.n_players))
                    }
                }else{
                    VStack {
                        Text("actions".trad()).font(.title3)
                        //                    Divider().overlay(.white).padding(.bottom)
                        HStack {
                            ForEach(actions, id:\.self){sub in
                                VStack{
                                    ForEach(sub, id:\.id){action in
                                        //                                    if !((action.area == .serve || action.area == .receive) && viewModel.directionDetail){
                                        if !((action.area == .serve || action.area == .receive) && viewModel.set.directionDetail){
                                            if (action.type == 0 && (action.stages.contains(viewModel.stage))) || action.type != 0{
                                                ZStack{
                                                    statb.stroke(viewModel.action?.id == action.id ? .white : .clear, lineWidth: 3).background(statb.fill(action.color()))
                                                    Text("\(action.name.trad().capitalized)").foregroundColor(.white).padding(5)
                                                }.onTapGesture {
                                                    viewModel.actionTap(action: action)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)))
                }
            }.padding()
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Image(systemName: "gear").font(.title3).onTapGesture{
                    viewModel.showSetPreferences.toggle()
                }
            }
        }
        .navigationTitle("capture".trad())
        .background(Color.swatch.dark.high).foregroundColor(.white)
//        .navigationBarBackButtonHidden(true)
        .toast(show: $viewModel.showToast, Toast(show: $viewModel.showToast, type: viewModel.type, message: viewModel.message))
        .frame(maxHeight: .infinity)
        .overlay(showChange ? VStack{
            HStack{
                Button(action:{
                    showChange.toggle()
                    viewModel.clear()
                }){
                    Image(systemName: "multiply")
                }.padding().font(.title2)
            }.frame(maxWidth: .infinity, alignment: .trailing)
            Text("pick.change".trad()).font(.title)
            ScrollView(.vertical){
                let p = viewModel.getChangeOptions()
                if (p.count == 1){
                    ZStack{
                        statb.fill(.blue)
                        Text("\(p.first!.name)").foregroundColor(.white)
                    }.onTapGesture {
                        showChange = false
//                                    print("before func:", viewModel.rotation.description, ", ", viewModel.rotation.id)
                        viewModel.changePlayer(change: p.first!)
                        
                    }.frame(height: sq*2)
                }else{
                    let matching = p.filter({$0.position == viewModel.player!.position})
                    let others = p.filter({$0.position != viewModel.player!.position})
                    VStack{
                        VStack{
                            Text("same.position".trad().uppercased()).frame(maxWidth: .infinity, alignment: .leading).padding()
                            LazyVGrid(columns: [GridItem](repeating: GridItem(), count: 3)){
                                ForEach(matching, id: \.id){player in
                                    ZStack{
                                        statb.fill(.blue)
                                        Text("\(player.name)").foregroundColor(.white)
                                    }.onTapGesture {
                                        showChange = false
                                        //                                    print("before func:", viewModel.rotation.description, ", ", viewModel.rotation.id)
                                        viewModel.changePlayer(change: player)
                                        
                                    }.frame(height: sq*2)
                                }
                            }
                        }.padding(.vertical)
                        VStack{
                            Text("others".trad().uppercased()).frame(maxWidth: .infinity, alignment: .leading).padding()
                            LazyVGrid(columns: [GridItem](repeating: GridItem(), count: 3)){
                                ForEach(others, id: \.id){player in
                                    ZStack{
                                        statb.fill(.blue)
                                        Text("\(player.name)").foregroundColor(.white)
                                    }.onTapGesture {
                                        showChange = false
                                        //                                    print("before func:", viewModel.rotation.description, ", ", viewModel.rotation.id)
                                        viewModel.changePlayer(change: player)
                                        
                                    }.frame(height: sq*2)
                                }
                            }
                        }.padding(.vertical)
                    }
                }
//                HStack{
//                    let pr = p.count % 2 == 0 ? p.count : p.count + 1
//                    VStack{
//                        ForEach(p.prefix(pr/2), id:\.id){player in
//                            ZStack{
//                                statb.fill(.blue)
//                                Text("\(player.name)").foregroundColor(.white)
//                            }.onTapGesture {
//                                showChange = false
////                                showChange.toggle()
//                                print(viewModel.player?.name ?? "nil on change")
//                                viewModel.changePlayer(change: player)
//                                
//                            }.frame(height: sq*2)
//                        }
//                    }.frame(maxHeight: .infinity, alignment: .top)
//                    VStack{
//                        ForEach(p.suffix(p.count/2), id:\.id){player in
//                            
//                            ZStack{
//                                statb.fill(.blue)
//                                Text("\(player.name)").foregroundColor(.white)
//                            }.onTapGesture {
//                                showChange = false
//                                viewModel.changePlayer(change: player)
//
//                            }.frame(height: sq*2)
//                        }
//                    }.frame(maxHeight: .infinity, alignment: .top)
//                    
//                }.padding(.vertical).frame(maxWidth: .infinity)
            }.padding().frame(maxWidth: .infinity)
        }.padding().background(.black).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxHeight: .infinity, alignment: .center).padding() : nil )
        .overlay(viewModel.showRotation ? rotationModal() : nil)
        .overlay(viewModel.hasActionDetail() ? detailModal() : nil)
        .overlay(viewModel.hasDirectionDetail() ? directionModal() : nil)
        .overlay(viewModel.adjust ? adjustmentModal() : nil)
        .overlay(viewModel.showTimeout ? timeOutModal() : nil)
        .overlay(viewModel.showSummary ? summaryModal() : nil)
        .overlay(viewModel.showSetPreferences ? setPreferences() : nil)
        .font(.custom("stats", size: 12))
        .onDisappear(perform: {
            viewModel.updateSet()
        })
        .onAppear(perform: {
            viewModel.players()
        })
        
        
    }
    
    @ViewBuilder
    func rotationModal()->some View{
        VStack{
            ZStack{
                Text("modify.rotation".trad()).font(.title2).frame(maxWidth: .infinity, alignment: .center)
                Button(action:{
                    viewModel.rotation = viewModel.lastStat?.rotation ?? viewModel.set.rotation
                    viewModel.showRotation.toggle()
                    
                }){
                    Image(systemName: "multiply").font(.title2)
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.padding([.top, .trailing])
            VStack{
                VStack{
//                        VStack{
                    Text("game.mode".trad().uppercased()).font(.caption).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
//                        }
                    VStack{
                        Text("game.mode".trad()).frame(maxWidth: .infinity, alignment: .leading).font(.caption)
                        Picker(selection: $viewModel.gameMode, label: Text("game.mode".trad())) {
                            //                        Text("Pick one").tag(0)
                            Text("6-6").tag("6-6")
                            Text("4-2").tag("4-2")
                            Text("6-2").tag("6-2")
                            Text("5-1").tag("5-1")
                        }.pickerStyle(.segmented)
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)
                }.padding(.top)
//                    VStack{
                Text("rotation".trad().uppercased()).font(.caption).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.top, .horizontal])
//                    }.padding(.top)
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white.opacity(0.1))
                VStack{
                    Court(rotation: $viewModel.rotationArray, numberPlayers: viewModel.match.n_players, editable: true, teamPlayers: viewModel.team.activePlayers())
                    HStack{
                        Image(systemName: "backward.fill").padding().frame(maxWidth: .infinity, maxHeight: 50).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                viewModel.rotate(inverse: true)
                                rotArray = viewModel.rotation.get(rotate: viewModel.rotationTurns).map{$0?.id ?? 0}
//                                        if (viewModel.rotation.contains{$0 != nil}){
//                                            viewModel.rotate(inverse: true)
//                                        }
                            }
                        Image(systemName: "forward.fill").padding().frame(maxWidth: .infinity, maxHeight: 50).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                viewModel.rotate()
                                rotArray = viewModel.rotation.get(rotate: viewModel.rotationTurns).map{$0?.id ?? 0}
//                                        if (viewModel.rotation.contains{$0 != nil}){
//                                            viewModel.rotate(inverse: false)
//                                        }
                            }
                    }.frame(width: 300, height: 50)
                    if !viewModel.checkSetters(){
                        Text("not.enough.setters".trad()).foregroundStyle(.red).padding()
                    }
//                            Button(action:{
//                                viewModel.rotate()
//                                rotArray = viewModel.rotation.get(rotate: viewModel.rotationTurns).map{$0?.id ?? 0}
//                            }){
//                                HStack{
//                                    Text("rotate".trad()).font(.body).foregroundColor(.white)
//                                    Image(systemName: "arrow.triangle.2.circlepath")
//                                }.padding()
//                            }.border(.white, width: 3).padding()
                }.padding().frame(maxWidth: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)
//                    }.padding(.horizontal)
                
            }
//                Spacer()
            Text("save".trad()).foregroundColor(viewModel.checkSetters() ? .cyan : .gray).font(.body)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.white.opacity(0.1))
            .clipShape(statb)
            .padding()
            .onTapGesture {
                let rot = Rotation.create(rotation: Rotation(team: viewModel.team, rotationArray: viewModel.rotationArray))
                if rot != nil {
                    if rot!.1.id != viewModel.rotation.id{
                        viewModel.rotation = rot!.1
                        viewModel.rotationTurns = rot!.0
                        
                    }
                    if viewModel.server.id != 0{
                        viewModel.server = viewModel.rotation.server(rotate: viewModel.rotationTurns)
                    }
                }
                if viewModel.liberos != viewModel.set.liberos{
                    viewModel.set.liberos = viewModel.liberos
                    viewModel.set.update()
                }
                viewModel.saveAdjust()
                
            }.disabled(!viewModel.checkSetters())
//                Spacer()
        }.padding().background(Color.swatch.dark.high).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxHeight: .infinity, alignment: .center).padding()
    }
    
    @ViewBuilder
    func setPreferences()->some View {
        VStack{
            ZStack{
                Image(systemName: "multiply").frame(maxWidth: .infinity, alignment: .trailing).padding().onTapGesture {
                    viewModel.showSetPreferences.toggle()
                }
                Text("set.preferences".trad()).frame(maxWidth: .infinity, alignment: .center).padding(.bottom)
            }.font(.title3)
            SetData(viewModel: SetDataModel(team: viewModel.team, match: viewModel.match, set: viewModel.set, isPlaying: true, closeModal: $viewModel.showSetPreferences))//.frame(maxWidth: .infinity)
        }.font(.body).foregroundStyle(.white).padding().background(.black).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxWidth: .infinity).padding()
    }
    
    @ViewBuilder
    func detailModal() -> some View {
            VStack{
                HStack{
                    Button(action:{viewModel.clear()}){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                Text("detail.title".trad()).font(.title2).padding([.bottom, .horizontal])
                HStack{
                    ZStack{
                        statb.fill(.blue)
                        Text("net".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.detail = "Net"
                        viewModel.saveAction()
                    }
                    ZStack{
                        statb.fill(viewModel.action?.id==15 ? .gray : .blue)
                        Text("blocked".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.detail = "Blocked"
                        viewModel.saveAction()
                    }.disabled(viewModel.action?.id==15)
                    ZStack{
                        statb.fill(.blue)
                        Text("out".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.detail = "Out"
                        viewModel.saveAction()
                    }
                }.padding()
                ZStack{
                    statb.fill(.pink)
                    Text("not.specify".trad()).foregroundColor(.white).padding(5)
                }.clipped().onTapGesture {
                    viewModel.saveAction()
                }.padding()
            }
            .background(.black.opacity(0.9))
            .frame(width:500, height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    @ViewBuilder
    func adjustmentModal() -> some View {
            VStack{
                HStack{
                    Button(action:{
                        viewModel.point_us = viewModel.lastStat?.score_us ?? 0
                        viewModel.point_them = viewModel.lastStat?.score_them ?? 0
                        viewModel.server = viewModel.lastStat?.server ?? Player()
                        viewModel.serve = viewModel.lastStat?.stage ?? 0 == 0 ? 1 : 2
                        viewModel.adjust.toggle()
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                Text("adjust.score".trad()).font(.title2).padding([.bottom, .horizontal])
                HStack{
                    VStack{
                        Text("us".trad()).font(.title3)
                        HStack{
                            ZStack{
                                statb.fill(.blue)
                                Text("+").foregroundColor(.white).padding(5)
                            }.clipped().onTapGesture {
                                viewModel.point_us += 1
                            }
                            ZStack{
                                statb.fill(.blue)
                                Text("-").foregroundColor(.white).padding(5)
                            }.clipped().onTapGesture {
                                viewModel.point_us -= 1
                            }
                        }
                        ZStack{
                            statb.fill(.blue)
                            Text("serve".trad()).foregroundColor(.white).padding(5)
                        }.clipped().onTapGesture {
                            viewModel.serve = 1
                            viewModel.server = viewModel.rotation.server(rotate: viewModel.rotationTurns)
                            viewModel.stage = .K2
                        }
                    }
                    VStack{
                        Text("them".trad()).font(.title3)
                        HStack{
                            ZStack{
                                statb.fill(.pink)
                                Text("+").foregroundColor(.white).padding(5)
                            }.clipped().onTapGesture {
                                viewModel.point_them += 1
                            }
                            ZStack{
                                statb.fill(.pink)
                                Text("-").foregroundColor(.white).padding(5)
                            }.clipped().onTapGesture {
                                viewModel.point_them -= 1
                            }
                        }
                        ZStack{
                            statb.fill(.pink)
                            Text("serve".trad()).foregroundColor(.white).padding(5)
                        }.clipped().onTapGesture {
                            viewModel.serve = 2
                            viewModel.server = Player()
                            viewModel.stage = .K1
                        }
                    }
                }.padding().frame(maxHeight: .infinity)
                ZStack{
                    statb.fill(.blue)
                    Text("save".trad()).foregroundColor(.white).padding(5)
                }.clipped().onTapGesture {
                    viewModel.saveAdjust()
                }.padding().frame(maxHeight: 100)
            }
            .background(.black.opacity(0.9))
            .frame(width:500, height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    @ViewBuilder
    func timeOutModal() -> some View {
            VStack{
                HStack{
                    Button(action:{
                        viewModel.showTimeout.toggle()
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                Text("anotate.time.out".trad()).font(.title2).padding([.bottom, .horizontal])
                HStack{
                    ZStack{
                        statb.fill(viewModel.timeOuts.0 == 2 ? .gray : .blue)
                        Text("time.out".trad()+" "+"us".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.timeOut(to: 1)
//                        viewModel.timeOuts.0 += 1
                        viewModel.showTimeout.toggle()
                    }.padding().disabled(viewModel.timeOuts.0 == 2)
                    ZStack{
                        statb.fill(viewModel.timeOuts.1 == 2 ? .gray : .pink)
                        Text("time.out".trad()+" "+"them".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.timeOut(to: 2)
//                        viewModel.timeOuts.1 += 1
                        viewModel.showTimeout.toggle()
                    }.padding().disabled(viewModel.timeOuts.1 == 2)
                }
                
            }
            .background(.black.opacity(0.9))
            .frame(width:500, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    @ViewBuilder
    func summaryModal() -> some View {
        VStack{
            HStack{
                Button(action:{viewModel.showSummary.toggle()}){
                    Image(systemName: "multiply").font(.title2)
                }
            }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
            Text("time.out".trad()).font(.title2).padding([.bottom, .horizontal])
            SummaryTable(data: viewModel.set.summary())
        }
        
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        
    }
    
    @ViewBuilder
    func directionModal() -> some View {
        VStack{
            HStack{
                Button(action:{viewModel.clear()}){
                    Image(systemName: "multiply").font(.title2)
                }
            }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
            Text("directions.detail".trad()).font(.title2).padding([.bottom, .horizontal])
            DirectionsCourt(viewModel: DirectionsCourtModel(direction: $viewModel.direction, isServe: viewModel.stage != .K3, numberPlayers: viewModel.match.n_players))
//            if viewModel.action?.area == .attack && viewModel.set.errorDetail{
//                HStack{
//                    ZStack{
//                        statb.fill(.blue)
//                        Text("net".trad()).foregroundColor(.white).padding(5)
//                    }.clipped().onTapGesture {
//                        viewModel.detail = "Net"
//                        viewModel.saveAction()
//                    }
//                    ZStack{
//                        statb.fill(viewModel.action?.id==15 ? .gray : .blue)
//                        Text("blocked".trad()).foregroundColor(.white).padding(5)
//                    }.clipped().onTapGesture {
//                        viewModel.detail = "Blocked"
//                        viewModel.saveAction()
//                    }.disabled(viewModel.action?.id==15)
//                    ZStack{
//                        statb.fill(.blue)
//                        Text("out".trad()).foregroundColor(.white).padding(5)
//                    }.clipped().onTapGesture {
//                        viewModel.detail = "Out"
//                        viewModel.saveAction()
//                    }
//                }.padding()
//                ZStack{
//                    statb.fill(.pink)
//                    Text("not.specify".trad()).foregroundColor(.white).padding(5)
//                }.clipped().onTapGesture {
//                    viewModel.saveAction()
//                }.padding()
//            } else{
                ZStack{
                    statb.fill(.blue)
                    Text("save".trad()).foregroundColor(.white).padding(5)
                }.onTapGesture {
                    viewModel.saveAction()
                }.frame(maxHeight: sq).padding([.horizontal, .bottom])
//            }
        }
        
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        
    }
}

class CaptureModel: ObservableObject{
    @Published var point_us: Int = 0
    @Published var point_them: Int = 0
    @Published var action: Action? = nil
    @Published var player: Player? = nil
    @Published var rotation: Rotation
    @Published var rotationTurns: Int = 0
    @Published var serve: Int
    @Published var server: Player = Player()
    @Published var detail: String = ""
    @Published var timeOuts: (Int, Int) = (0,0)
    @Published var showRotation: Bool = false
    @Published var lineupPlayers: [Player] = []
    @Published var cantChange: Bool = false
    @Published var adjust: Bool = false
    @Published var showTimeout: Bool = false
    @Published var rotationCount: Int
    @Published var stage: Stages = .K2
    @Published var rotationArray:[Player?]=[nil, nil, nil, nil, nil, nil]
    @Published var setter: Player = Player()
    @Published var gameMode: String = "6-6"
    @Published var message: String = ""
    @Published var type: ToastType = .info
    @Published var showToast: Bool = false
    @Published var showSummary:Bool = false
    @Published var liberoIdx: Bool = false
    @Published var showSetPreferences: Bool = false
    @Published var indexLibero: Int = 0
    @Published var liberos: [Int] = [0,0]
    var direction: String = ""
    var order: Double = 0
    var lastStat: Stat?
    let team: Team
    let match: Match
    var set: Set
    init(team: Team, match: Match, set: Set){
        self.match = match
        self.team = team
        self.set = set
        liberos = set.liberos.map{$0 == nil ? 0 : $0!}
        let stats = set.stats().filter{s in return ![0, 98, 99].contains(s.action)}
        self.gameMode = set.gameMode
        
        if (stats.isEmpty){
            rotation = set.rotation
            serve = set.first_serve
            stage = set.first_serve == 1 ? .K2 : .K1
            server = set.first_serve == 1 ? set.rotation.get(rotate: set.rotationTurns)[0]! : Player()
            rotationCount = set.rotationNumber
            rotationTurns = set.rotationTurns
            setter = set.rotation.getSetter(gameMode: set.gameMode, rotationTurns: set.rotationTurns)
        }else{
            lastStat = stats.last
            rotation = lastStat!.rotation
            point_us = lastStat?.score_us ?? 0
            point_them = lastStat?.score_them ?? 0
            rotationCount = lastStat!.rotationCount
            rotationTurns = lastStat!.rotationTurns
            if lastStat?.to != 0{
                if lastStat?.stage == 0 {
                    if lastStat?.to == 2 {
                        serve = 2
                        server = Player()
                    }else{
                        serve = 1
                        server = lastStat?.server ?? Player()
                    }
                } else {
                    if lastStat?.to == 1 {
                        serve = 1
                        rotate()
                        server = rotation.server(rotate: rotationTurns)
                    }else{
                        serve = 2
                        server = Player()
                    }
                }
            }else{
                serve = lastStat!.server.id != 0 ? 1 : 2
                server = lastStat!.server
            }
            stage = lastStat?.to == 0 ? .K3 : serve == 1 ? .K2 : .K1
            setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
            order = lastStat!.order + 1
        }
        rotationArray = rotation.get(rotate: rotationTurns)
        players()
        self.timeOuts = set.timeOuts()
    }
    
    func checkSetters()->Bool{
        let rotation = self.rotation.get(rotate: self.rotationTurns)
        let front = [rotation[1],rotation[2],rotation[3]].filter{$0?.position == .setter}.count
        let back = [rotation[0],rotation[4],rotation[5]].filter{$0?.position == .setter}.count
        if gameMode == "5-1"{
            return front+back >= 1
        }else if gameMode == "6-2" || gameMode == "4-2"{
            return back == 1 && front == 1
        }else{
            return true
        }
    }
    func makeToast(type: ToastType, message: String){
        self.message = message
        self.type = type
        self.showToast = true
    }
    func updateSet(){
        set.score_us = point_us
        set.score_them = point_them
        let id = set.update()
        if id {
            //            print("updated")
        }
    }
    func getChangeOptions()->[Player]{
        
        let changes = self.set.changes()
        let changed = changes.filter{$0.1==self.player!}
        return changed.isEmpty ? self.nonLineup() : changed.map{$0.0}
    }
    func canChange()->Bool{
        let changes = self.set.changes()
        let changed = changes.filter{$0.0==self.player!}
        
        return self.set.restrictChanges ? self.player != nil && self.lastStat != nil && changed.isEmpty : self.player != nil && self.lastStat != nil
    }
    func nonLineup() -> [Player]{
        return team.activePlayers().filter{p in return !rotation.get().contains(p) && !set.liberos.contains(p.id)}
    }
    func timeOut(to: Int){
        let stat = Stat.createStat(stat: Stat(match: self.match.id, set: self.set.id, player: 0, action: 0, rotation: rotation, rotationTurns: rotationTurns, rotationCount: rotationCount, score_us: point_us, score_them: point_them, to: to, stage: self.stage.rawValue, server: server, player_in: nil, detail: "", order: self.order, direction: ""))
       
        if stat != nil {
            if match.live{
                stat!.shareLive()
            }
            lastStat = stat
            self.timeOuts = set.timeOuts()
            self.order += 1
//            self.showSummary.toggle()
        }
    }
    func saveAdjust(){
        if self.set.gameMode != self.gameMode{
            self.set.gameMode = self.gameMode
            if self.set.update() {
                self.setter = self.rotation.getSetter(gameMode: self.gameMode, rotationTurns: self.rotationTurns)
                adjust = false
                showRotation = false
            }
        }
        let stat = Stat.createStat(stat: Stat(match: self.match.id, set: self.set.id, player: 0, action: 98, rotation: rotation, rotationTurns: rotationTurns, rotationCount: rotationCount, score_us: point_us, score_them: point_them, to: 0, stage: self.stage.rawValue, server: server, player_in: nil, detail: "", order: self.order, direction: ""))
        if stat != nil {
            if match.live{
                stat!.shareLive()
            }
            lastStat = stat
            adjust = false
            showRotation = false
            players()
            self.order += 1
        }
    }
    func changePlayer(change: Player){
//        let idx = self.rotation.get().firstIndex(of: self.player!)
//        print(self.rotation.description, self.rotationTurns)
        let newr = self.rotation.changePlayer(player: self.player!, change: change, rotationTurns: self.rotationTurns)
//        print(newr?.1.description, newr?.0)
        if newr?.1.checkSetters(gameMode: self.gameMode, rotationTurns: self.rotationTurns) ?? false{
            let stat = Stat.createStat(stat: Stat(match: self.match.id, set: self.set.id, player: self.player?.id ?? 0, action: 99, rotation: self.rotation, rotationTurns: rotationTurns, rotationCount: rotationCount, score_us: point_us, score_them: point_them, to: 0, stage: self.stage.rawValue, server: server, player_in: change.id, detail: "", order: self.order, direction: ""))
            if stat != nil {
                if match.live{
                    stat!.shareLive()
                }
                if self.server == self.player && self.server.id != 0 {
                    server=change
                }
//                print(self.rotation.description, newr!.1.description)
                self.rotation = newr!.1
                self.rotationTurns = newr!.0
                lastStat = stat
                lineupPlayers = players()
                rotationArray = rotation.get(rotate: rotationTurns)
                setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
                self.clear()
                self.order+=1
//                }else {
//                    self.undo()
//                }
                
                //            self.showChange.toggle()
            }
        } else {
            self.makeToast(type: .error, message: "not.enough.setters".trad())
        }
            
            
    }
    func hasActionDetail()->Bool{
        if self.player != nil && self.action != nil {
            return ([15, 16, 17, 18, 19].contains(self.action!.id)) && set.errorDetail
        }
        return false
    }
    func hasDirectionDetail()->Bool{
//        if stage != .K3 && direction == ""{
//            return set.directionDetail
//        }else 
        if self.player != nil && self.action != nil{
            return [9, 10, 11 ,23].contains(self.action!.id) && set.directionDetail
        }
        return false
    }
    
    func rotate(inverse:Bool = false){
        if !inverse{
            self.rotationTurns = self.rotationTurns == match.n_players-1 ? 0 : self.rotationTurns+1
            self.rotationCount = self.rotationCount == match.n_players ? 1 : self.rotationCount+1
        }else{
            self.rotationTurns = self.rotationTurns == 0 ? match.n_players-1 : self.rotationTurns-1
            self.rotationCount = self.rotationCount == 0 ? 6 : self.rotationCount-1
        }
        rotationArray = rotation.get(rotate: rotationTurns)
        setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
    }
    
    func actionTap(action: Action){
        self.action = action
        if (action.type == 0 && self.player != nil){
            self.saveAction()
        }
    }
    
    func clear(){
        self.action = nil
        self.player = nil
        self.detail = ""
        self.direction = ""
    }
    func undo(){
        var stats = self.set.stats()
        //TODO: remove stat from firebase
        if !stats.isEmpty {
            var removed = stats.removeLast()
            lastStat = stats.last
            if lastStat != nil{
                point_us = removed.to == 1 ? removed.score_us - 1 : removed.score_us
                point_them = removed.to == 2 ? removed.score_them - 1 : removed.score_them
                rotation = removed.rotation
                self.server = removed.server
                serve = server.id == 0 ? 2 : 1
                stage = serve == 1 ? .K2 : .K1
                rotationCount = removed.rotationCount
                rotationTurns = removed.rotationTurns
                self.action = Action.find(id: removed.action)
                self.player = Player.find(id: removed.player)
                lineupPlayers = self.players()
                setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
                self.order = lastStat!.order + 1
            }else if stats.isEmpty {
                point_us = 0
                point_them = 0
                rotation = self.set.rotation
                rotationCount = 1
                rotationTurns = 0
                self.server = self.set.first_serve == 1 ? rotation.server(rotate: rotationTurns) : Player()
                serve = self.set.first_serve
                stage = serve == 1 ? .K2 : .K1
                self.action = Action.find(id: removed.action)
                self.player = removed.player == 0 ? Player(name: "Their player", number: 0, team: 0, active:1, birthday: Date(), id: 0) : Player.find(id: removed.player)
                lineupPlayers = self.players()
                setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
                self.order = 0
            }
            rotationArray = rotation.get(rotate: rotationTurns)
            removed.delete()
            self.timeOuts = set.timeOuts()
        }
    }
    func players() -> [Player]{
        var players: [Player] = []
        for p in rotation.get(){
            if (p != nil){
                players.append(p!)
            }
        }
        let i = self.liberoIdx ? 1 : 0
        if set.liberos[i] != 0 {
            players.append(Player.find(id: set.liberos[i]!)!)
        }
        lineupPlayers = players
        return players
    }
    func lineup() -> [Player]{
        var players: [Player] = []
        for p in rotation.get(rotate: self.rotationTurns){
            if (p != nil){
                players.append(p!)
            }
        }
        return players
    }
    func pointTo() -> (String, Int)?{
        if [2,3].contains(action?.type ?? nil) {
            if player?.id == 0 {
                return ("us", 1)
            }else{
                return ("them",2)
            }
        }else if action?.type ?? nil == 1 {
            if player?.id == 0 {
                return ("them", 2)
            }else{
                return ("us", 1)
            }
        }else if action?.type == 0{
            return ("none", 0)
        }else {
            return nil
        }
    }
    func saveAction() {
        if (player != nil && action != nil && pointTo() != nil){
            let (_, to)=pointTo() ?? ("", 0)
            if (to == 1) {
                point_us+=1
            }else if(to == 2){
                point_them+=1
            }
//            print(direction)
            let stat = Stat.createStat(stat: Stat(match: match.id, set: set.id, player: player?.id ?? 0, action: action?.id ?? 0, rotation: rotation, rotationTurns: rotationTurns, rotationCount: rotationCount, score_us: point_us, score_them: point_them, to: to, stage: self.stage.rawValue, server: server, player_in: nil, detail: detail, setter: setter, order: self.order, direction: self.direction))
            if stat != nil {
                if match.live{
                    stat!.shareLive()
                }
                lastStat = stat
                detail=""
                direction = ""
                self.order += 1
            }
            
            if(to != 0 && to != serve){
                if(serve == 1){
                    serve = 2
                    server = Player()
                }else if (serve == 2){
                    serve = 1
                    rotate()
                    server = rotation.server(rotate: rotationTurns)
                    rotationArray = rotation.get(rotate: rotationTurns)
                    
                }
                
            }
            if to == 0 {
                stage = .K3
            }else{
                stage = serve == 1 ? .K2 : .K1
            }
            setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
            clear()
        }
    }
}





