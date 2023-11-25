import SwiftUI
import UIPilot

struct Capture: View {
    @ObservedObject var viewModel: CaptureModel
    var sq: CGFloat = 90
    let actions: [[Action]] = Action.all()
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
                    if (viewModel.player != nil && viewModel.lastStat != nil){
                        showChange.toggle()
                    } else {
                        viewModel.cantChange.toggle()
                    }
                }.alert(isPresented: $viewModel.cantChange){
                    Alert(title: Text("select.player".trad()))
                }
                ZStack{
                    statb.fill(.pink)
                    Text("their.player".trad()).foregroundColor(.white)
                    
                }.clipped().onTapGesture {
                    viewModel.player = Player(name: "their.player".trad(), number: 0, team: 0,active:1, birthday: Date(), id: 0)
                }
                ZStack{
                    VStack {
//                        Text("rotation".trad()).font(.body)
//                        rot =
//                        let players: [Player] = viewModel.team.players()
                        Court(rotation: $viewModel.rotationArray, numberPlayers: viewModel.match.n_players, width: 90, height: 70)
                            .onTapGesture {
                                rotArray = viewModel.rotation.get(rotate: viewModel.rotationTurns).map{$0?.id ?? 0}
                                viewModel.showRotation = true
                            }

                    }
//                    Rectangle().fill(.clear)
                }
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
                            }.foregroundColor(.white).font(Font.body)
                        }.onTapGesture {
                            viewModel.player = player
                            print(viewModel.player?.name ?? "nil on tap")
                        }
                        .overlay(Image("Voleibol").scaleEffect(0.01, anchor: .center).opacity(player.id == viewModel.server ? 1 : 0).padding().offset(x: 40.0, y: -20.0))
                    }
                }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2))).padding(.trailing, 5).frame(maxWidth: sq*2)
                VStack {
                    Text("actions".trad()).font(.title3)
//                    Divider().overlay(.white).padding(.bottom)
                    HStack {
                        ForEach(actions, id:\.self){sub in
                            VStack{
                                ForEach(sub, id:\.id){action in
                                    if action.id != 38 && (viewModel.stage == action.stage || action.stage == -1){
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
                    
                }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)))
            }.padding()
        }
        .navigationTitle("capture".trad())
        .background(Color.swatch.dark.high).foregroundColor(.white)
//        .navigationBarBackButtonHidden(true)
        .toolbar{
            
            
        }
        .frame(maxHeight: .infinity)
        .overlay(showChange ? VStack{
            HStack{
                Button(action:{
                    showChange.toggle()
                    viewModel.clear()
                }){
                    Image(systemName: "multiply")
                }.padding().font(.title)
            }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(.blue)
            Text("pick.change".trad()).font(.title)
            ScrollView(.vertical){
                let p = viewModel.nonLineup()
                HStack{
                    let pr = p.count % 2 == 0 ? p.count : p.count + 1
                    VStack{
                        ForEach(p.prefix(pr/2), id:\.id){player in
                            ZStack{
                                statb.fill(.blue)
                                Text("\(player.name)").foregroundColor(.white)
                            }.onTapGesture {
                                showChange = false
//                                showChange.toggle()
                                print(viewModel.player?.name ?? "nil on change")
                                viewModel.changePlayer(change: player)
                                
                            }.frame(height: sq*2)
                        }
                    }.frame(maxHeight: .infinity, alignment: .top)
                    VStack{
                        ForEach(p.suffix(p.count/2), id:\.id){player in
                            
                            ZStack{
                                statb.fill(.blue)
                                Text("\(player.name)").foregroundColor(.white)
                            }.onTapGesture {
                                showChange = false
                                viewModel.changePlayer(change: player)

                            }.frame(height: sq*2)
                        }
                    }.frame(maxHeight: .infinity, alignment: .top)
                    
                }.padding(.vertical).frame(maxWidth: .infinity)
            }.padding().frame(maxWidth: .infinity)
            //#-learning-task(createDetailView)
        }.padding().background(.black).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxHeight: .infinity, alignment: .center).padding() : nil )
        .overlay(viewModel.showRotation ?
            VStack{
                HStack{
                    Button(action:{
                        viewModel.rotation = viewModel.lastStat?.rotation ?? viewModel.set.rotation
                        viewModel.showRotation.toggle()
                        
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white.opacity(0.1))
                    VStack{
                        Text("modify.rotation".trad()).font(.title).padding()
                        Spacer()
                        Court(rotation: $viewModel.rotationArray, numberPlayers: viewModel.match.n_players, editable: true, teamPlayers: viewModel.team.activePlayers())
                        Button(action:{
                            viewModel.rotate()
                            rotArray = viewModel.rotation.get(rotate: viewModel.rotationTurns).map{$0?.id ?? 0}
                        }){
                            HStack{
                                Text("rotate".trad()).font(.body).foregroundColor(.white)
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }.padding()
                        }.border(.white, width: 3).padding()
                        Spacer()
                    }
                }.padding()
                Spacer()
                ZStack{
                    statb.fill(.blue)
                    Text("save".trad()).foregroundColor(.white).font(.body)
                    
                }.clipped().onTapGesture {
                    viewModel.rotation = Rotation.create(rotation: Rotation(team: viewModel.team, rotationArray: viewModel.rotationArray))!
                    if viewModel.server != 0{
                        viewModel.server = viewModel.rotation.one!.id
                    }
//                    viewModel.players()
                    viewModel.rotationTurns = 0
                    viewModel.saveAdjust()
                }.frame(maxHeight: 100).padding()
                Spacer()
        }.padding().background(.black).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxHeight: .infinity, alignment: .center).padding()
            //#-learning-task(createDetailView)
                 : nil)
        .overlay(viewModel.hasActionDetail() ? detailModal() : nil)
        .overlay(viewModel.adjust ? adjustmentModal() : nil)
        .overlay(viewModel.showTimeout ? timeOutModal() : nil)
        .font(.custom("stats", size: 12))
        .onDisappear(perform: {
            viewModel.updateSet()
        })
        .onAppear(perform: {
            viewModel.players()
        })
        
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
                        viewModel.server = viewModel.lastStat?.server ?? 0
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
                            viewModel.server = viewModel.rotation.one!.id
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
                            viewModel.server = 0
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
}

