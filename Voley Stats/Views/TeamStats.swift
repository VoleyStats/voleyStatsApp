//
//  ListMatches.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 23/5/23.
//

import SwiftUI
import Charts

struct TeamStats: View {
    var team:Team
    @State var startDate:Date
    @State var endDate:Date
    @State var matches:[Match] = []
    @State var tournaments:[Tournament] = []
    @State var player:Player? = nil
    @State var match:Int = 0
    @State var tournament:Int = 0
    @State var showFilterbar: Bool = false
    @State var teamStats:Dictionary<String,Dictionary<String,Int>>=[:]
    @State var serveHistory: [(Color, [(String, Double)], String)] = []
    @State var receiveHistory: [(Color, [(String, Double)], String)] = []
    @State var attackHistory: [(Color, [(String, Double)], String)] = []
    @State var directions: [Stat] = []
    @State var loading: Bool = false
    @State var league: Bool = true
    @State var representation: Int = 0
//    @State var

    
    init(team:Team){
        self.team = team
//        self._showFilterbar = showFilterbar
        self.startDate = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? Date()
        self.endDate = .now
//        self.statsType = 1
//        self.teamStats = team.fullStats(startDate: self.startDate, endDate: self.endDate)
    }
    
    
    var body: some View {
        if self.team.pass{
            VStack{
                VStack{
                    HStack{
                        if !showFilterbar{
                            HStack{
                                Image(systemName: "number").padding().background(.white.opacity(representation == 0 ? 0.1 : 0)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundStyle(representation == 0 ? .cyan : .white).onTapGesture {
                                    representation = 0
                                }
                                Image(systemName: "chart.xyaxis.line").padding().background(.white.opacity(representation == 1 ? 0.1 : 0)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundStyle(representation == 1 ? .cyan : .white).onTapGesture {
                                    representation = 1
                                }
//                                Image(systemName: "arrow.up.left.arrow.down.right").padding().background(.white.opacity(representation == 2 ? 0.1 : 0)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundStyle(representation == 2 ? .cyan : .white).onTapGesture {
//                                    representation = 2
//                                }
                            }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)
                        }
                        HStack{
                            Image(systemName: showFilterbar ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                .font(.title3).frame(maxWidth: .infinity, alignment: .trailing).foregroundStyle(showFilterbar ? .cyan : .white)
                            
                            if !showFilterbar{
                                Text("filter".trad())//.font(.caption)
                            }
                        }.padding(.horizontal).onTapGesture{
                            withAnimation{
                                showFilterbar.toggle()
                            }
                        }
                    }
                    if self.showFilterbar{
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    Text("player".trad().uppercased()).font(.caption)
                                    //                                Picker("stats.by.type".trad(), selection: self.$player){
                                    //                                    Text("pick.one".trad()).tag(0)
                                    //                                    ForEach(team.players(), id: \.id){player in
                                    //                                        Text(player.name).tag(player.id)
                                    //                                    }
                                    //                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                    Dropdown(selection: $player, items: team.players())
                                }.padding().frame(maxWidth: .infinity, alignment: .leading)
                                VStack(alignment: .leading){
                                    Text("match".trad().uppercased()).font(.caption)
                                    //                                Picker("stats.by.type".trad(), selection: self.$match){
                                    //                                    Text("pick.one".trad()).tag(0)
                                    //                                    ForEach(team.matches(), id: \.id){match in
                                    //                                        Text(match.opponent).tag(match.id)
                                    //                                    }
                                    //                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).disabled(self.tournament != 0)
                                    Dropdown(selection: $matches, items: tournaments.isEmpty ? team.matches() : tournaments.flatMap{$0.matches()})
                                }.padding().frame(maxWidth: .infinity, alignment: .leading)
                                VStack(alignment: .leading){
                                    Text("tournament".trad().uppercased()).font(.caption)
                                    //                                Picker("stats.by.type".trad(), selection: self.$tournament){
                                    //                                    Text("pick.one".trad()).tag(0)
                                    //                                    ForEach(team.tournaments(), id: \.id){tournament in
                                    //                                        Text(tournament.name).tag(tournament.id)
                                    //                                    }
                                    //                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).disabled(self.match != 0)
                                    Dropdown(selection: $tournaments, items: team.tournaments())
                                }.padding().frame(maxWidth: .infinity, alignment: .leading)
                            }.zIndex(1)
                            
                            Toggle("league.matches".trad(), isOn: self.$league).tint(.cyan).padding().disabled(!tournaments.isEmpty)
                            VStack(alignment: .leading){
                                Text("date.range".trad().uppercased()).font(.caption).padding(.horizontal)
                                HStack{
                                    VStack(alignment: .leading){
                                        Text("start.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading)
                                        DatePicker("start.date".trad(), selection: self.$startDate, in: ...Date.now, displayedComponents: .date).labelsHidden().disabled(self.match != 0 || self.tournament != 0)
                                    }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                                    VStack(alignment: .leading){
                                        Text("end.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                                        DatePicker("end.date".trad(), selection: self.$endDate, in: ...Date.now, displayedComponents: .date).labelsHidden().disabled(self.match != 0 || self.tournament != 0)
                                    }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)
                            }
                            
                            HStack{
                                Text("reset".trad()).padding().foregroundStyle(.cyan).frame(maxWidth: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    self.matches = []
                                    self.tournaments = []
                                    self.player = nil
                                    self.startDate = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? Date()
                                    self.endDate = .now
                                }
                                Text("filter".trad()).padding().frame(maxWidth: .infinity).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    self.loading = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        loadData()
                                        withAnimation(.easeIn){
                                            self.showFilterbar.toggle()
                                        }
                                    }
                                }
                            }.padding()
                        }
                    }
                }.padding(showFilterbar ? 10 : 5).background(showFilterbar ? .white.opacity(0.1) : .clear).clipShape(RoundedRectangle(cornerRadius: 8)).padding(showFilterbar ? 20 : 0)
                
                if loading{
                    VStack{
                        ProgressView().tint(.white)
                        Text("LOADING...").font(.caption).padding()
                    }.frame(maxHeight: .infinity)
                } else{
                    ScrollView{
                        LazyVStack{
                            if representation == 1{
                                LineChartView(title:"serve.historical.stats", dataPoints: self.serveHistory)
                                
                                LineChartView(title: "receive.historical.stats", dataPoints: self.receiveHistory)
                                
                                LineChartView(title: "atk.historical.stats", dataPoints: self.attackHistory)
                            }
                            if representation == 0 {
                                LazyVGrid(columns:[GridItem(.adaptive(minimum: 250))], spacing: 20){
                                    //                        let teamStats = team.fullStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, statsType: statsType)
                                    ForEach(Array(self.teamStats.keys.sorted()), id:\.self){area in
                                        let data = self.teamStats[area]!
                                        PieChart(title: area.trad().capitalized, total: data["total"]!, error: data["error"]!, earned: data["earned"]!, size: 175)
                                    }
                                }
                            }
                            if representation == 2 {
                                VStack{
                                    Text("direction.detail".trad()).font(.title2).padding(.bottom)
                                    HStack{
                                        HStack{
                                            
                                            DirectionsGraph(viewModel: DirectionsGraphModel(title: "attack".trad().capitalized, stats: self.directions.filter{[9, 10, 11].contains($0.action) && $0.player != 0 && $0.direction.contains("#")}.map{s in (s.direction, Double(self.directions.filter{$0.direction == s.direction}.count))}, isServe: false, heatmap: false, colorScale: false, numberPlayers: 6, width: 200, height: 400)).padding(.horizontal)
                                            
                                        }
                                        HStack{
                                            
                                            DirectionsGraph(viewModel: DirectionsGraphModel(title: "serve".trad().capitalized, stats: self.directions.filter{[8, 39, 40, 41].contains($0.action) && $0.player != 0 && $0.direction.contains("#")}.map{s in (s.direction, Double(self.directions.filter{$0.direction == s.direction}.count))}, isServe: true, heatmap: false, colorScale: false, numberPlayers: 6, width: 200, height: 400)).padding(.horizontal)
                                            //                                        VStack{
                                            //                                            VStack{
                                            //                                                Text("ace".trad())
                                            //                                                Text(
                                            //                                            }
                                            //                                        }
                                        }
                                        
                                    }.frame(maxWidth: .infinity)
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
                                VStack{
                                    Text("heatmap.detail".trad()).font(.title2).padding(.bottom)
                                    HStack{
                                        HStack{
                                            DirectionsGraph(viewModel: DirectionsGraphModel(title: "dig".trad().capitalized, stats: self.directions.filter{[23].contains($0.action) && $0.player != 0 && $0.direction.contains("#")}.map{s in (s.direction, Double(self.directions.filter{$0.direction == s.direction}.count))}, isServe: false, heatmap: true, colorScale: false, numberPlayers: 6, width: 200, height: 400)).padding(.horizontal)
                                            //                                        Text("dig".trad().capitalized)
                                        }
                                        HStack{
                                            
                                            DirectionsGraph(viewModel: DirectionsGraphModel(title:"receive".trad().capitalized, stats: self.directions.filter{[1, 2, 3, 4, 22].contains($0.action) && $0.player != 0 && $0.direction.contains("#")}.map{s in (s.direction, Stat.getMark(stats: self.directions.filter{$0.direction == s.direction}, serve: false))}, isServe: true, heatmap: true, colorScale: true, numberPlayers: 6, width: 200, height: 400)).padding(.horizontal)
                                            //                                        Text("receive".trad().capitalized)
                                        }
                                    }.frame(maxWidth: .infinity)
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
                            }
                            //                        if statsType != 0{
                            
                            //                        }
                        }.frame(maxWidth: .infinity, alignment: .center)
                        
                        
                    }
                }
            }.onAppear{
                self.loading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    loadData()
                }
            }
        }else{
            VStack{
                Image(systemName: "ticket.fill").resizable().aspectRatio(contentMode: .fit).rotationEffect(.degrees(-20)).frame(width: 200).foregroundStyle(.cyan).padding()
                Text("feature.for.team.pass".trad()).padding(.top)
                Text("buy.pass".trad()).foregroundStyle(.cyan)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        //.background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(.white.opacity(0.1)))
    }
    
    func loadData() {
//        let player = Player.find(id: self.player)
        var startDate:Date? = self.startDate
        var endDate:Date? = self.endDate
//        self.matches = []
        if !self.matches.isEmpty || !self.tournaments.isEmpty{
//            self.matches = [Match.find(id: self.match)!]
            startDate = nil
            endDate = nil
        }//else
        if self.league{
            self.matches = self.team.matches().filter{$0.league}
            startDate = nil
            endDate = nil
        }
//        self.tournaments = []
//        if self.tournament != 0 {
//            self.tournaments = [Tournament.find(id: self.tournament)!]
//            startDate = nil
//            endDate = nil
//        }
        
        self.teamStats = team.fullStats(startDate: startDate, endDate: endDate, matches: self.matches, tournaments: self.tournaments, player: player)
        
        self.serveHistory = [
            (.blue, team.historicalStats(startDate: startDate, endDate: endDate, actions: [8], matches: self.matches, tournaments: self.tournaments, player: player), "ace"),
            (.red, team.historicalStats(startDate: startDate, endDate: endDate, actions: [15], matches: self.matches, tournaments: self.tournaments, player: player), "errors")]
        
        let err = team.historicalStats(startDate: startDate, endDate: endDate, actions: [22], matches: self.matches, tournaments: self.tournaments, player: player)
        let rcv1 = team.historicalStats(startDate: startDate, endDate: endDate, actions: [2], matches: self.matches, tournaments: self.tournaments, player: player)
        let rcv2 = team.historicalStats(startDate: startDate, endDate: endDate, actions: [3], matches: self.matches, tournaments: self.tournaments, player: player)
        let rcv3 = team.historicalStats(startDate: startDate, endDate: endDate, actions: [4], matches: self.matches, tournaments: self.tournaments, player: player)
        self.receiveHistory = [(.red, err, "errors"), (.orange, rcv1, "1-"+"receive".trad()), (.yellow, rcv2, "2-"+"receive".trad()), (.green, rcv3, "3-"+"receive".trad())]
        
        let kills = team.historicalStats(startDate: startDate, endDate: endDate, actions: [6,9,10,11], matches: self.matches, tournaments: self.tournaments, player: player)
        let atkErr = team.historicalStats(startDate: startDate, endDate: endDate, actions: [16,17,18,34], matches: self.matches, tournaments: self.tournaments, player: player)
        self.attackHistory = [(.red, atkErr, "errors"), (.green, kills, "kills")]
        self.directions = team.stats(startDate: startDate, endDate: endDate, matches: self.matches, tournaments: self.tournaments, player: player).filter{$0.direction.contains("#")}
        self.loading = false
    }
}
