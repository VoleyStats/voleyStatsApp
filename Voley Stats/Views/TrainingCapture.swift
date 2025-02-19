import SwiftUI

struct TrainingCapture: View {
    @ObservedObject var viewModel: TrainingCaptureModel
    var sq: CGFloat = 90
    let actions: [[Action]] = Action.all()
    let statb = RoundedRectangle(cornerRadius: 15, style: .continuous)
    var body: some View {
        VStack {
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
                    ForEach(viewModel.team.activePlayers().sorted(by: { $0.number < $1.number }), id:\.id){player in
                        ZStack{
                            statb.stroke(viewModel.player?.id == player.id ? .white : .clear, lineWidth: 3).background(statb.fill(.blue))
                            VStack {
                                Text("\(player.number)")
                                Text("\(player.name)")
                            }.foregroundColor(.white).font(Font.body)
                        }.onTapGesture {
                            viewModel.player = player
                        }
                    }
                }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2))).padding(.trailing, 5).frame(maxWidth: sq*2)
                VStack {
                    Text("actions".trad()).font(.title3)
//                    Divider().overlay(.white).padding(.bottom)
                    HStack {
                        ForEach(actions, id:\.self){sub in
                            VStack{
                                ForEach(sub, id:\.id){action in
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
                    
                }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)))
            }.padding()
        }
        .navigationTitle("capture.training".trad())
        .background(Color.swatch.dark.high).foregroundColor(.white)
        .toast(show: $viewModel.showToast, Toast(show: $viewModel.showToast, type: viewModel.type, message: viewModel.message))
        .frame(maxHeight: .infinity)
        .overlay(viewModel.hasActionDetail() ? detailModal() : nil)
        .font(.custom("stats", size: 12))
        
        
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
}

class TrainingCaptureModel: ObservableObject{
    @Published var action: Action? = nil
    @Published var player: Player? = nil
    @Published var detail: String = ""
    @Published var message: String = ""
    @Published var type: ToastType = .info
    @Published var showToast: Bool = false
    var lastStat: Stat?=nil
    let team: Team
    init(team: Team){
        self.team = team
    }
    func makeToast(type: ToastType, message: String){
        self.message = message
        self.type = type
        self.showToast = true
    }
    func hasActionDetail()->Bool{
        if self.player != nil && self.action != nil {
            return [15, 16, 17, 18, 19].contains(self.action!.id)
        }
        return false
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
        detail=""
    }
    func undo(){
        var stats = team.stats()
        if !stats.isEmpty {
            var removed = stats.removeLast()
            if stats.last != nil{
                
                self.action = Action.find(id: removed.action)
                self.player = Player.find(id: removed.player)
                
            }else if stats.isEmpty {
            
                self.action = Action.find(id: removed.action)
                self.player = removed.player == 0 ? Player(name: "Their player", number: 0, team: 0, active:1, birthday: Date(), id: 0) : Player.find(id: removed.player)
                
            }
            
            removed.delete()
        }
    }
//    func players() -> [Player]{
//        var players=team.activePlayers()
//        return players
//    }
    
    func saveAction() {
        if (player != nil && action != nil){
            let stat = Stat.createStat(stat: Stat(player: self.player!.id, action: self.action!.id, detail: self.detail, date: Date(), direction: ""))
            if stat != nil {
                clear()
            }

        }
    }
}





