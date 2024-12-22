import SwiftUI

struct FillStats: View {
    @ObservedObject var viewModel: FillStatsModel
    var sq: CGFloat = 90
//    let actions: Dictionary<Int, Array<Action>> = Dictionary(grouping:  Action.getByType(type: 0), by: {$0.area.rawValue})
    let actions: [[Action]] = inGameActions
    let statb = RoundedRectangle(cornerRadius: 15, style: .continuous)
    var body: some View {
        VStack {
            HStack{
                ZStack{
                    statb.fill(viewModel.lastPoint != nil ? .blue : .gray)
                        Image(systemName: "chevron.left")
                }.onTapGesture{
                    if viewModel.lastPoint != nil {
                        viewModel.getPreviousPoint()
                    }
                }.frame(maxWidth: 30)
                VStack{
                    Text("last.point".trad()).font(.body)
                    if viewModel.lastPoint != nil{
//                        Text("\(viewModel.lastPoint!.order)")
                        if [0, 98, 99].contains(viewModel.lastPoint?.action){
                            HStack{
                                if viewModel.lastPoint?.action == 0{
                                    Text("time.out.by".trad()+(viewModel.lastPoint?.to == 1 ? "us".trad() : "them".trad())).frame(maxWidth: .infinity)
                                }
                                if viewModel.lastPoint?.action == 98{
                                    Text("score.adjust".trad()).frame(maxWidth: .infinity)
                                }
                                if viewModel.lastPoint?.action == 99{
                                    Image(systemName: "arrow.up.circle.fill").foregroundColor(.green)
                                    Text("\(Player.find(id: viewModel.lastPoint?.player_in ?? 0)?.name ?? "")")
                                    Image(systemName: "arrow.down.circle.fill").foregroundColor(.red)
                                    Text("\(Player.find(id: viewModel.lastPoint?.player ?? 0)?.name ?? "")")
                                }
                            }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 8))
                        }else{
                            
                            HStack{
                                ZStack{
                                    let lastPlayer = Player.find(id: viewModel.lastPoint?.player ?? 0)
                                    statb.fill(viewModel.lastPoint?.player == nil ? .black.opacity(0.4) : viewModel.lastPoint?.player == 0 ? .pink : .blue)
                                    HStack{
                                        if (lastPlayer != nil && lastPlayer?.id != 0){
                                            Text("\(lastPlayer?.number ?? 0)")
                                        }
                                        Text(" \(lastPlayer == nil ? (viewModel.lastPoint?.player == 0 ? "their.player".trad() : "player".trad()) : lastPlayer!.name)")
                                    }
                                    
                                }
                                let lastAction = Action.find(id: viewModel.lastPoint?.action ?? 0)
                                ZStack{
                                    statb.fill(lastAction?.color() ?? .black.opacity(0.4))
                                    Text("\(lastAction?.name.trad().capitalized ?? "action".trad())")
                                }
                                ZStack{
                                    statb.fill(viewModel.lastPoint?.to == 1 ? .blue : viewModel.lastPoint?.to == 2 ? .pink : .black.opacity(0.4))
                                    if viewModel.lastPoint?.to == 1 {
                                        Text("\("us".trad())")
                                    } else if viewModel.lastPoint?.to == 2 {
                                        Text("\("them".trad())")
                                    } else {
                                        Text("\("to".trad())")
                                    }
                                    
                                }
                            }
                        }
                        HStack{
                            
                            HStack {
                                ZStack{
                                    statb.stroke(.blue, lineWidth: 3)
                                    Text("\(viewModel.lastPoint?.score_us ?? 0)").font(Font.body)
                                }.overlay(Image("Voleibol").scaleEffect(0.007, anchor: .center).opacity(viewModel.lastPoint?.server.id != 0 ? 1 : 0).padding().offset(x: 20.0, y: -15.0))
                                    .overlay{
                                        HStack{
                                            ForEach(0..<viewModel.timeOuts.0, id:\.self){t in
                                                Image(systemName: "t.circle.fill")
                                            }
                                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                                    }
                                ZStack{
                                    statb.stroke(.pink, lineWidth: 3)
                                    Text("\(viewModel.lastPoint?.score_them ?? 0)").font(Font.body)
                                }.overlay(Image("Voleibol").scaleEffect(0.007, anchor: .center).opacity(viewModel.lastPoint?.server.id == 0 ? 1 : 0).padding().offset(x: 20.0, y: -15.0))
                                    .overlay{
                                        HStack{
                                            ForEach(0..<viewModel.timeOuts.1, id:\.self){t in
                                                Image(systemName: "t.circle.fill")
                                            }
                                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                                    }
                            }
                        }
                    } else{
                        VStack{
                            Image(systemName: "hand.tap.fill").foregroundStyle(.cyan).font(.title3).padding(.bottom)
                            Text("no.data".trad()).foregroundStyle(.gray)
                        }.padding().font(.body).frame(maxWidth: .infinity, maxHeight: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity)
                VStack{
                    Text("next.point".trad()).font(.body)
                    if viewModel.nextPoint != nil{
//                        Text("\(viewModel.nextPoint!.order)")
                        if [0, 98, 99].contains(viewModel.nextPoint?.action){
                            HStack{
                                if viewModel.nextPoint?.action == 0{
                                    Text("time.out.by".trad()+(viewModel.nextPoint?.to == 1 ? "us".trad() : "them".trad())).frame(maxWidth: .infinity)
                                }
                                if viewModel.nextPoint?.action == 98{
                                    Text("score.adjust".trad()).frame(maxWidth: .infinity)
                                }
                                if viewModel.nextPoint?.action == 99{
                                    Image(systemName: "arrow.up.circle.fill").foregroundColor(.green)
                                    Text("\(Player.find(id: viewModel.nextPoint?.player_in ?? 0)?.name ?? "")")
                                    Image(systemName: "arrow.down.circle.fill").foregroundColor(.red)
                                    Text("\(Player.find(id: viewModel.nextPoint?.player ?? 0)?.name ?? "")")
                                }
                            }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 8))
                        }else{
                            
                            HStack{
                                ZStack{
                                    statb.fill(viewModel.nextPoint?.player == nil ? .black.opacity(0.4) : viewModel.nextPoint?.player == 0 ? .pink : .blue)
                                    HStack{
                                        let nextPlayer = Player.find(id: viewModel.nextPoint?.player ?? 0)
                                        if (nextPlayer != nil && nextPlayer?.id != 0){
                                            Text("\(nextPlayer?.number ?? 0)")
                                        }
                                        Text(" \(nextPlayer == nil ? (viewModel.nextPoint?.player == 0 ? "their.player".trad() : "player".trad()) : nextPlayer!.name)")
                                        //                                    Text(" \(nextPlayer?.name ?? "player".trad())")
                                    }
                                    
                                }.onTapGesture{
                                    if viewModel.player != nil{
//                                        print(viewModel.nextPoint?.player)
                                        viewModel.nextPoint!.player = viewModel.player!.id
                                        if viewModel.nextPoint!.update(){
//                                            print(viewModel.nextPoint?.player)
//                                            viewModel.nextPoint = viewModel.nextPoint!
                                            viewModel.clear()
                                            let ac = Action.find(id: viewModel.nextPoint!.action)!
                                            if viewModel.pointTo(action: ac, player: viewModel.nextPoint!.player) != viewModel.nextPoint!.to{
                                                viewModel.showActions.toggle()
                                            }
                                        }
                                    }
                                }
                                ZStack{
                                    let nextAction = Action.find(id: viewModel.nextPoint?.action ?? 0)
                                    statb.fill(nextAction?.color() ?? .black.opacity(0.4))
                                    Text("\(nextAction?.name.trad().capitalized ?? "action".trad())")
                                }.onTapGesture{
                                    viewModel.showActions.toggle()
                                }
                                ZStack{
                                    statb.fill(viewModel.nextPoint?.to == 1 ? .blue : viewModel.nextPoint?.to == 2 ? .pink : .black.opacity(0.4))
                                    if viewModel.nextPoint?.to == 1 {
                                        Text("\("us".trad())")
                                    } else if viewModel.nextPoint?.to == 2 {
                                        Text("\("them".trad())")
                                    } else {
                                        Text("\("to".trad())")
                                    }
                                }
                            }
                        }
                        HStack{
                            HStack {
                                ZStack{
                                    statb.stroke(.blue, lineWidth: 3)
                                    Text("\(viewModel.nextPoint?.score_us ?? 0)").font(Font.body)
                                }.overlay(Image("Voleibol").scaleEffect(0.007, anchor: .center).opacity(viewModel.nextPoint?.server.id != 0 ? 1 : 0).padding().offset(x: 20.0, y: -15.0))
                                    .overlay{
                                        HStack{
                                            ForEach(0..<viewModel.timeOuts.0, id:\.self){t in
                                                Image(systemName: "t.circle.fill")
                                            }
                                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                                    }
                                ZStack{
                                    statb.stroke(.pink, lineWidth: 3)
                                    Text("\(viewModel.nextPoint?.score_them ?? 0)").font(Font.body)
                                }.overlay(Image("Voleibol").scaleEffect(0.007, anchor: .center).opacity(viewModel.nextPoint?.server.id == 0 ? 1 : 0).padding().offset(x: 20.0, y: -15.0))
                                    .overlay{
                                        HStack{
                                            ForEach(0..<viewModel.timeOuts.1, id:\.self){t in
                                                Image(systemName: "t.circle.fill")
                                            }
                                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                                    }
                            }
                            if false{ //viewModel.nextPoint?.hasDirectionDetail() ?? false{
                                ZStack{
                                    statb.fill(.blue)
                                    if viewModel.nextPoint?.direction ?? "" == ""{
                                        HStack{
                                            Image(systemName: "plus")
                                            Text("direction".trad()).font(Font.body)
                                        }
                                    }else{
                                        HStack{
                                            Image(systemName: "square.and.pencil").font(Font.body).padding(.horizontal)
                                            Text(viewModel.nextStat!.direction).font(Font.body).frame(maxWidth: .infinity)
                                        }
                                    }
                                }.onTapGesture{
                                    viewModel.selectedStat = viewModel.nextPoint
                                    viewModel.showDirection.toggle()
                                }
                            }
//                            
                            if viewModel.nextPoint?.hasActionDetail() ?? false{
                                ZStack{
                                    statb.fill(.blue)
                                    if viewModel.nextPoint?.detail ?? "" == ""{
                                        HStack{
                                            Image(systemName: "plus")
                                            Text("detail".trad()).font(Font.body)
                                        }
                                    }else{
                                        HStack{
                                            Image(systemName: "square.and.pencil").font(Font.body).padding(.horizontal)
                                            Text(viewModel.nextPoint!.detail).font(Font.body).frame(maxWidth: .infinity)
                                        }
                                    }
                                }.onTapGesture{
                                    viewModel.selectedStat = viewModel.nextPoint
                                    viewModel.showDetail.toggle()
                                }
                            }
                            
                        }
                    } else{
                        VStack{
                            Image(systemName: "hand.tap.fill").foregroundStyle(.cyan).font(.title3).padding(.bottom)
                            Text("no.data".trad()).foregroundStyle(.gray)
                        }.padding().font(.body).frame(maxWidth: .infinity, maxHeight: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity)
                ZStack{
                    statb.fill(viewModel.nextPoint != nil ? .blue : .gray)
                    Image(systemName: "chevron.right")
                }.onTapGesture{
                    if viewModel.nextPoint != nil {
                        viewModel.getNextPoint()
                    }
                }.frame(maxWidth: 30)
            }.padding(.horizontal).frame(height: sq*2)
//            HStack {
//                ZStack{
//                    statb.fill(.gray)
//                    Text("time.out".trad()).foregroundColor(.white)
//                    
//                }.onTapGesture {
//                    viewModel.showTimeout.toggle()
//                }
//                
//                    VStack {
//                        Court(rotation: $viewModel.rotationArray, numberPlayers: viewModel.match.n_players, width: 90, height: 70)
//                    }
//            }.frame(maxHeight: sq).padding(.horizontal)
            ZStack{
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
                                    
                                }.foregroundColor(.white).font(Font.body)
                            }.onTapGesture {
                                if viewModel.player == player{
                                    viewModel.player = nil
                                }else{
                                    viewModel.player = player
                                }
                            }
                            .overlay(Image("Voleibol").scaleEffect(0.01, anchor: .center).opacity(player == viewModel.nextPoint?.server ? 1 : 0).padding().offset(x: 40.0, y: -20.0))
                        }
                    }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2))).padding(.trailing, 5).frame(maxWidth: sq*2)
                    ZStack{
                        VStack{
                            VStack{
                                HStack{
                                    ZStack{
                                        statb.fill(viewModel.lastStat != nil ? .blue : .gray)
                                        Image(systemName: "chevron.left")
                                    }.onTapGesture{
                                        if viewModel.lastStat != nil {
                                            viewModel.nextStat = viewModel.lastStat
                                            viewModel.lastStat = viewModel.getPreviousAction()
                                        }
                                    }.frame(maxWidth: 30, maxHeight: 30)
                                    Text("in.game.actions".trad()).font(.title3).frame(maxWidth: .infinity)
                                    ZStack{
                                        statb.fill(viewModel.nextStat != nil ? .blue : .gray)
                                        Image(systemName: "chevron.right")
                                    }.onTapGesture{
                                        if viewModel.nextStat != nil {
                                            viewModel.lastStat = viewModel.nextStat
                                            viewModel.nextStat = viewModel.getNextAction()
                                        }
                                    }.frame(maxWidth: 30, maxHeight: 30)
                                }
                                HStack{
                                    VStack{
                                        HStack{
                                            Text("last.action".trad()).font(.body).frame(maxWidth:.infinity)
                                            if viewModel.lastStat != nil{
                                                Image(systemName: "trash.fill").foregroundStyle(.red).font(.title3).onTapGesture{
                                                    let tmp = viewModel.getPreviousAction()
                                                    if viewModel.lastStat!.delete(){
                                                        viewModel.lastStat = tmp
                                                    }
                                                }
                                            }
                                            
                                        }
                                        if viewModel.lastStat != nil{
//                                            Text("\(viewModel.lastStat!.order)")
                                            if [98, 99].contains(viewModel.lastStat?.action){
                                                HStack{
                                                    if viewModel.lastStat?.action == 98{
                                                        HStack(){
                                                            Text("change.player".trad())
                                                            Image(systemName: "arrow.up.circle.fill").foregroundColor(.green)
                                                            Text("\(Player.find(id: viewModel.lastStat?.player_in ?? 0)?.name ?? "")").padding(.trailing)
                                                            Image(systemName: "arrow.down.circle.fill").foregroundColor(.red)
                                                            Text("\(Player.find(id: viewModel.lastStat!.player)?.name ?? "")")
                                                        }.frame(maxWidth: .infinity)
                                                    }else{
                                                        Text("score.adjust".trad()).frame(maxWidth: .infinity)
                                                    }
                                                }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 8))
                                            }else{
                                                
                                                VStack{
                                                    ZStack{
                                                        let lastPlayer = Player.find(id: viewModel.lastStat?.player ?? 0)
                                                        statb.fill(viewModel.lastStat?.player == nil ? .black.opacity(0.4) : viewModel.lastStat?.player == 0 ? .pink : .blue)
                                                        HStack{
                                                            if (lastPlayer != nil && lastPlayer?.id != 0){
                                                                Text("\(lastPlayer?.number ?? 0)")
                                                            }
                                                            Text(" \(lastPlayer == nil ? (viewModel.lastStat?.player == 0 ? "their.player".trad() : "player".trad()) : lastPlayer!.name)")
                                                        }//.padding()
                                                        
                                                    }
                                                    let lastAction = Action.find(id: viewModel.lastStat?.action ?? 0)
                                                    ZStack{
                                                        statb.fill(lastAction?.color() ?? .black.opacity(0.4))
                                                        Text("\(lastAction?.name.trad().capitalized ?? "action".trad())").padding()
                                                    }
                                                    
                                                }
                                            }
                                            
                                        } else{
                                            VStack{
                                                Image(systemName: "hand.tap.fill").foregroundStyle(.cyan).font(.title3).padding(.bottom)
                                                Text("no.data".trad()).foregroundStyle(.gray)
                                            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).font(.body).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity).frame(height: sq*2)
                                    VStack{
                                        HStack{
                                            Text("next.action".trad()).font(.body).frame(maxWidth:.infinity)
                                            if viewModel.nextStat != nil{
                                                Image(systemName: "trash.fill").foregroundStyle(.red).font(.title3).onTapGesture{
                                                    let tmp = viewModel.getNextAction()
                                                    if viewModel.nextStat!.delete(){
                                                        viewModel.nextStat = tmp
                                                    }
                                                }
                                            }
                                            
                                        }
                                        if viewModel.nextStat != nil{
//                                            Text("\(viewModel.nextStat!.order)")
                                            if [98, 99].contains(viewModel.nextStat?.action){
                                                HStack{
                                                    if viewModel.nextStat?.action == 98{
                                                        HStack(){
                                                            Text("change.player".trad())
                                                            Image(systemName: "arrow.up.circle.fill").foregroundColor(.green)
                                                            Text("\(Player.find(id: viewModel.nextStat?.player_in ?? 0)?.name ?? "")").padding(.trailing)
                                                            Image(systemName: "arrow.down.circle.fill").foregroundColor(.red)
                                                            Text("\(Player.find(id: viewModel.nextStat!.player)?.name ?? "")")
                                                        }.frame(maxWidth: .infinity)
                                                    }else{
                                                        Text("score.adjust".trad()).frame(maxWidth: .infinity)
                                                    }
                                                }.padding().background(.gray).clipShape(RoundedRectangle(cornerRadius: 8))
                                            }else{
                                                ZStack{
                                                    statb.fill(viewModel.nextStat?.player == nil ? .black.opacity(0.4) : viewModel.nextStat?.player == 0 ? .pink : .blue)
                                                    HStack{
                                                        let nextPlayer = Player.find(id: viewModel.nextStat?.player ?? 0)
                                                        if (nextPlayer != nil && nextPlayer?.id != 0){
                                                            Text("\(nextPlayer?.number ?? 0)")
                                                        }
                                                        Text(" \(nextPlayer == nil ? (viewModel.nextStat?.player == 0 ? "their.player".trad() : "player".trad()) : nextPlayer!.name)")
                                                        //                                    Text(" \(nextPlayer?.name ?? "player".trad())")
                                                    }//.padding()
                                                    
                                                }
                                                HStack{
                                                    
                                                    ZStack{
                                                        let nextAction = Action.find(id: viewModel.nextStat?.action ?? 0)
                                                        statb.fill(nextAction?.color() ?? .black.opacity(0.4))
                                                        Text("\(nextAction?.name.trad().capitalized ?? "action".trad())").padding()
                                                    }
                                                    HStack{
                                                        if false { //viewModel.nextStat?.hasDirectionDetail() ?? false{
                                                            ZStack{
                                                                statb.fill(.blue)
                                                                if viewModel.nextStat?.direction ?? "" == ""{
                                                                    HStack{
                                                                        Image(systemName: "plus")
                                                                        Text("direction".trad())
                                                                    }
                                                                }else{
                                                                    HStack{
                                                                        Image(systemName: "square.and.pencil").padding(.leading)
                                                                        Text(viewModel.nextStat!.direction).frame(maxWidth: .infinity, alignment: .center)
                                                                    }
                                                                }
                                                            }.onTapGesture{
                                                                viewModel.selectedStat = viewModel.nextStat
                                                                viewModel.showDirection.toggle()
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                            }
                                            
                                        } else{
                                            VStack{
                                                Image(systemName: "hand.tap.fill").foregroundStyle(.cyan).font(.title3).padding(.bottom)
                                                Text("no.data".trad()).foregroundStyle(.gray)
                                            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).font(.body).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity).frame(height: sq*2)
                                }
                            }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)))
                            VStack {
                                
                                Text("actions".trad()).font(.title3)
                                //                    Divider().overlay(.white).padding(.bottom)
                                VStack {
                                    //                            ForEach(actions.sorted(by: {$0.key < $1.key}), id:\.key){key, sub in
                                    ForEach(actions, id:\.self){sub in
                                        HStack{
                                            ForEach(sub, id:\.id){action in
                                                //                                        if action.id != 38 && action.type == 0 {
                                                ZStack{
                                                    statb.stroke(viewModel.action?.id == action.id ? .white : .clear, lineWidth: 3).background(statb.fill(action.color()))
                                                    Text("\(action.name.trad().capitalized)").foregroundColor(.white).padding(5)
                                                }.onTapGesture {
                                                    viewModel.actionTap(action: action)
                                                }
                                                //                                        }
                                            }
                                        }
                                    }
                                }
                                
                            }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)))
                        }
                        if !viewModel.checkAvailableInGame(){
                            Rectangle().fill(.black.opacity(0.4))
                        }
                    }
                    
                }.padding()
                if !viewModel.checkAdjust(){
                    Rectangle().fill(.black.opacity(0.4))
                }
            }
        }
        .navigationTitle("fill.stats".trad())
        .background(Color.swatch.dark.high).foregroundColor(.white)
