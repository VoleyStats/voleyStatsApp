import SwiftUI

struct SetStats: View {
    @ObservedObject var viewModel: SetStatsModel
    @Namespace var animation
    var body: some View {
        
        VStack {
//            Text("\(viewModel.tab.lowercased()).stats".trad()).font(.title.bold())
            HStack{
                TabButton(selection: $viewModel.tab, title: "match".trad(), animation: animation, action:{
                    viewModel.selectedSet = nil
                    viewModel.stats = viewModel.match.stats()
                })
//                TabButton(selection: $viewModel.tab, title: "Set", animation: animation, action:{})
                ForEach(viewModel.match.sets(), id:\.id){ set in
                    if set.first_serve != 0{
                        TabButton(selection: $viewModel.tab, title: "Set \(set.number)", animation: animation, action: {
                            viewModel.selectedSet = set
                            viewModel.stats = set.stats()
                        })
                    }
                }
                
            }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
            if viewModel.stats.isEmpty{
                EmptyState(icon: Image(systemName: "chart.bar.fill"), msg: "no.data.captured".trad(), width: 50, button:{EmptyView()})
            }else{
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
                                
                            }
                        }
                    }
                    ForEach(Array(actionsByType.keys).sorted(), id:\.self) {key in
                        let actions = actionsByType[key]
                        CollapsibleListElement(expanded: false, title: "\(key.trad().capitalized)"){
                            subviews[key, actions ?? [], viewModel]
                        }
                    }
                }
            }
        }.background(Color.swatch.dark.high)
            .navigationTitle("set.stats".trad())
            .onAppear{
                viewModel.stats = viewModel.set.stats()
            }
    }
    enum subviews {
        @ViewBuilder static subscript(string: String, actions:[Int], viewModel:SetStatsModel) -> some View {
            let players = viewModel.team.players()
            switch string {
            case "block":
                BlockTable(actions: actions , players: players, stats: viewModel.stats, historical: false)
            case "serve":
                ServeTable(actions: actions , players: players, stats: viewModel.stats, historical: false)
            case "dig":
                DigTable(actions: actions , players: players, stats: viewModel.stats, historical: false)
            case "fault":
                FaultTable(actions: actions , players: players, stats: viewModel.stats, historical: false)
            case "attack":
                AttackTable(actions: actions , players: players, stats: viewModel.stats, historical: false)
            case "set":
                SetTable(actions: actions , players: players, stats: viewModel.stats, historical: false)
            case "receive":
                ReceiveTable(actions: actions , players: players, stats: viewModel.stats, historical: false)
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


class SetStatsModel: ObservableObject{
    @Published var sourceMatch:Bool = false
    @Published var tab: String
    @Published var selectedSet: Set?
    @Published var stats: [Stat] = []
    var match: Match
    var set: Set
    var team: Team
    init(team: Team, match: Match, set: Set){
        self.match = match
        self.set = set
        self.team = team
        self.selectedSet = set
        self.tab = "Set \(set.number)"
//        self.stats = set.stats()
    }
}


