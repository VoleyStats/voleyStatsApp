import SwiftUI
import UniformTypeIdentifiers
import PDFKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import ProvisioningProfile

struct ListTeams: View {
    @EnvironmentObject var network: NetworkMonitor
    @ObservedObject var viewModel: ListTeamsModel
    @Namespace var animation: Namespace.ID
    @State var rotation: Int = 0
    @State var offset = CGFloat.zero
    
    var body: some View {
        VStack{
            if(!viewModel.min){
                ZStack{
                    if !viewModel.allTeams.isEmpty && viewModel.selected<viewModel.allTeams.count{
                        NavigationLink(destination: TeamData(viewModel: TeamDataModel(team: viewModel.team()))){
                            TeamCard(team: viewModel.team(), deleteTap:{viewModel.deleteDialog.toggle()})
                            //                            .transition(.slide)
                                .offset(x: offset)
                                .gesture(DragGesture()
                                    .onChanged{c in
                                        offset = c.translation.width
                                    }
                                    .onEnded{v in
                                        offset = -v.translation.width
                                        withAnimation(.easeInOut(duration: 0.1)){
                                            
                                            switch(v.translation.width, v.translation.height) {
                                                
                                            case (...0, -200...200):
                                                if viewModel.selected < viewModel.allTeams.count {
                                                    viewModel.selected = viewModel.selected + 1
                                                }else{
                                                    viewModel.selected = 0
                                                }
                                            case (0..., -200...200):
                                                if viewModel.selected > 0 {
                                                    viewModel.selected = viewModel.selected - 1
                                                }else{
                                                    viewModel.selected = viewModel.allTeams.count
                                                }
                                            default: print("default")
                                            }
                                            offset = CGFloat.zero
                                        }
                                        viewModel.tab = "matches".trad()
                                        viewModel.showTournaments = false
                                        viewModel.tournament = nil
                                        if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                            //                                                viewModel.getScouts(team: viewModel.team())
                                            viewModel.getMatchesElements(team: viewModel.team())
                                        }
                                    })
                        }
                        .alert("team.delete.message".trad(), isPresented: $viewModel.deleteDialog){
                            Button("cancel".trad(), role: .cancel){}
                            Button("keep.players".trad()){
                                if viewModel.team().delete(deletePlayers: false){
                                    viewModel.getAllTeams()
                                }
                            }
                            Button("team.delete.title".trad(), role: .destructive){
                                if viewModel.team().delete(){
                                    viewModel.getAllTeams()
                                }
                            }
                            
                        }
//                        .confirmationDialog("team.delete.message".trad(), isPresented: $viewModel.deleteDialog, titleVisibility: .visible){
//                            Button("team.delete.title".trad(), role: .destructive){
//                                if viewModel.team().delete(){
//                                    viewModel.getAllTeams()
//                                }
//                            }
//                        }
                        
                    }
                    if viewModel.selected == viewModel.allTeams.count{
                        NavigationLink(destination: TeamData(viewModel: TeamDataModel(team: nil))){
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(.white.opacity(0.4))
                                    .offset(x: offset)
                                    .gesture(DragGesture()
                                        .onChanged{c in
                                            offset = c.translation.width
                                        }
                                        .onEnded{v in
                                            offset = -v.translation.width
                                            withAnimation(.easeInOut(duration: 0.1)){
                                                switch(v.translation.width, v.translation.height) {
                                                    
                                                case (...0, -200...200):
                                                    if viewModel.selected < viewModel.allTeams.count {
                                                        viewModel.selected = viewModel.selected + 1
                                                    }else{
                                                        viewModel.selected = 0
                                                    }
                                                case (0..., -200...200):
                                                    if viewModel.selected > 0 {
                                                        viewModel.selected = viewModel.selected - 1
                                                    }else{
                                                        viewModel.selected = viewModel.allTeams.count
                                                    }
                                                default: print("default")
                                                }
                                                offset = CGFloat.zero
                                            }
                                        })
                                Image(systemName: "plus").font(.custom("add", size: 30)).foregroundColor(Color.swatch.dark.high).offset(x: offset)
                            }.frame(maxHeight: 200).padding()
                        }
                        .onChange(of: viewModel.selected, perform: {i in
                            if viewModel.selected < viewModel.allTeams.count{
                                viewModel.tab = "matches".trad()
                                viewModel.showTournaments = false
                                viewModel.tournament = nil
                                viewModel.getMatchesElements(team: viewModel.team())
                            }
                        })
                    }
                    HStack{
                        HStack(alignment: .center){
                            ForEach(0..<viewModel.allTeams.count, id:\.self){t in
                                Circle().fill(viewModel.selected == t ? .white : .gray).onTapGesture{
                                    viewModel.selected = t
                                }.frame(width: 5, height: 5)
                            }
                            Image(systemName: "plus").foregroundColor(viewModel.selected == viewModel.allTeams.count ? .white : .gray).onTapGesture{
                                viewModel.selected = viewModel.allTeams.count
                            }.frame(width: 5, height: 5).padding(.horizontal, 5)
                        }
                    }.padding(10).background(.black.opacity(0.1)).clipShape(Capsule()).frame(height: 5, alignment: .center).padding().frame(maxHeight: 200, alignment: .bottom)
                }.onChange(of: viewModel.selected, perform: {i in
                    if viewModel.selected < viewModel.allTeams.count{
                        viewModel.getMatchesElements(team: viewModel.team())
                    }
                })
            }
            if viewModel.allTeams.isEmpty{
                EmptyState(icon: Image(systemName: "person.3.fill"), msg: "no.teams".trad(), button:{
                    NavigationLink(destination: TeamData(viewModel: TeamDataModel(team: nil))){
                        Text("start".trad())
                    }.foregroundStyle(.cyan)
                })
            } else {
                VStack{
                    if !viewModel.allTeams.isEmpty{
                        HStack{
                            TabButton(selection: $viewModel.tab, title: "matches".trad(), animation: animation, action: {
                                viewModel.showTournaments = false
                                viewModel.tournament = nil
                                viewModel.min = false
                                viewModel.getMatchesElements(team: viewModel.team())
                            })
                            TabButton(selection: $viewModel.tab, title: "tournaments".trad(), animation: animation, action: {
                                viewModel.showTournaments = true
                                viewModel.league = false
                                viewModel.min = false
                                viewModel.getMatchesElements(team: viewModel.team())
                            })
                            TabButton(selection: $viewModel.tab, title: "team.stats".trad(), animation: animation, action: {
                                viewModel.min = true
                            })
                        }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding([.horizontal, .top])
                    }
                    VStack{
                        if viewModel.tab == "matches".trad() || viewModel.tab == "tournaments".trad() {
                            if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                ZStack(alignment: .bottomTrailing){
                                    ListMatches(viewModel: viewModel).padding()
                                    //ENABLE TRAINING CAPTURE STATS
                                    //                                        if !viewModel.allTeams.isEmpty{
                                    //                                            NavigationLink(destination: TrainingCapture(viewModel: TrainingCaptureModel(team: viewModel.team()))){
                                    //                                                ZStack{
                                    //                                                    RoundedRectangle(cornerRadius: 15).fill(.cyan)
                                    //                                                    Image(systemName: "hand.tap.fill").foregroundStyle(.white)
                                    //                                                }.frame(width: 70, height: 70).padding()
                                    //                                            }.padding()
                                    //                                        }
                                }
                            }
                        } else if viewModel.tab == "team.stats".trad(){
                            if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                TeamStats(team: viewModel.team())
                            }
                        }
                    }.frame(maxHeight:.infinity).foregroundColor(.white)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            if !network.isConnected{
                HStack{
                    Text("offline".trad()).font(.caption).padding(5).frame(maxWidth: .infinity, alignment: .center)
                }.background(.gray)
            }
        }
        .onAppear{
            viewModel.getAllTeams()
//            viewModel.tab = "matches".trad()
            if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
//                viewModel.getScouts(team: viewModel.team())
                viewModel.getMatchesElements(team: viewModel.team())
            }

            
        }
        
        .navigationTitle(viewModel.min ? viewModel.team().name : "your.teams".trad())
        .navigationBarTitleDisplayMode(.inline)
