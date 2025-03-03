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
                                .spotlight(6, shape: .rounded, roundedRadius: 8, text: "tutorial.fill.stats".trad())
                        }.disabled(viewModel.checkStats()).foregroundStyle(viewModel.checkStats() ? .gray : .white)
                        if viewModel.selTab == 1{
                            Menu{
                                Button(action:{
                                    viewModel.tutorialStep = 1
                                    viewModel.tutorial = true
                                    viewModel.quickActionsSlider = true
                                }){
                                    Text("show.tutorial".trad())
                                    Image(systemName: "questionmark.circle")
                                }
                                NavigationLink(destination: CaptureHelp()){
                                    HStack{
                                        Text("help".trad())
                                        Image(systemName: "text.page").font(.title3)
                                    }
                                }
                            }label:{
                                Label("help", systemImage: "questionmark.circle")
                            }
                        }else{
                            
                        }
                        
                    }
                }
            }
        }
        .spotlightOverlay(show: $viewModel.tutorial, currentSpot: $viewModel.tutorialStep, name: "captureTutorial")
        .overlay(viewModel.quickActionsSlider && !viewModel.tutorial ?
                 ZStack{
                    Rectangle().fill(Color.swatch.dark.mid.opacity(0.5)).ignoresSafeArea()
            VStack{
                Image(systemName: "multiply").font(.title2).frame(maxWidth: .infinity, alignment: .trailing).padding().onTapGesture{
                    viewModel.quickActionsSlider.toggle()
                }
                Text("quick.actions.tip".trad()).font(.title)
                HStack{
                    Image(systemName: "hand.point.up.left.fill").font(.system(size: 60)).rotationEffect(.degrees(-90)).overlay(alignment: .bottomLeading){
                        Image(systemName: "arrow.down").font(.title2).foregroundStyle(.cyan).offset(x: -10, y: 10)
                    }.padding()
                    Text("capture.swipe.down".trad()).font(.title3)
                }.padding()
                HStack{
                    Text("capture.swipe.up".trad()).font(.title3)
                    Image(systemName: "hand.point.up.left.fill").font(.system(size: 60)).overlay(alignment: .topLeading){
                        Image(systemName: "arrow.up").font(.title2).foregroundStyle(.cyan).offset(x: -10, y: -10)
                    }.padding()
                }.padding()
                HStack{
                    Image(systemName: "hand.tap.fill").font(.system(size: 60)).symbolRenderingMode(.palette).foregroundStyle(.white,.cyan).overlay(alignment: .bottomLeading){
                        Image(systemName: "2.circle").font(.title2).offset(x: -10)
                    }.padding()
                    Text("capture.double.tap".trad()).font(.title3)
                }.padding()
                HStack{
                    Text("capture.autosave.in.game".trad()).font(.title3)
                    Image(systemName: "rectangle.and.hand.point.up.left.filled").foregroundStyle(.white,.cyan).font(.system(size: 60)).padding()
                }.padding()
                Text("got.it.start".trad()).font(.title3).padding().padding(.horizontal).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8)).padding().onTapGesture{
                    viewModel.quickActionsSlider.toggle()
                }
            }.padding().background(.black).clipShape(RoundedRectangle(cornerRadius: 15)).foregroundStyle(.white).padding()
//                    PresentationSlider(title: "quick.action.tips".trad(),slides:[
//                        Slide(title: "slide.swipeup.title".trad(), subtitle: "slide.swipeup.text".trad(), image: Image("slide_export")),
//                        Slide(title: "slide.swipedown.title".trad(), subtitle: "slide.swipedown.text".trad().trad(), image: Image("slide_stats")),
//                        Slide(title: "slide.doubletap.title".trad(), subtitle: "slide.doubletap.text".trad(), image: Image("slide_fill")),
//                        Slide(title: "slide.autosave.title".trad(), subtitle: "slide.autosave.text", image: Image("slide_backup"))
//                    ], cta_text: "start.capturing".trad(), cta_action: {viewModel.quickActionsSlider.toggle()}, skip_action: {viewModel.quickActionsSlider.toggle()}).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center).padding()
                }.transition(.move(edge: .bottom)) : nil)
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
    @Published var tutorial: Bool = UserDefaults.standard.bool(forKey: "captureTutorial")
    @Published var tutorialStep: Int = 1
    @Published var quickActionsSlider: Bool = UserDefaults.standard.bool(forKey: "captureTutorial")
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