//        .navigationBarBackButtonHidden(true)
        .toast(show: $viewModel.showToast, Toast(show: $viewModel.showToast, type: viewModel.type, message: viewModel.message))
        .frame(maxHeight: .infinity)
        .overlay(viewModel.showTimeout ? timeOutModal() : nil)
        .overlay(viewModel.showDetail ? detailModal() : nil)
        .overlay(viewModel.showDirection ? directionModal() : nil)
        .overlay(viewModel.showActions ? actionModal() : nil)
        .font(.custom("stats", size: 12))
        .onDisappear(perform: {
            //here re-rank the order values back to int
        })
        .onAppear(perform: {
            viewModel.players()
        })
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                NavigationLink(destination: CaptureHelp()){
                    Image(systemName: "questionmark.circle").font(.title3).foregroundStyle(.white)
                }
            }
        }
        
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
    func detailModal() -> some View {
            VStack{
                HStack{
                    Button(action:{
                        viewModel.showDetail.toggle()
                        viewModel.selectedStat = nil
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                Text("detail.title".trad()).font(.title2).padding([.bottom, .horizontal])
                HStack{
                    ZStack{
                        statb.fill(.blue)
                        Text("net".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.selectedStat!.detail = "Net"
                        if viewModel.selectedStat!.update(){
                            viewModel.showDetail.toggle()
                            viewModel.selectedStat = nil
                            
                        }
                    }
                    ZStack{
                        statb.fill(viewModel.action?.id==15 ? .gray : .blue)
                        Text("blocked".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.selectedStat!.detail = "Blocked"
                        if viewModel.selectedStat!.update(){
                            viewModel.showDetail.toggle()
                            viewModel.selectedStat = nil
                            
                        }
                    }.disabled(viewModel.action?.id==15)
                    ZStack{
                        statb.fill(.blue)
                        Text("out".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.selectedStat!.detail = "Out"
                        if viewModel.selectedStat!.update(){
                            viewModel.showDetail.toggle()
                            viewModel.selectedStat = nil
                            
                        }
                    }
                }.padding()
            }
            .background(.black.opacity(0.9))
            .frame(width:500, height: 250)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    @ViewBuilder
    func directionModal() -> some View {
        VStack{
            HStack{
                Button(action:{
                    viewModel.showDirection.toggle()
                    viewModel.selectedStat = nil
                    viewModel.direction = ""
                }){
                    Image(systemName: "multiply").font(.title2)
                }
            }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
            Text("directions.detail".trad()).font(.title2).padding([.bottom, .horizontal])
            DirectionsCourt(viewModel: DirectionsCourtModel(direction: $viewModel.direction, isServe: viewModel.selectedStat!.stage != Stages.K3.rawValue, numberPlayers: viewModel.match.n_players))
                ZStack{
                    statb.fill(.blue)
                    Text("save".trad()).foregroundColor(.white).padding(5)
                }.onTapGesture {
                    viewModel.selectedStat!.direction = viewModel.direction
                    if viewModel.selectedStat!.update(){
                        viewModel.showDirection.toggle()
                        viewModel.selectedStat = nil
                        viewModel.direction = ""
                        
                    }
                }.frame(maxHeight: sq).padding([.horizontal, .bottom])
//            }
        }
        
        .background(.black)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        
    }
    
    @ViewBuilder
    func actionModal() -> some View {
            VStack{
                ZStack{
                    Button(action:{
                        viewModel.showActions.toggle()
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                    Text("actions".trad()).font(.title2).frame(maxWidth: .infinity)
                }.padding()
                let ac = Action.find(id: viewModel.nextPoint!.action)!
                let to = viewModel.pointTo(action: ac, player: viewModel.nextPoint!.player)
                if to == viewModel.nextPoint!.to{
                    if [2,3].contains(ac.type){
                        LazyVGrid(columns: [GridItem](repeating: GridItem(), count: 4)){
                            ForEach(Action.getByType(type: 2), id:\.id){action in
                                Text("\(action.name.trad().capitalized)").padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(hex: "f2ac0a") ?? .yellow).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    viewModel.nextPoint!.action = action.id
                                    if viewModel.nextPoint!.update() {
                                        viewModel.showActions.toggle()
                                    }
                                }
                            }
                        }.padding()
                        LazyVGrid(columns: [GridItem](repeating: GridItem(), count: 4)){
                            ForEach(Action.getByType(type: 3), id:\.id){action in
                                Text("\(action.name.trad().capitalized)").padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(hex: "DC3535") ?? .red).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    viewModel.nextPoint!.action = action.id
                                    if viewModel.nextPoint!.update() {
                                        viewModel.showActions.toggle()
                                    }
                                }
                            }
                        }.padding()
                    }else{
                        LazyVGrid(columns: [GridItem](repeating: GridItem(), count: 4)){
                            ForEach(Action.getByType(type: 1), id:\.id){action in
                                Text("\(action.name.trad().capitalized)").padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(hex: "6ECB63") ?? .green).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    viewModel.nextPoint!.action = action.id
                                    if viewModel.nextPoint!.update() {
                                        viewModel.showActions.toggle()
                                    }
                                }
                            }
                        }.padding()
                    }
                }else{
                    if [2,3].contains(ac.type){
                        LazyVGrid(columns: [GridItem](repeating: GridItem(), count: 4)){
                            ForEach(Action.getByType(type: 1), id:\.id){action in
                                Text("\(action.name.trad().capitalized)").padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(hex: "6ECB63") ?? .green).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    viewModel.nextPoint!.action = action.id
                                    if viewModel.nextPoint!.update() {
                                        viewModel.showActions.toggle()
                                    }
                                }
                            }
                        }.padding()
                    }else{
                        LazyVGrid(columns: [GridItem](repeating: GridItem(), count: 4)){
                            ForEach(Action.getByType(type: 2), id:\.id){action in
                                Text("\(action.name.trad().capitalized)").padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(hex: "f2ac0a") ?? .yellow).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    viewModel.nextPoint!.action = action.id
                                    if viewModel.nextPoint!.update() {
                                        viewModel.showActions.toggle()
                                    }
                                }
                            }
                        }.padding()
                        LazyVGrid(columns: [GridItem](repeating: GridItem(), count: 4)){
                            ForEach(Action.getByType(type: 3), id:\.id){action in
                                Text("\(action.name.trad().capitalized)").padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(hex: "DC3535") ?? .red).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    viewModel.nextPoint!.action = action.id
                                    if viewModel.nextPoint!.update() {
                                        viewModel.showActions.toggle()
                                    }
                                }
                            }
                        }.padding()
                    }
                }
            }.padding()
            .foregroundColor(.white)
            .background(.black.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }
}