//        .environment(\.colorScheme, .dark)
        .toolbar{
            ToolbarItem(placement: .primaryAction) {
                if Auth.auth().currentUser != nil {
                    HStack{
                        NavigationLink(destination: UserView(viewModel: UserViewModel())){
                            Image(systemName: "person.circle").font(.title3)
                        }
                    }
                } else {
                    HStack{
                        NavigationLink(destination: Login(viewModel: LoginModel(login: true))){
                            Text("login".trad().uppercased()).font(.caption)
                        }.disabled(!network.isConnected)
                        NavigationLink(destination: Login(viewModel: LoginModel(login: false))){
                            Text("sign.up".trad().uppercased()).font(.caption).padding(10).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8))
                        }.disabled(!network.isConnected)
                        Menu {
                            Button(action: {
                                viewModel.lang = "es"
                                UserDefaults.standard.set("es", forKey: "locale")
                                viewModel.tab = viewModel.tab.lowercased().trad()
                            }){
                                Text("spanish".trad())
                                if viewModel.lang == "es" {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }.frame(maxWidth: .infinity)
                            Button(action: {
                                viewModel.lang = "en"
                                UserDefaults.standard.set("en", forKey: "locale")
                                viewModel.tab = viewModel.tab.trad()
                            }){
                                Text("english".trad())
                                if viewModel.lang == "en" {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }.frame(maxWidth: .infinity)
                        } label: {
                            Label("language".trad(), systemImage: "globe")
                        }
                    }.padding(.vertical)
                }
            }
//            ToolbarItem(placement: .navigationBarLeading){
//                Text(viewModel.df.string(from: ProvisioningProfile.profile()?.expiryDate ?? .now)).font(.caption).onTapGesture {
//                    viewModel.statsFile = Report().generate()
//                }
//                Text(viewModel.profile?.formattedExpiryDate ?? "some error")
//            }
        }
        .quickLookPreview($viewModel.statsFile)
        .overlay(viewModel.reportLang && (viewModel.matchSelected != nil || !viewModel.reportMatches.isEmpty) ? langChooseModal() : nil)
        
        .background(
            Color.swatch.dark.high
        )
        .foregroundColor(.white)
        .preferredColorScheme(.dark)
        
    }
    
    @ViewBuilder
    func langChooseModal() -> some View {
        VStack{
//            let actualLang = UserDefaults.standard.string(forKey: "locale") ?? "en"
            HStack{
                Button(action:{viewModel.reportLang.toggle()}){
                    Image(systemName: "multiply").font(.title2)
                }
            }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
            if viewModel.matchSelected != nil && viewModel.reportMatches.isEmpty{
                ReportConfigurator(team: viewModel.team(), matches: [viewModel.matchSelected!], fileUrl: $viewModel.statsFile, show: $viewModel.reportLang).padding()
            }
            if !viewModel.reportMatches.isEmpty{
                ReportConfigurator(team: viewModel.team(), matches: viewModel.reportMatches, fileUrl: $viewModel.statsFile, show: $viewModel.reportLang).padding()
            }
        }
        .background(.black)
//        .frame(width:500, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 25)).padding()
    }
