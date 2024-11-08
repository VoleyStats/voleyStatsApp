import SwiftUI

struct PlayerData: View {
    @ObservedObject var viewModel: PlayerDataModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
//            Text("player.new".trad()).font(.title)
            VStack{
                if viewModel.player == nil {
                    HStack{
                        Text("restore".trad()).font(.caption).padding(.horizontal).padding(.vertical, 10).background(.white.opacity(0.1)).clipShape(Capsule()).padding(.horizontal).onTapGesture{
                            viewModel.restore.toggle()
                        }
                        Text("add.from.team".trad()).font(.caption).padding(.horizontal).padding(.vertical, 10).background(.white.opacity(0.1)).clipShape(Capsule()).padding(.horizontal).onTapGesture{
                            viewModel.addFromTeam.toggle()
                        }
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }
//                if viewModel.team != nil && viewModel.player == nil && viewModel.restore{
//                    
//                    Section{
//                        HStack{
//                            Text("player.restore".trad()).frame(maxWidth: .infinity, alignment: .leading)
//                            Picker(selection: $viewModel.restored, label: Text("player.restore".trad())) {
//                                Text("pick.one".trad()).tag(0)
//                                ForEach(Player.deleted(), id:\.id){player in
//                                    HStack{
//                                        Text("\(player.name)").tag(player.id)
//                                    }
//                                }
//                            }
//                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                    }
//                    
//                    Button(action:{viewModel.restoreDialog.toggle()}){
//                        Text("restore".trad()).frame(maxWidth: .infinity, alignment: .center)
//                    }.disabled(viewModel.restored == 0).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.restored == 0 ? .gray : .cyan)
//                        .confirmationDialog("restore.description".trad(), isPresented: $viewModel.restoreDialog, titleVisibility: .visible){
//                            Button("restore".trad()){
//                                viewModel.restorePlayer()
//                                if viewModel.saved{
//                                    self.presentationMode.wrappedValue.dismiss()
//                                }
//                            }
//                            Button("cancel".trad(), role: .cancel){}
//                        }
////                    Button(action:{viewModel.addFromTeam.toggle()}){
////                        Text("add.from.team".trad()).frame(maxWidth: .infinity, alignment: .center)
////                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(.cyan)
//                } else {
                    Section{
                        VStack{
                            VStack(alignment: .leading){
                                Text("number".trad()).font(.caption)
                                TextField("number".trad(), value: $viewModel.number, format: .number).textFieldStyle(TextFieldDark()).keyboardType(.numberPad)
    //                            Stepper("\(viewModel.number)", value: $viewModel.number, in: 1...99)
                            }.padding(.bottom)
                            VStack(alignment: .leading){
                                Text("name".trad()).font(.caption)
                                TextField("name".trad(), text: $viewModel.name).textFieldStyle(TextFieldDark())
                            }
                            
                            
                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    if viewModel.player != nil && viewModel.player?.mainTeam ?? false{
                        Section{
                            VStack{
                                DatePicker("birthday".trad(), selection: $viewModel.birthday, displayedComponents: [.date]).padding(.vertical, 3)
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    Section{
                        VStack(alignment: .leading){
                            Text("position".trad()).font(.caption)
                            Picker(selection: $viewModel.position, label: Text("position".trad())) {
                                Text(PlayerPosition.universal.rawValue.trad()).tag(PlayerPosition.universal)
                                Text(PlayerPosition.setter.rawValue.trad()).tag(PlayerPosition.setter)
                                Text(PlayerPosition.opposite.rawValue.trad()).tag(PlayerPosition.opposite)
                                Text(PlayerPosition.midBlock.rawValue.trad()).tag(PlayerPosition.midBlock)
                                Text(PlayerPosition.outside.rawValue.trad()).tag(PlayerPosition.outside)
                                Text(PlayerPosition.libero.rawValue.trad()).tag(PlayerPosition.libero)
                            }.pickerStyle(.segmented)
                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    Button(action:{
                        viewModel.onAddButtonClick()
                        if viewModel.saved{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }){
                        Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                    }.disabled(viewModel.name.isEmpty || viewModel.number == 0).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor((viewModel.name.isEmpty || viewModel.number == 0) ? .gray : .cyan).onTapGesture {
                        
                    }
                
//                    Spacer()
//                    Spacer()
//                    Spacer()
//                    Spacer()
                
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .overlay(viewModel.addFromTeam ? VStack{
                ZStack{
                    if viewModel.selectedTeam != nil {
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("teams".trad())
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture{
                                viewModel.selectedTeam = nil
                            }
                    }
                    Image(systemName: "multiply").frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                        viewModel.selectedTeam = nil
                        viewModel.selectedPlayers = []
                        viewModel.addFromTeam.toggle()
                    }.padding()
                }
                if viewModel.selectedTeam == nil{
                    Text("pick.team".trad()).font(.title)
                    Spacer()
                    ForEach(viewModel.teams, id: \.id){team in
                        Text(team.name).padding().frame(height: 60).frame(maxWidth: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            viewModel.selectedTeam = team
                        }
                    }
                } else {
                    Text("pick.player".trad()).font(.title).padding(.bottom)
                    Spacer()
                    ScrollView{
                        VStack{
                            ForEach(viewModel.selectedTeam!.players().filter{!viewModel.team!.players().contains($0)}, id: \.id){player in
                                HStack{
                                    if viewModel.selectedPlayers.contains(player) {
                                        Image(systemName: "checkmark.circle.fill").padding(.horizontal).font(.title2)
                                    }else{
                                        Image(systemName: "circle").padding(.horizontal).font(.title2)
                                    }
                                    Text(player.name)
                                }.padding().frame(height: 60).frame(maxWidth: .infinity, alignment: .leading).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                    viewModel.selectedPlayers.append(player)
                                }
                            }
                        }
                    }
                        Text("add.players".trad()).padding().frame(height: 60).frame(maxWidth: .infinity)
                        .background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(.cyan).padding()
                        .onTapGesture{
                            if !viewModel.selectedPlayers.isEmpty{
                                
                                
                                viewModel.addPlayers()
                                if viewModel.saved{
                                    presentationMode.wrappedValue.dismiss()
                                    //                                dismiss()
                                }
                            }
                    }
                }
                Spacer()
            }.padding().background(.black).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxWidth: .infinity, maxHeight:  .infinity).padding() : nil)
            .overlay(viewModel.restore ? restoreModal() : nil)
            .foregroundStyle(.white)
            .navigationTitle(viewModel.player == nil ? "player.new".trad() : "player.edit".trad())
            .onAppear{
//                viewModel.teams = Team.all().filter{$0.id != viewModel.team?.id}
            }
    }
    
    @ViewBuilder
    func restoreModal() -> some View{
        VStack{
            ZStack{
                Image(systemName: "multiply").font(.title3).frame(maxWidth: .infinity, alignment: .trailing).padding().onTapGesture {
                    viewModel.restore.toggle()
                }
                Text("player.restore".trad()).frame(maxWidth: .infinity, alignment: .center).padding(.bottom)
            }
            ScrollView{
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)){
                    ForEach(Player.deleted(), id:\.id){player in
                        HStack{
                            Text("\(player.name)").tag(player.id)
                        }.padding().frame(maxWidth: .infinity, maxHeight: 50).background(viewModel.selectedPlayers.contains(player) ? .blue : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                if viewModel.selectedPlayers.contains(player){
                                    viewModel.selectedPlayers = viewModel.selectedPlayers.filter{$0 != player}
                                }else{
                                    viewModel.selectedPlayers.append(player)
                                }
                            }
                    }
                }
            }.padding(.bottom)
            Text("restore".trad()).foregroundStyle(viewModel.selectedPlayers.isEmpty ? .gray : .cyan).frame(maxWidth: .infinity).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding().onTapGesture {
                viewModel.restorePlayers()
                if viewModel.saved{
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            
        }.font(.body).foregroundStyle(.white).padding().background(.black).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxWidth: .infinity).padding()
    }
}

class PlayerDataModel: ObservableObject{
    @Published var name: String = ""
    @Published var number: Int = 1
    @Published var birthday: Date = Date()
    @Published var position: PlayerPosition = .universal
    var team: Team?
    var player: Player? = nil
    var teams:[Team]=[]
    @Published var restored: Int = 0
    @Published var restoreDialog: Bool = false
    @Published var addFromTeam: Bool = false
    @Published var selectedTeam: Team? = nil
    @Published var selectedPlayers:[Player]=[]
    @Published var saved: Bool = false
    @Published var restore: Bool = false
    
    init(team: Team?, player: Player?){
        self.team = team ?? nil
        name = player?.name ?? ""
        number = player?.number ?? 0
        birthday = player?.birthday ?? Date()
        position = player?.position ?? .universal
        self.player = player
        self.teams = Team.all().filter{$0.id != team!.id}
    }
    func restorePlayers(){
//        var player = Player.find(id: self.restored)!
        selectedPlayers.forEach{player in
            player.team = team!.id
            player.update()
        }
        saved.toggle()
        
    }
    func addPlayers(){
        selectedPlayers.forEach{p in
            team?.addPlayer(player: p)
        }
        saved.toggle()
    }
    func onAddButtonClick(){
        if self.player != nil {
            player?.name = name
            player?.number = number
            player?.birthday = birthday
            player!.position = position
            let updated = player?.update()
            if updated ?? false {
                saved.toggle()
            }
        }else{
            let newPlayer = Player(name: name, number: number, team: team?.id ?? 0, active:1, birthday: birthday, position: position, id: nil)
            let id = Player.createPlayer(player: newPlayer)
            if id != nil {
                saved.toggle()
            }
        }
        
        
    }
}



