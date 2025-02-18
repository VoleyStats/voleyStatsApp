import SwiftUI
import Charts

struct PointLog: View {
    @ObservedObject var viewModel: PointLogModel
    @State var height: CGFloat = 0
    var body: some View {
        VStack {
            HStack{
                Toggle("show.game.graph".trad(), isOn: $viewModel.gameGraph).padding().tint(.cyan)
                
            }
            if (viewModel.fullLog.isEmpty) || (viewModel.finals && viewModel.finalsLog.isEmpty){
                    EmptyState(icon: Image(systemName: "doc.text.fill"), msg: "no.data.captured".trad(), width: 120, button:{EmptyView()})
            } else {
                if viewModel.gameGraph {
                    VStack{
                        HStack{
                            Text("to".trad()).frame(width: 30, alignment: .center)
                            Text("player".trad()).frame(width: 50, alignment: .center)
                            Text("action".trad()).frame(maxWidth: .infinity, alignment: .leading)
                            Text("them".trad()).frame(width: 200, alignment: .center)
                            Text("us".trad()).frame(width: 200, alignment: .center)
                            HStack{}.frame(width: 50)
                            
                        }.padding().background(.white.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 15))
                        ScrollView{
                            ForEach(viewModel.finalsLog, id: \.id){stat in
                                let diff = stat.score_us - stat.score_them
                                HStack{
                                    Text("\(stat.to == 1 ? "+" : "-")").foregroundStyle(stat.to == 1 ? .blue : .red).frame(width: 30, alignment: .center)
                                    Text("\(Player.find(id: stat.player)?.number.description ?? "them".trad())").frame(width: 50, alignment: .center)
                                    Text("\(Action.find(id: stat.action)?.shortName() ?? "error")").frame(maxWidth: .infinity, alignment: .leading)
                                    HStack{
                                        if diff < 0{
                                            RoundedRectangle(cornerRadius: 8).fill(.red).frame(width: CGFloat(abs(diff)*200/25), height: 20)
                                        }
                                    }.frame(width:200, alignment: .trailing)
                                    Divider().overlay(.white)
                                    HStack{
                                        if diff > 0{
                                            RoundedRectangle(cornerRadius: 8).fill(.green).frame(width: CGFloat(abs(diff)*200/25), height: 20)
                                        }
                                    }.frame(width: 200, alignment: .leading)
                                    Text("\(stat.score_them)-\(stat.score_us)").frame(width: 50)
                                    
                                }.padding(.horizontal)
                            }
                        }.padding(.bottom)
                    }.background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
                }else{
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.3))
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 20){
                                HStack{
                                    Image(systemName: "arrow.up.arrow.down").symbolRenderingMode(.palette).foregroundStyle(.cyan, .white).rotationEffect(.degrees(viewModel.descending ? 180 : 0)).animation(.easeInOut, value: viewModel.descending).onTapGesture {
                                        withAnimation{
                                            viewModel.descending.toggle()
                                        }
                                    }.padding(.horizontal)
                                    Text("stage".trad())
                                }
                                Text("server".trad())
                                Text("player".trad())
                                Text("action.type".trad())
                                Text("action".trad())
                                Text("score".trad())
                            }.padding([.vertical, .trailing])
                        }.clipped().frame(maxHeight: 20).padding(.vertical)
                        ScrollView {
                            ForEach(viewModel.finals ? viewModel.finalsLog : viewModel.fullLog.sorted(by: viewModel.descending ? { $0.order > $1.order } : { $0.order < $1.order }), id:\.id){ stat in
                                if(stat.action == 0){
                                    HStack(spacing: 20){
                                        Text("time.out.by".trad()+(stat.to == 1 ? "us".trad() : "them".trad())).frame(maxWidth: .infinity)
                                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)
                                }else if (stat.action == 99){
                                    HStack{
                                        HStack(spacing: 20){
                                            Text("change.player".trad())
                                            Image(systemName: "arrow.up.circle.fill").foregroundColor(.green)
                                            Text("\(Player.find(id: stat.player_in ?? 0)?.name ?? "")")
                                            Image(systemName: "arrow.down.circle.fill").foregroundColor(.red)
                                            Text("\(Player.find(id: stat.player)?.name ?? "")")
                                        }.frame(maxWidth: .infinity)
                                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)
                                }else if (stat.action == 98){
                                    HStack(spacing: 20){
                                        Text("score.adjust".trad()).frame(maxWidth: .infinity)
                                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)
                                }else{
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 20){
                                        let action = Action.find(id: stat.action)!
                                        Text("\(stat.stage == 0 ? "K2" : stat.stage == 1 ? "K1" : "K3")")
                                        Text("\(stat.server.id == 0 ? "their.player".trad() : stat.server.name)")
                                        Text("\(stat.player == 0 ? "their.player".trad() : Player.find(id: stat.player)?.name ?? "")")
                                        Text("\(action.getType().trad().capitalized)")
                                        Text("\(action.name.trad())\(stat.detail != "" ? " ["+stat.detail.lowercased().trad()+"]" : "")")
                                        Text("\(stat.score_us)-\(stat.score_them)")
                                        
                                    }.padding().background(stat.to == 0 ? .white.opacity(0.1) : stat.to == 1 ? .blue.opacity(0.1) : .red.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)
                                }
                            }
                        }
                    }.background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
                }
            }
        }
        .onAppear{
            viewModel.obtainLog()
        }.padding()
            .background(Color.swatch.dark.high)
            .navigationTitle("point.log".trad())
        
    }
}
class PointLogModel: ObservableObject{
    @Published var fullLog: [Stat] = []
    @Published var finalsLog: [Stat] = []
    @Published var finals:Bool = false
    @Published var gameGraph:Bool = false
    @Published var gameGraphData:[(Int, String, Int, CGFloat)] = []
    @Published var descending:Bool = true
    var x:CGFloat = 0
    var mid:CGFloat = 0
    var set:Set
    init(set: Set, gameGraph: Bool = false){
        self.set = set
        self.gameGraph = gameGraph
    }
    func obtainLog(){
        fullLog = set.stats()
        var order = 1.0
        if fullLog.first?.order ?? 0 == 0{
            fullLog.forEach{s in
                s.order = order
                if s.update(){
                    order += 1
                }
            }
        }
        finalsLog = fullLog.filter{s in return s.to != 0 && ![98, 99, 0].contains(s.action)}
//        print(finalsLog.map{$0.description})
    }
    
//    func incrementX(_ by: Int){
//        print(by)
//        self.x += by
//    }
//    func decrementX(_ by: Int){
//        self.x -= by
//    }
}