//    }
}

class ListTeamsModel: ObservableObject{
    @Published var deleteDialog: Bool = false
    @Published var allTeams: [Team]=[]
    @Published var reportMatches: [Match]=[]
    @Published var selectMatches:Bool = false
    @Published var matchSelected: Match? = nil
    @Published var tab: String = "matches".trad()
    @Published var lang: String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @Published var matches: [Match] = []
    @Published var league:Bool = false
    @Published var tournaments: [Tournament] = []
    @Published var tournament:Tournament?=nil
    @Published var showTournaments:Bool=false
    @Published var statsFile: URL? = nil
    @Published var selected: Int = 0
    @Published var reportLang: Bool = false
    @Published var min:Bool = false
    let df = DateFormatter()
    
    init(){
        self.getAllTeams()
        df.dateFormat = "dd/MM/yyyy"
        if !self.allTeams.isEmpty && self.selected < self.allTeams.count{
            self.getMatchesElements(team: self.team())
        }
    }
    func team()->Team{
        return allTeams[self.selected]
    }
    
    
    func getAllTeams(){
        allTeams = Team.all()
        if allTeams.first?.order == 0{
            allTeams.enumerated().forEach{i, t in
                t.order = i+1
                t.update()
            }
            
        }
    }
    func getMatchesElements(team:Team){
        self.matches = team.matches().filter{$0.league == self.league && $0.tournament == self.tournament}
        
        self.tournaments = team.tournaments()
    }
    func deleteMatch(match: Match){
        let delete = match.delete()
        if delete {
            self.getMatchesElements(team: self.team())
        }
    }
    func deleteTeam(team: Team){
        let delete = team.delete()
        if delete {
            getAllTeams()
        }
    }
    
}