class FillStatsModel: ObservableObject{
    @Published var action: Action? = nil
    @Published var player: Player? = nil
    @Published var timeOuts: (Int, Int) = (0,0)
    @Published var lineupPlayers: [Player] = []
    @Published var showTimeout: Bool = false
    @Published var rotationArray:[Player?]=[nil, nil, nil, nil, nil, nil]
    @Published var message: String = ""
    @Published var type: ToastType = .info
    @Published var showToast: Bool = false
    @Published var lastPoint: Stat? = nil
    @Published var nextPoint: Stat? = nil
    var order: Double = 0
    @Published var lastStat: Stat? = nil
    @Published var nextStat: Stat? = nil
    @Published var pointPlayer:Player? = nil
    @Published var changePointPlayer: Bool = false
    @Published var selectedStat: Stat? = nil
    @Published var showDetail: Bool = false
    @Published var showDirection: Bool = false
    @Published var showActions: Bool = false
    var direction: String = ""
    let team: Team
    let match: Match
    var set: Set
    init(team: Team, match: Match, set: Set){
        self.match = match
        self.team = team
        self.set = set
        let fullStats = set.stats()
        let stats = fullStats.filter{s in return s.to != 0}
        let inGame = fullStats.filter{s in nextPoint?.order ?? 0 > s.order && s.to == 0}
        if (!stats.isEmpty){
            nextPoint = stats.first
            lastPoint = nil
            lastStat = inGame.first
            nextStat = inGame.count > 1 ? inGame[1] : nil
            let prevOrd = lastStat != nil ? lastStat!.order : 0
            let nextOrd = nextStat != nil ? nextStat!.order : nextPoint?.order ?? 0
            order = ( prevOrd + nextOrd)/2
            players()
        }
//        rotationArray = rotation.get(rotate: rotationTurns)
//        players()
//        self.timeOuts = set.timeOuts()
    }
    func checkAvailableInGame()->Bool{
        if self.nextPoint != nil{
            return ![.serve, .receive].contains(Action.find(id: self.nextPoint!.action)?.area) && checkAdjust()
        }
        return false
    }
    func checkAdjust()->Bool{
        if self.nextPoint != nil{
            return ![0, 98, 99].contains(self.nextPoint!.action)
        }
        return false
    }
    func getNextPoint(){
        self.lastPoint = self.nextPoint
        self.nextPoint = self.set.stats().filter{s in (s.to != 0 || [0, 98, 99].contains(s.action)) && s.order > self.nextPoint?.order ?? 0}.first
        if checkAvailableInGame() && checkAdjust(){
            self.lastStat = nil
            self.nextStat = self.set.stats().filter{s in
                (s.to == 0 && ![0, 98, 99].contains(s.action)) &&
                s.order > self.lastPoint?.order ?? 0 &&
                s.order < self.nextPoint?.order ?? 0}.first
        }else{
            self.lastStat = nil
            self.nextStat = nil
        }
        self.players()
    }
    func getPreviousPoint(){
        self.nextPoint = self.lastPoint
        self.lastPoint = self.set.stats().filter{s in (s.to != 0 || [0, 98, 99].contains(s.action)) && s.order < self.lastPoint?.order ?? 0}.last
        if checkAvailableInGame() && checkAdjust(){
            self.lastStat = nil
            self.nextStat = self.set.stats().filter{s in
                (s.to == 0 && ![0, 98, 99].contains(self.nextPoint!.action)) &&
                s.order > self.lastPoint?.order ?? 0 &&
                s.order < self.nextPoint?.order ?? 0}.first
        }else{
            self.lastStat = nil
            self.nextStat = nil
        }
        self.players()
    }
    func getNextAction()->Stat?{
        return self.set.stats().filter{s in 
            (s.to == 0 && ![0, 98, 99].contains(s.action)) &&
            s.order > self.nextStat?.order ?? (self.lastPoint?.order ?? 0) &&
            s.order < self.nextPoint?.order ?? 0}.first
    }
    func getPreviousAction()->Stat?{
        return self.set.stats().filter{s in 
            (s.to == 0 && ![0, 98, 99].contains(s.action)) &&
            s.order < self.lastStat?.order ?? 0 &&
            s.order > self.lastPoint?.order ?? 0}.last
    }
    func checkSetters()->Bool{
        var ref = lastStat
        if lastStat == nil || lastStat?.action == 0{
            ref = nextPoint
        }
        let rotation = ref!.rotation.get(rotate: ref!.rotationTurns)
        let front = [rotation[1],rotation[2],rotation[3]].filter{$0?.position == .setter}.count
        let back = [rotation[0],rotation[4],rotation[5]].filter{$0?.position == .setter}.count
        if self.set.gameMode == "5-1"{
            return front+back >= 1
        }else if self.set.gameMode == "6-2" || self.set.gameMode == "4-2"{
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
    func calculateOrder(){
        var orderP = lastStat?.order ?? 0
        if lastStat == nil{
            orderP = lastPoint?.order ?? 0
        }
        var orderN = nextStat?.order ?? 0
        if nextStat == nil{
            orderN = nextPoint?.order ?? 0
        }
        self.order = (orderP+orderN)/2
    }
    func timeOut(to: Int){
        var ref = lastStat
        if lastStat == nil || lastStat?.action == 0{
            ref = nextPoint
        }
        if ref == nil{
            self.makeToast(type: .warning, message: "no.next.point".trad())
        }else{
            calculateOrder()
            let stat = Stat.createStat(stat: Stat(
                                    match: self.match.id,
                                    set: self.set.id,
                                    player: 0,
                                    action: 0,
                                    rotation: ref!.rotation,
                                    rotationTurns: ref!.rotationTurns,
                                    rotationCount: ref!.rotationCount,
                                    score_us: ref!.to == 1 ? ref!.score_us - 1 : ref!.score_us,
                                    score_them: ref!.to == 2 ? ref!.score_them - 1 : ref!.score_them,
                                    to: to,
                                    stage: ref!.stage,
                                    server: ref!.server,
                                    player_in: nil,
                                    detail: "",
                                    order: self.order,
                                    direction: ""
            ))
            
            if stat != nil {
                lastStat = stat
                self.timeOuts = set.timeOuts()
                self.order += 1
                //            self.showSummary.toggle()
            }
        }
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
    }
    func undo(){
//        var stats = self.set.stats()
//        if !stats.isEmpty {
//            var removed = stats.removeLast()
//            lastStat = stats.last
//            if lastStat != nil{
//                point_us = removed.to == 1 ? removed.score_us - 1 : removed.score_us
//                point_them = removed.to == 2 ? removed.score_them - 1 : removed.score_them
//                rotation = removed.rotation
//                self.server = removed.server
//                serve = server == 0 ? 2 : 1
//                stage = serve == 1 ? 0 : 1
//                rotationCount = removed.rotationCount
//                rotationTurns = removed.rotationTurns
//                self.action = Action.find(id: removed.action)
//                self.player = Player.find(id: removed.player)
//                lineupPlayers = self.players()
//                setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
//                self.order = lastStat!.order + 1
//            }else if stats.isEmpty {
//                point_us = 0
//                point_them = 0
//                rotation = self.set.rotation
//                rotationCount = 1
//                rotationTurns = 0
//                self.server = self.set.first_serve == 1 ? rotation.server(rotate: rotationTurns).id : 0
//                serve = self.set.first_serve
//                stage = serve == 1 ? 0 : 1
//                self.action = Action.find(id: removed.action)
//                self.player = removed.player == 0 ? Player(name: "Their player", number: 0, team: 0, active:1, birthday: Date(), id: 0) : Player.find(id: removed.player)
//                lineupPlayers = self.players()
//                setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
//                self.order = 0
//            }
//            rotationArray = rotation.get(rotate: rotationTurns)
//            removed.delete()
//            self.timeOuts = set.timeOuts()
//        }
    }
    
    func players(){
        var players: [Player] = []
        var ref = lastStat
        if lastStat == nil || lastStat?.action == 0{
            if nextPoint != nil {
                ref = nextPoint
            }else if lastPoint != nil{
                ref = lastPoint
            }
        }
        for p in ref?.rotation.get() ?? []{
//            let p = Player.find(id: n)
            if (p != nil){
                players.append(p!)
            }
        }
        set.liberos.forEach {
            if $0 != nil {
                let p = Player.find(id: $0!)
                if (p != nil){
                    players.append(p!)
                }
            }
        }
        lineupPlayers = players
    }
    
//    func lineup() -> [Player]{
//        var players: [Player] = []
//        for p in self.lastStat!.rotation.get(rotate: self.lastStat!.rotationTurns){
////            let p = Player.find(id: n)
//            if (p != nil){
//                players.append(p!)
//            }
//        }
////        print(players.map{$0.number})
//        return players
//    }

    func pointTo(action: Action, player: Int) -> Int{
        if [2,3].contains(action.type) {
            if player == 0 {
                return 1
            }else{
                return 2
            }
        }else if action.type == 1 {
            if player == 0 {
                return 2
            }else{
                return 1
            }
        }else{
            return 0
        }
    }
    func saveAction() {
        var ref = lastStat
        if lastStat == nil || lastStat?.action == 0{
            ref = nextPoint
        }
        if ref == nil{
            self.makeToast(type: .warning, message: "no.next.point".trad())
        }else{
            if (player != nil && action != nil && checkAvailableInGame() && checkAdjust()){
                calculateOrder()
                let stat = Stat.createStat(stat: Stat(
                                                    match: match.id,
                                                    set: set.id,
                                                    player: player?.id ?? 0,
                                                    action: action?.id ?? 0,
                                                    rotation: ref!.rotation,
                                                    rotationTurns: ref!.rotationTurns,
                                                    rotationCount: ref!.rotationCount,
                                                    score_us: ref!.to == 1 ? ref!.score_us - 1 : ref!.score_us,
                                                    score_them: ref!.to == 2 ? ref!.score_them - 1 : ref!.score_them,
                                                    to: 0,
                                                    stage: ref!.stage,
                                                    server: ref!.server,
                                                    player_in: nil,
                                                    detail: "",
                                                    setter: ref!.setter,
                                                    order: self.order,
                                                    direction: ""))
                if stat != nil {
                    lastStat = stat
                    self.order += 1
                }
                clear()
            }
        }
    }
}





