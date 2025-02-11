import SwiftUI

struct ReportConfigurator: View {
    var team: Team
    var matches:[Match]
    @Binding var fileUrl:URL?
    var show: Binding<Bool>
    @State var lang: String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @State var actualLang: String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @State var pointLog: Bool = false
    @State var receiveDetail: Bool = false
    @State var serveDetail: Bool = false
    @State var attackDetail: Bool = false
    @State var matchCompare: Bool = false
    @State var errorTree: Bool = false
    @State var countHidden: Bool = false
    @State var setDetail: Bool = false
    @State private var loading: Bool = false


    var body: some View {
        VStack {
            Text("report.configurator".trad()).font(.title).padding(.bottom)
            VStack{
                Text("language".trad()).font(.title2).padding(.bottom)
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(lang == "es" ? .blue : .gray)
                        Text("spanish".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        lang = "es"
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(lang == "en" ? .blue : .gray)
                        Text("english".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        lang = "en"
                    }
                }
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxHeight: 150).padding()
            
                VStack{
                    Text("sections".trad()).font(.title2).padding(.bottom)
                    ScrollView{
                        VStack{
                            HStack{
//                                VStack{
//                                    Image(systemName: "tablecells.fill").foregroundStyle(errorTree ? .white : .cyan).font(.largeTitle).padding()
//                                    Text("error.tree".trad())
//                                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
//                                    .background(errorTree ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                                    .onTapGesture {
//                                        errorTree.toggle()
//                                    }
//                                
//                                VStack{
//                                    Image(systemName: "contact.sensor.fill").foregroundStyle(matchCompare ? .white : .cyan).font(.largeTitle).padding()
//                                    Text("match.compare".trad())
//                                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
//                                    .background(matchCompare ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                                    .onTapGesture {
//                                        matchCompare.toggle()
//                                    }
                                VStack{
                                    Image(systemName: "chart.bar.doc.horizontal.fill").foregroundStyle(pointLog ? .white : .cyan).font(.largeTitle).padding()
                                    Text("point.log".trad())
                                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(pointLog ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture {
                                        pointLog.toggle()
                                    }
                                
                                VStack{
                                    Image(systemName: "list.bullet.below.rectangle").foregroundStyle(setDetail ? .white : .cyan).font(.largeTitle).padding()
                                    Text(matches.count == 1 ? "set.detail".trad() : "match.detail".trad())
                                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(setDetail ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture {
                                        setDetail.toggle()
                                    }
                            }
                            HStack{
                                VStack{
                                    Image(systemName: "chart.bar.xaxis").foregroundStyle(attackDetail ? .white : .cyan).font(.largeTitle).padding()
                                    Text("attack.detail".trad())
                                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(attackDetail ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture {
                                        attackDetail.toggle()
                                    }
                            
                                VStack{
                                    Image(systemName: "chart.bar.xaxis").foregroundStyle(serveDetail ? .white : .cyan).font(.largeTitle).padding()
                                    Text("serve.detail".trad())
                                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(serveDetail ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture {
                                        serveDetail.toggle()
                                    }
                                
                                VStack{
                                    Image(systemName: "chart.bar.xaxis").foregroundStyle(receiveDetail ? .white : .cyan).font(.largeTitle).padding()
                                    Text("receive.detail".trad())
                                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(receiveDetail ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture {
                                        receiveDetail.toggle()
                                    }
                            }
//                            HStack{
//                                VStack{
//                                    Image(systemName: "chart.bar.doc.horizontal.fill").foregroundStyle(pointLog ? .white : .cyan).font(.largeTitle).padding()
//                                    Text("point.log".trad())
//                                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
//                                    .background(pointLog ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                                    .onTapGesture {
//                                        pointLog.toggle()
//                                    }
//                                
//                                VStack{
//                                    Image(systemName: "plusminus.circle").foregroundStyle(countHidden ? .white : .cyan).font(.largeTitle).padding()
//                                    Text("hidden.count".trad())
//                                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
//                                    .background(countHidden ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                                    .onTapGesture {
//                                        countHidden.toggle()
//                                    }
//                            }
                        }
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding()

            ZStack{
                RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(.blue)
                if loading{
                    ProgressView().tint(.white)
                }else{
                    Text("generate".trad()).foregroundColor(.white).padding(5)
                }
            }.clipped().onTapGesture {
                loading = true
                
                var sections:[ReportSections] = []
                if errorTree {
                    sections.append(ReportSections.errorTree)
                }
                if setDetail{
                    sections.append(.setDetail)
                }
                if pointLog {
                    sections.append(ReportSections.pointLog)
                }
                if matchCompare {
                    sections.append(ReportSections.matchCompare)
                }
                if receiveDetail {
                    sections.append(ReportSections.receiveDetail)
                }
                if serveDetail {
                    sections.append(ReportSections.serveDetail)
                }
                if attackDetail {
                    sections.append(ReportSections.attackDetail)
                }
                if countHidden {
                    sections.append(.hiddenCount)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UserDefaults.standard.set(lang, forKey: "locale")
                    if matches.count == 1{
                        fileUrl = Report(team:team, match: matches.first!, sections: sections).generate()
                    } else {
                        fileUrl = Report(team:team, matches: matches, sections: sections).generate()
                    }
                    UserDefaults.standard.set(actualLang, forKey: "locale")
                    self.loading = false
                    show.wrappedValue.toggle()
                    
                }
            }.frame(maxHeight: 100).padding()
        }
//        .frame(maxHeight: .infinity, alignment: .top)
//        .background(Color.swatch.dark.high).foregroundColor(.white)
    }
    
}


