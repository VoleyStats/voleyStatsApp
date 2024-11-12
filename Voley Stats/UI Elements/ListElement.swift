import SwiftUI

struct ListElement: View{
    var team: Team
    var match: Match
    @ObservedObject var viewModel: ListTeamsModel
    @State var exportStats:Bool = false
    @State var clicked: Bool = false
    @State var deleting: Bool = false
    @State var activeRoot:Bool = false
    @State var subviewHeight : CGFloat = 0
//    @State var live: Bool = false
    var action: () -> Void
    var body: some View{
        VStack{
            
            ZStack{
                RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))
//                if match.pass && !team.pass{
//                    RoundedRectangle(cornerRadius: 15).stroke(.cyan, lineWidth: 1)
//                }
                HStack{
                    if viewModel.selectMatches {
                        if viewModel.reportMatches.contains(match) {
                            Image(systemName: "checkmark.square.fill").font(.title2)
                        }else{
                            Image(systemName: "square").font(.title2)
                        }
                        
                    } else if match.live {
                        Image(systemName: "dot.radiowaves.left.and.right").foregroundStyle(.red)
                    }
                    VStack(alignment: .leading){
                        Text("\(match.opponent)")
                        Text("\(match.location) @ \(match.getDate())").font(.caption).foregroundColor(.gray)
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                    HStack{
                        ForEach(match.sets(), id:\.id){set in
                            ZStack{
                                Circle().fill( .white.opacity(set.first_serve != 0 ? 1 : 0.1)).frame(maxWidth: 60, maxHeight: 60)
                                if set.first_serve != 0{
                                    NavigationLink(destination: AnyView(StatsView(viewModel: StatsViewModel(team: team, match: match, set: set))))
                                    {
                                        
                                        Text("\(set.score_us)-\(set.score_them)").foregroundColor(.black).font(.custom("", size: 11))
                                    }
                                }else{
                                    
                                    NavigationLink(destination: AnyView(SetData(viewModel: SetDataModel(team: team, match: match, set: set))))
                                    {
                                        
                                        Image(systemName: "arrowtriangle.right.circle").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 60, maxHeight: 60).foregroundColor(.cyan)//.font(.headline)
                                        
                                        
                                    }
                                }
                            }//.frame(maxWidth: 60, maxHeight: 60)
                        }
                        
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: clicked ? "chevron.down" : "chevron.right").padding(.horizontal).onTapGesture {
                        action()
                        withAnimation{
                            clicked.toggle()
                        }
                    }.foregroundColor(.white).frame(width: 40, height: 40)
                }
                .padding()
                .alert("match.delete".trad() + " vs " + match.opponent, isPresented: $deleting) {
                    HStack{
                        Button("match.delete".trad(), role: .destructive) {
                            viewModel.deleteMatch(match: match)
                        }
                        Button("cancel".trad(), role: .cancel) { }
                    }
                } message: {
                    Text("match.delete.description".trad()).padding()
                }
//                .confirmationDialog("match.delete.description".trad(), isPresented: $deleting, titleVisibility: .visible){
//                    Button("match.delete".trad(), role: .destructive){
//                        viewModel.deleteMatch(match: match)
//                    }
//                }
            }
            .onTapGesture {
//                print(match.id)
                action()
                if !viewModel.selectMatches{
                    clicked.toggle()
                }
            }
            .frame(height: 60)
            if clicked{
                VStack{
                    HStack{
                        NavigationLink(destination: MatchStats(viewModel: MatchStatsModel(team: team, match: match))){
                            HStack{
                                Image(systemName: "chart.bar.fill").padding(.trailing)
                                Text("match.stats".trad())
                            }.padding().frame(maxWidth: .infinity).background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Button(action:{
                            if match.pass{
                                viewModel.reportLang.toggle()
                            }
                        }){
                            Image(systemName: match.pass ? "square.and.arrow.up" : "lock.fill").padding(.trailing)
                            Text("export.stats".trad())
                        }.padding().frame(maxWidth: .infinity).background(match.pass ? .white.opacity(0.05) : .gray.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundStyle(match.pass ? .white : .gray)
                    }
                    HStack{
//                        Switch(isOn: $match.live, isOnIcon: Image(systemName: "dot.radiowaves.left.and.right"), isOffIcon: Image(systemName: "network.slash"), buttonColor: .cyan, backgroundColor: .white.opacity(0.1))
                        NavigationLink(destination: MatchData(viewModel: MatchDataModel(team: team, match: match))){
                            HStack{
                                Image(systemName: "square.and.pencil").padding(.trailing)
                                Text("edit.match".trad())
                            }
                        }.padding().frame(maxWidth: .infinity).background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button(action:{
                        deleting.toggle()
                    }){
                        HStack{
                            Image(systemName: "trash.fill").padding(.trailing)
                            Text("match.delete".trad())
                        }.foregroundStyle(.red).frame(maxWidth: .infinity)
                    }.padding().background(.red.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    
                }.padding([.horizontal, .top]).frame(maxWidth: .infinity)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .foregroundColor(.white)
        
        .padding(.horizontal, 10)
        .padding(.vertical)
        
    }
    
}
