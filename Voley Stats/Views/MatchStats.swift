import SwiftUI

struct MatchStats: View {
    @ObservedObject var viewModel: MatchStatsModel
    @Namespace var animation
    @Namespace var subanimation
    var body: some View {
        
        VStack {
            HStack{
                TabButton(selection: $viewModel.tab, title: "match".trad(), animation: animation, action: {
                    viewModel.selectedSet = nil
                    viewModel.stats = viewModel.match.stats()
                })
                ForEach(viewModel.match.sets(), id:\.id){ s in
                    if s.first_serve != 0{
                        TabButton(selection: $viewModel.tab, title: "Set \(s.number)", animation: animation, action: {
                            viewModel.selectedSet = s
                            viewModel.historical = false
                            viewModel.stats = s.stats()
                            viewModel.subtab = "stats".trad()
                        })
                    }
                }
                
            }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
            if viewModel.stats.isEmpty{
                EmptyState(icon: Image(systemName: "chart.bar.fill"), msg: "no.data.captured".trad(), width: 50, button:{EmptyView()})
            }else{
                if viewModel.tab != "match".trad(){
                    HStack{
                        TabButton(selection: $viewModel.subtab, title: "stats".trad(), animation: subanimation, action: {})
                        TabButton(selection: $viewModel.subtab, title: "point.log".trad(), animation: subanimation, action: {})
                    }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding(.horizontal)
                }
                if viewModel.subtab == "stats".trad() || viewModel.selectedSet == nil{
                    ScrollView{
                        CollapsibleListElement(expanded: true, title: "General"){
                            subviews["general", [], viewModel]
                        }
                        if viewModel.tab == "match".trad(){
                            CollapsibleListElement(expanded: false, title: "rotation".trad()){
                                subviews["rotation", [], viewModel]
                            }
                            if false{//viewModel.match.n_players == 6{
                                CollapsibleListElement(expanded: false, title: "direction.detail".trad()){
                                        HStack{
                                            VStack{
                                                let dirs = viewModel.stats.filter{[9, 10, 11].contains($0.action) && $0.player != 0 && $0.direction.contains("#")}
                                                DirectionsGraph(viewModel: DirectionsGraphModel(title: "attack".trad().capitalized, stats: dirs.map{s in (s.direction, Double(viewModel.stats.filter{$0.direction == s.direction}.count))}, isServe: false, heatmap: false, colorScale: false, numberPlayers: 6, width: 200, height: 400)).padding(.horizontal)
                                               
                                            }
                                            VStack{
                                                let dirs = viewModel.stats.filter{[8, 39, 40, 41].contains($0.action) && $0.player != 0 && $0.direction.contains("#") }.map{s in (s.direction, Double(viewModel.stats.filter{$0.direction == s.direction}.count))}
                                                DirectionsGraph(viewModel: DirectionsGraphModel(title: "serve".trad().capitalized, stats: dirs, isServe: true, heatmap: false, colorScale: false, numberPlayers: 6, width: 200, height: 400)).padding(.horizontal)
                                                
                                            }
                                            
                                        }//.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxWidth: .infinity).padding()
                                }
                                CollapsibleListElement(expanded: false, title: "heatmap.detail".trad()){
                                        HStack{
                                            VStack{
                                                
                                                DirectionsGraph(viewModel: DirectionsGraphModel(
                                                    title:"dig".trad().capitalized,
                                                    stats: viewModel.stats.filter{[23].contains($0.action) && $0.player != 0 && $0.direction.contains("#")}
                                                        .map{s in (s.direction, Double(viewModel.stats.filter{$0.direction == s.direction}.count))},
                                                    isServe: false, heatmap: true, colorScale: false,
                                                    numberPlayers: 6,
                                                    width: 200,
                                                    height: 400)).padding(.horizontal)
                                            
                                            }
                                            VStack{
                                                
                                                DirectionsGraph(viewModel: DirectionsGraphModel(title: "receive".trad().capitalized, stats: viewModel.stats.filter{[1, 2, 3, 4, 22].contains($0.action) && $0.player != 0 && $0.direction.contains("#")}.map{s in (s.direction, Stat.getMark(stats: viewModel.stats.filter{$0.direction == s.direction}, serve: false))}, isServe: true, heatmap: true, colorScale: true, numberPlayers: 6, width: 200, height: 400)).padding(.horizontal)
                                                
                                            }
                                        }//.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxWidth: .infinity).padding()
                                    
                                }                            }
                        }
                        ForEach(Array(actionsByType.keys).sorted(), id:\.self) {key in
                            let actions = actionsByType[key]
                            CollapsibleListElement(expanded: false, title: "\(key.trad().capitalized)"){
                                subviews[key, actions ?? [], viewModel]
                            }.foregroundColor(.white)
                        }
                    }
                }else{
                    PointLog(viewModel: PointLogModel(set: viewModel.selectedSet!, gameGraph: true))
                }
                
            }
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle("\(viewModel.tab == "match".trad() ? "match.stats".trad() : "set.stats".trad())")
            .onAppear{
                viewModel.stats = viewModel.match.stats()
//                print(viewModel.stats.count)
            }
    }
    @ViewBuilder
    func matchStat() -> some View {
        
    }
    enum subviews {
        @ViewBuilder static subscript(string: String, actions:[Int], viewModel:MatchStatsModel) -> some View {
            
//            let stats =  viewModel.tab != "Match" ? viewModel.selectedSet?.stats() ?? viewModel.match.stats() : viewModel.match.stats()
            let players = viewModel.team.players()
            switch string {
            case "block":
                BlockTable(actions: actions , players: players, stats: viewModel.stats, historical: viewModel.historical)
            case "serve":
                ServeTable(actions: actions , players: players, stats: viewModel.stats, historical: viewModel.historical)
            case "dig":
                DigTable(actions: actions , players: players, stats: viewModel.stats, historical: viewModel.historical)
            case "fault":
                FaultTable(actions: actions , players: players, stats: viewModel.stats, historical: viewModel.historical)
            case "attack":
                AttackTable(actions: actions , players: players, stats: viewModel.stats, historical: viewModel.historical)
            case "set":
                SetTable(actions: actions , players: players, stats: viewModel.stats, historical: viewModel.historical)
            case "receive":
                ReceiveTable(actions: actions , players: players, stats: viewModel.stats, historical: viewModel.historical)
            case "free":
                FreeTable(actions: actions , players: players, stats: viewModel.stats, historical: false)
            case "downhit":
                DownBallTable(actions: actions , players: players, stats: viewModel.stats, historical: false)
            case "general":
                GeneralTable(stats: viewModel.stats, bests: viewModel.selectedSet == nil)
            case "rotation":
                RotationTable(match: viewModel.match)
            default:
                fatalError()
            }
        }
    }
}


class MatchStatsModel: ObservableObject{
    @Published var sourceMatch:Bool = false
    @Published var tab: String = "match".trad()
    @Published var subtab: String = "stats".trad()
    @Published var selectedSet: Set? = nil
    @Published var historical: Bool = false
    @Published var stats: [Stat] = []
    var match: Match
    var team: Team
    init(team: Team, match: Match){
        self.match = match
        self.team = team
//        self.stats = match.stats()
    }
}


