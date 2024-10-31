import SwiftUI

struct CaptureHelp: View {
//    @ObservedObject var viewModel: PointLogModel
    @State var tab = "general".trad()
    @Namespace var animation: Namespace.ID
    var body: some View {
        VStack{
            VStack {
                HStack{
                    TabButton(selection: $tab, title: "general".trad(), animation: animation, action: {})
                    TabButton(selection: $tab, title: "actions".trad(), animation: animation, action: {})
                    TabButton(selection: $tab, title: "stats".trad(), animation: animation, action: {})
                }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
                ScrollView(){
                    VStack{
                        if(tab == "general".trad()){
                            VStack{
                                Text("general.explanation".trad()).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                                CollapsibleListElement(expanded: false, title: "capture".trad()){
                                    VStack{
                                        Text("capture.explanation".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
                                        Text("the.score".trad()).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        HStack{
                                            Text("the.score.explanation.1".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                            Image("score").resizable().aspectRatio(contentMode: .fit)
                                        }
                                        Text("the.score.explanation.2".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("current.rotation".trad()).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        HStack{
                                            Text("current.rotation.explanation.1".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                            Image("rotation").resizable().aspectRatio(contentMode: .fit)
                                        }
                                        Text("current.rotation.explanation.2".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("servers".trad()).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("servers.explanation.1".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("capturing.stats".trad()).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("capturing.stats.explanation.1".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("capturing.stats.explanation.2".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("capturing.stats.explanation.3".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("capturing.stats.explanation.4".trad()).fixedSize(horizontal: false, vertical: true).padding(.top).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                CollapsibleListElement(expanded: false, title: "stats".trad()){
                                    VStack{
                                        Text("stats.explanation.1".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
                                        HStack{
                                            Text("\("stats.explanation.2".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                            Image(systemName: "arrow.right").padding(.horizontal)
                                        }.padding(.top).onTapGesture {
                                            withAnimation{
                                                tab = "stats".trad()
                                            }
                                        }
                                    }
                                }
                                CollapsibleListElement(expanded: false, title: "point.log".trad()){
                                    VStack{
                                        Text("point.log.explanation".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
                                        
                                        HStack{
                                            VStack{
                                                Image("pointLog_list").resizable().aspectRatio(contentMode: .fit)
                                                Text("point.log".trad())
                                            }
                                            VStack{
                                                Image("pointLog_graph").resizable().aspectRatio(contentMode: .fit)
                                                Text("game.graph".trad())
                                            }
                                        }
                                        
                                        Text("\("stage".trad())").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("stage.explanation".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("server".trad())").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("server.explanation".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("player".trad())").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("player.explanation".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("action.type".trad())").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("action.type.explanation".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("action".trad())").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("action.explanation".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
//                                        Text("\("point.to".trad())").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
//                                        Text("\("point.to.explanation".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        
                                        Text("\("score".trad())").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("score.explanation".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                CollapsibleListElement(expanded: false, title: "fill.stats".trad()){
                                    VStack{
                                        Text("fill.stats.explanation".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
                                        HStack{
                                            Text("fill.stats.explanation.1".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
                                            Image("fillStats_top").resizable().aspectRatio(contentMode: .fit)
                                        }
                                        HStack{
                                            Text("fill.stats.explanation.2".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
                                            Image("fillStats_inGame").resizable().aspectRatio(contentMode: .fit)
                                        }
                                        Text("fill.stats.explanation.3".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
                                    }
                                }
                            }
                        }
                        if(tab == "actions".trad()){
                            VStack{
                                Text("actions.explanation".trad()).fixedSize(horizontal: false, vertical: true).padding(.horizontal)
                                CollapsibleListElement(expanded: false, title: "in.rally.actions".trad()){
                                    VStack{
                                        Text("in.rally.explanation".trad()).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("dig".trad().capitalized)").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.dig".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("1-Free ball".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.free.ball.1".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("2-Free ball".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.free.ball.2".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("3-Free ball".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.free.ball.3".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("block.in.play".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.block".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("over.pass.in.play".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.overpass".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("1.receive".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.receive.1".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("2.receive".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.receive.2".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("3.receive".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.receive.3".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("1.serve".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.serve.1".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("2.serve".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.serve.2".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("3.serve".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.serve.3".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("hit.in.play".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.hit".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("downhit.in.play".trad())").font(.title3.weight(.bold)).foregroundStyle(.gray).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("in.rally.downhit".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                CollapsibleListElement(expanded: false, title: "earned.actions".trad()){
                                    VStack{
                                        Text("earned.actions.explanation".trad()).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("ace".trad())").font(.title3.weight(.bold)).foregroundStyle(.green).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("earned.ace".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("spike".trad())").font(.title3.weight(.bold)).foregroundStyle(.green).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("earned.spike".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("tip".trad())").font(.title3.weight(.bold)).foregroundStyle(.green).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("earned.tip".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("blockout".trad())").font(.title3.weight(.bold)).foregroundStyle(.green).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("earned.blockout".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("downhit".trad())").font(.title3.weight(.bold)).foregroundStyle(.green).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("earned.downhit".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("block".trad().capitalized)").font(.title3.weight(.bold)).foregroundStyle(.green).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("earned.block".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                    }
                                }
                                CollapsibleListElement(expanded: false, title: "error.actions".trad()){
                                    VStack{
                                        Text("error.actions.explanation".trad()).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("serve".trad().capitalized)").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.serve".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("spike".trad())").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.attack".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("tip".trad())").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.attack".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
//                                        Text("\("dump".trad())").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
//                                        Text("\("error.attack".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("downhit".trad())").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.attack".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("block".trad().capitalized)").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.block".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("whose.ball".trad())").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.whose.ball".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("receive".trad().capitalized)").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.receive".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("dig".trad().capitalized)").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.dig".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("set".trad().capitalized)").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.set".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("Free ball".trad())").font(.title3.weight(.bold)).foregroundStyle(Color.swatch.yellow.base).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("error.free.ball".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                CollapsibleListElement(expanded: false, title: "fault.actions".trad()){
                                    VStack{
                                        Text("fault.actions.explanation".trad()).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("net".trad())").font(.title3.weight(.bold)).foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("fault.net".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("ball.handling".trad())").font(.title3.weight(.bold)).foregroundStyle(.red).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("fault.ball.handling".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("under".trad())").font(.title3.weight(.bold)).foregroundStyle(.red).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("fault.under".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("foot".trad())").font(.title3.weight(.bold)).foregroundStyle(.red).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("fault.foot".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("over.the.net".trad())").font(.title3.weight(.bold)).foregroundStyle(.red).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("fault.over.the.net".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("out.rotation".trad())").font(.title3.weight(.bold)).foregroundStyle(.red).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("fault.out.rotation".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\("backrow.attack".trad())").font(.title3.weight(.bold)).foregroundStyle(.red).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("fault.backrow.attack".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        if tab == "stats".trad(){
                            VStack{
                                Text("stats.explanation".trad()).padding(.horizontal)
                                CollapsibleListElement(expanded: false, title: "general".trad()){
                                    VStack{
                                        Text("stats.general.explanation".trad()).fixedSize(horizontal: false, vertical: true).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("their.errors".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        HStack{
                                            Text("\("general.their.errors".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                            Image("theirErrors").resizable().aspectRatio(contentMode: .fit)
                                        }
                                        //ACTIONS IN A ROW
//                                        Text("serve.errors".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
//                                        HStack{
//                                            Text("\("general.serve.errors".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
//                                            Image("srv_errors").resizable().aspectRatio(contentMode: .fit)
//                                        }
                                        Text("error.distribution".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        HStack{
                                            Text("\("general.error.distribution".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                            Image("errDistribution").resizable().aspectRatio(contentMode: .fit)
                                        }
                                        Text("attack.chart".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        HStack{
                                            Text("\("general.attack.chart".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                            Image("atkGraph").resizable().aspectRatio(contentMode: .fit)
                                        }
                                        Text("attack.distribution".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        HStack{
                                            Text("\("general.attack.distribution".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                            Image("atkDistribution").resizable().aspectRatio(contentMode: .fit)
                                        }
                                        //SERVE DETAIL CHART
                                        Text("receive.chart".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        HStack{
                                            Text("\("general.receive.chart".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                            Image("rcv_graph").resizable().aspectRatio(contentMode: .fit)
                                        }
//                                        Text("receive.rating".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
//                                        Text("\("general.receive.rating".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
//                                        
//                                        Text("kill.percentage".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
//                                        Text("\("general.kill.percentage".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
//                                        
//                                        Text("general.match.bests".trad()).fixedSize(horizontal: false, vertical: true).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                CollapsibleListElement(expanded: false, title: "rotation".trad()){
                                    VStack{
                                        Text("stats.rotation.explanation".trad()).fixedSize(horizontal: false, vertical: true).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
                                        Image("rotation_stats").resizable().aspectRatio(contentMode: .fit)
                                        Text("side.out".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("side.out.explanation".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("break.point".trad()).fixedSize(horizontal: false, vertical: true).font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("break.point.explanation".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
//                                CollapsibleListElement(expanded: false, title: "direction.detail".trad()){
//                                    VStack{
//                                        Text("direction.detail.explanation".trad()).fixedSize(horizontal: false, vertical: true).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
//                                        
//                                    }
//                                }
//                                CollapsibleListElement(expanded: false, title: "heatmap.detail".trad()){
//                                    VStack{
//                                        Text("heatmap.detail.explanation".trad()).fixedSize(horizontal: false, vertical: true).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
//                                        
//                                    }
//                                }
                                CollapsibleListElement(expanded: false, title: "stats.per.area".trad()){
                                    VStack{
                                        Text("area.explanation".trad()).fixedSize(horizontal: false, vertical: true).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("attack".trad().capitalized)").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.attack.1".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.attack.2".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Image("atk_stats").resizable().aspectRatio(contentMode: .fit)
                                        
                                        Text("\("block".trad().capitalized)").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.block".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Image("blk_stats").resizable().aspectRatio(contentMode: .fit)
                                        
                                        Text("\("dig".trad().capitalized)").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.dig".trad())").frame(maxWidth: .infinity, alignment: .leading)
                                        Image("dig_stats").resizable().aspectRatio(contentMode: .fit)
                                        
                                        Text("\("downhit".trad())").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.downhit".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Image("dbh_stats").resizable().aspectRatio(contentMode: .fit)
                                        
                                        Text("\("fault".trad())").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.fault".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Image("fault_stats").resizable().aspectRatio(contentMode: .fit)
                                        
                                        Text("\("free".trad().capitalized)").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.free".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Image("free_stats").resizable().aspectRatio(contentMode: .fit)
                                        
                                        Text("\("receive".trad().capitalized)").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.receive".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Image("rcv_stats").resizable().aspectRatio(contentMode: .fit)
                                        
                                        Text("\("serve".trad().capitalized)").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.serve".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Image("srv_stats").resizable().aspectRatio(contentMode: .fit)
                                        
                                        Text("\("set".trad().capitalized)").font(.title3.weight(.bold)).padding(.top).frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\("area.set".trad())").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                                        Image("set_stats").resizable().aspectRatio(contentMode: .fit)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("help".trad())
        .background(Color.swatch.dark.high).foregroundColor(.white)
        
    }
}
//class PointLogModel: ObservableObject{
//    @Published var fullLog: [Stat] = []
//    @Published var finalsLog: [Stat] = []
//    @Published var finals:Bool = false
//    var set:Set
//    init(set: Set){
//        self.set = set
//    }
//    func obtainLog(){
//        fullLog = set.stats()
//        finalsLog = set.stats().filter{s in return s.to != 0}
//    }
//}


