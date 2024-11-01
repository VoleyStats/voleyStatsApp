import SwiftUI
import UniformTypeIdentifiers

struct StatsView: View {
    @ObservedObject var viewModel: StatsViewModel
    @State var isDeep: Bool = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack{
            switch viewModel.selTab{
            case 1:
//                ZStack{
                    
                    AnyView(Capture(viewModel: CaptureModel(team: viewModel.team, match: viewModel.match, set: viewModel.set)))
//                    if viewModel.match.pass && Calendar.current.date(byAdding: .day, value: 7, to: viewModel.match.date) ?? .distantPast <= .now{
//                        Rectangle().fill(Color.swatch.dark.high.opacity(0.6))
//                    }
//                }
            case 2:
                AnyView(SetStats(viewModel: SetStatsModel(team: viewModel.team, match: viewModel.match, set: viewModel.set)))
            case 3:
                AnyView(PointLog(viewModel: PointLogModel(set: viewModel.set)))
            default:
                fatalError()
            }
            ZStack{
                Capsule().fill(.white.opacity(0.1))
                    .frame(maxHeight: 60)
                HStack{
                    ZStack{
                        Circle().fill(viewModel.selTab == 1 ? Color.swatch.cyan.base : .clear).frame(maxHeight: 80)
                        Button(action:{
                            withAnimation(.easeInOut){
                                if viewModel.selTab != 1{
                                    viewModel.selTab=1
                                }
                            }
                        }){
                            VStack{
                                Image(systemName: "hand.tap.fill")
                                if (viewModel.selTab != 1){
                                    Text("capture".trad())
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.foregroundColor(viewModel.selTab != 1 ? Color.swatch.cyan.base : .black)
                    ZStack{
                        Circle().fill(viewModel.selTab == 2 ? Color.swatch.cyan.base : .clear).frame(maxHeight: 80).transition(.scale)
                        Button(action:{
                            withAnimation(.easeInOut){
                                if viewModel.selTab != 2{
                                    viewModel.selTab=2
                                }
                            }
                        }){
                            VStack{
                                Image(systemName: "chart.bar.fill")
                                if (viewModel.selTab != 2){
                                    Text("stats".trad())
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.foregroundColor(viewModel.selTab != 2 ? Color.swatch.cyan.base : .black)
                    ZStack{
                        Circle().fill(viewModel.selTab == 3 ? Color.swatch.cyan.base : .clear).frame(maxHeight: 80)
                        Button(action:{
                            withAnimation(.easeInOut){
                                if viewModel.selTab != 3{
                                    viewModel.selTab=3
                                }
                            }
                        }){
                            VStack{
                                Image(systemName: "chart.bar.doc.horizontal")
                                if (viewModel.selTab != 3){
                                    Text("point.log".trad())
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.foregroundColor(viewModel.selTab != 3 ? Color.swatch.cyan.base : .black)
                }.frame(maxWidth: .infinity).padding()
            }.padding(.horizontal)
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                if viewModel.match.live {
                    
                    HStack{
                        if viewModel.match.code != "" && viewModel.selTab != 1{
                            HStack{
                                Text("share.live".trad())
                                if viewModel.match.pass{
                                    Image(systemName: "dot.radiowaves.left.and.right").foregroundStyle(.cyan)
                                        .onTapGesture{
                                            UIPasteboard.general.setValue("\(viewModel.match.code)", forPasteboardType: UTType.plainText.identifier)
                                            viewModel.showToast = true
                                        }
                                }else{
                                    Image(systemName: "lock.fill")
                                }
                            }.font(.caption).padding(.vertical, 10).padding(.horizontal).background(viewModel.match.pass ? .white.opacity(0.1) : .gray.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundStyle(viewModel.match.pass ? .white : .gray)
                        }
                            NavigationLink(destination: CaptureHelp()){
                                Image(systemName: "questionmark.circle").font(.title3)
                            }
                        
                    }
                } else{
                    HStack{
                        NavigationLink(destination: FillStats(viewModel: FillStatsModel(team: viewModel.team, match: viewModel.match, set: viewModel.set))){
                            HStack{
                                Text("fill.stats".trad())
                                if viewModel.match.pass{
                                    Image(systemName: "plus.square.fill.on.square.fill")
                                }else{
                                    Image(systemName: "lock.fill")
                                }
                            }.font(.caption).padding(10).background(viewModel.checkStats() ? .gray.opacity(0.2) : .cyan).clipShape(RoundedRectangle(cornerRadius: 8))
                        }.disabled(viewModel.checkStats()).foregroundStyle(viewModel.checkStats() ? .gray : .white)
                        
                        NavigationLink(destination: CaptureHelp()){
                            Image(systemName: "questionmark.circle").font(.title3)
                        }
                    }
                }
            }
        }
        .toast(show: $viewModel.showToast, Toast(show: $viewModel.showToast, type: viewModel.type, message: viewModel.message))
        .foregroundColor(.white)
        .background(Color.swatch.dark.high)
        
    }
}


class StatsViewModel: ObservableObject{
    @Published var selTab: Int = 1
    @Published var showToast: Bool = false
    @Published var type: ToastType = .success
    @Published var message: String = "copied.to.clipboard".trad()
    let team: Team
    let match: Match
    let set: Set
    
    init(team: Team, match: Match, set: Set){
        self.team = team
        self.match = match
        self.set = set
    }
    
    func checkStats()->Bool{
        return set.stats().isEmpty || !match.pass
    }
}