class CaptureModel: ObservableObject{
    @Published var point_us: Int = 0
    @Published var point_them: Int = 0
    @Published var action: Action? = nil
    @Published var player: Player? = nil
    @Published var rotation: Rotation
    @Published var rotationTurns: Int = 0
    @Published var serve: Int
    @Published var server: Int = 0
    @Published var detail: String = ""
    @Published var timeOuts: (Int, Int) = (0,0)
//    @Published var showChange: Bool = false
    @Published var showRotation: Bool = false
    @Published var lineupPlayers: [Player] = []
    @Published var cantChange: Bool = false
    @Published var adjust: Bool = false
    @Published var showTimeout: Bool = false
    @Published var rotationCount: Int
    @Published var stage: Int = 0
    @Published var rotationArray:[Player?]=[nil, nil, nil, nil, nil, nil]
    var lastStat: Stat?
    let team: Team
    let match: Match
    var set: Set
        let appPilot: UIPilot<AppRoute>
    init(pilot: UIPilot<AppRoute>, team: Team, match: Match, set: Set){
        self.match = match
        self.team = team
        self.set = set
        self.appPilot = pilot
        let stats = set.stats().filter{s in return s.action != 0}
        if (stats.isEmpty){
            rotation = set.rotation
            serve = set.first_serve
            stage = set.first_serve == 1 ? 0 : 1
            server = set.first_serve == 1 ? set.rotation.one!.id : 0
            rotationCount = 1
        }else{
            lastStat = stats.last
            rotation = lastStat!.rotation
            point_us = lastStat?.score_us ?? 0
            point_them = lastStat?.score_them ?? 0
            rotationCount = lastStat!.rotationCount
            rotationTurns = lastStat!.rotationTurns
            if lastStat?.stage == 0 {
                if lastStat?.to == 2 {
                    serve = 2
                    server = 0
                }else{
                    serve = 1
                    server = lastStat?.server ?? 0
                }
            } else {
                if lastStat?.to == 1 {
                    serve = 1
                    rotate()
                    server = rotation.server(rotate: rotationTurns).id
                }else{
                    serve = 2
                    server = 0
                }
            }
            stage = serve == 1 ? 0 : 1
            
            
        }
        rotationArray = rotation.get(rotate: rotationTurns)
        players()
        self.timeOuts = set.timeOuts()
    }
    func updateSet(){
        set.score_us = point_us
        set.score_them = point_them
        let id = set.update()
        if id {
            //            print("updated")
        }
    }
    func nonLineup() -> [Player]{
        return team.activePlayers().filter{p in return !rotation.get().contains(p) && !set.liberos.contains(p.id)}
    }
    func timeOut(to: Int){
        let stat = Stat.createStat(stat: Stat(match: self.match.id, set: self.set.id, player: 0, action: 0, rotation: rotation, rotationTurns: rotationTurns, rotationCount: rotationCount, score_us: point_us, score_them: point_them, to: to, stage: serve == 1 ? 0 : 1, server: server, player_in: nil, detail: ""))
       
        if stat != nil {
            lastStat = stat
            self.timeOuts = set.timeOuts()
        }
    }
    func saveAdjust(){
        let stat = Stat.createStat(stat: Stat(match: self.match.id, set: self.set.id, player: 0, action: 98, rotation: rotation, rotationTurns: rotationTurns, rotationCount: rotationCount, score_us: point_us, score_them: point_them, to: 0, stage: serve == 1 ? 0 : 1, server: server, player_in: nil, detail: ""))
        if stat != nil {
            lastStat = stat
            adjust = false
            showRotation = false
            players()
        }
    }
    func changePlayer(change: Player){
//        let idx = self.rotation.get().firstIndex(of: self.player!)
        
            let stat = Stat.createStat(stat: Stat(match: self.match.id, set: self.set.id, player: self.player?.id ?? 0, action: 99, rotation: rotation, rotationTurns: rotationTurns, rotationCount: rotationCount, score_us: point_us, score_them: point_them, to: 0, stage: serve == 1 ? 0 : 1, server: server, player_in: change.id, detail: ""))
            if stat != nil {
                if self.server == self.player?.id ?? 0 && self.server != 0 {
                    server=change.id
                }
                let newr = self.rotation.changePlayer(player: self.player!, change: change)
                if newr != nil {
                    self.rotation = newr!
                    lastStat = stat
                    lineupPlayers = players()
                    rotationArray = rotation.get(rotate: rotationTurns)
                    self.clear()
                }else {
                    self.undo()
                }
                
                //            self.showChange.toggle()
            }
    }
    func hasActionDetail()->Bool{
        if self.player != nil && self.action != nil {
            return [15, 16, 17, 18, 19].contains(self.action!.id)
        }
        return false
    }
    func rotate(){
        self.rotationTurns = self.rotationTurns == match.n_players-1 ? 0 : self.rotationTurns+1
        self.rotationCount = self.rotationCount == match.n_players ? 1 : self.rotationCount+1
        rotationArray = rotation.get(rotate: rotationTurns)
//        let tmp = rotation[0]
//        for index in 1..<match.n_players{
//            rotation[index - 1] = rotation[index]
//        }
//        rotation[match.n_players-1] = tmp
    }
    func actionTap(action: Action){
        self.action = action
    }
    func clear(){
        self.action = nil
        self.player = nil
    }
    func undo(){
        var stats = self.set.stats()
        if !stats.isEmpty {
            var removed = stats.removeLast()
            lastStat = stats.last
            if lastStat != nil{
                point_us = removed.to == 1 ? removed.score_us - 1 : removed.score_us
                point_them = removed.to == 2 ? removed.score_them - 1 : removed.score_them
                rotation = removed.rotation
                self.server = removed.server
                serve = server == 0 ? 2 : 1
                stage = serve == 1 ? 0 : 1
                rotationCount = removed.rotationCount
                rotationTurns = removed.rotationTurns
                self.action = Action.find(id: removed.action)
                self.player = Player.find(id: removed.player)
                lineupPlayers = self.players()
            }else if stats.isEmpty {
                point_us = 0
                point_them = 0
                rotation = self.set.rotation
                rotationCount = 1
                rotationTurns = 0
                self.server = self.set.first_serve == 1 ? rotation.server(rotate: rotationTurns).id : 0
                serve = self.set.first_serve
                stage = serve == 1 ? 0 : 1
                self.action = Action.find(id: removed.action)
                self.player = removed.player == 0 ? Player(name: "Their player", number: 0, team: 0, active:1, birthday: Date(), id: 0) : Player.find(id: removed.player)
                lineupPlayers = self.players()
            }
            rotationArray = rotation.get(rotate: rotationTurns)
            removed.delete()
            self.timeOuts = set.timeOuts()
        }
    }
    func players() -> [Player]{
        var players: [Player] = []
        for p in rotation.get(){
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
        return players
    }
    func lineup() -> [Player]{
        var players: [Player] = []
        for p in rotation.get(rotate: self.rotationTurns){
//            let p = Player.find(id: n)
            if (p != nil){
                players.append(p!)
            }
        }
//        print(players.map{$0.number})
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
            let stat = Stat.createStat(stat: Stat(match: match.id, set: set.id, player: player?.id ?? 0, action: action?.id ?? 0, rotation: rotation, rotationTurns: rotationTurns, rotationCount: rotationCount, score_us: point_us, score_them: point_them, to: to, stage: serve == 1 ? 0 : 1, server: server, player_in: nil, detail: detail))
            if stat != nil {
                lastStat = stat
                detail=""
            }
            if(to != 0 && to != serve){
                if(serve == 1){
                    serve = 2
                    server = 0
                }else if (serve == 2){
                    serve = 1
                    rotate()
                    server = rotation.server(rotate: rotationTurns).id
                    rotationArray = rotation.get(rotate: rotationTurns)
                }
                stage = serve == 1 ? 0 : 1
            }
            clear()
        }
    }
}





