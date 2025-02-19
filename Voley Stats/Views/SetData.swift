//
//  SetData.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 18/10/24.
//

import SwiftUI
import UIPilot

struct SetData: View {
    @ObservedObject var viewModel: SetDataModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var path:PathManager
    var body: some View {
        VStack (alignment: .center){
            ScrollView{
                    VStack{
                        if !viewModel.isPlaying{
                            Text("first.serve".trad().uppercased()).font(.caption).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                            
                            VStack{
                                Picker(selection: $viewModel.first_serve, label: Text("first.serve".trad())) {
                                    Text("us".trad()).tag(1)
                                    Text("them".trad()).tag(2)
                                }.pickerStyle(.segmented)
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Text("game.mode".trad().uppercased()).font(.caption).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top])
                            
                            VStack{
                                Picker(selection: $viewModel.gameMode, label: Text("first.serve".trad())) {
                                    Text("6-6").tag("6-6")
                                    Text("4-2").tag("4-2")
                                    Text("6-2").tag("6-2")
                                    Text("5-1").tag("5-1")
                                }.pickerStyle(.segmented)
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        //                Spacer()
                        rotation().padding(.top)
                            Text("rotation.qr".trad().uppercased()).font(.caption).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top])
                        VStack(alignment: .leading){
                            Text("team.code".trad()).font(.caption)
                            HStack(alignment: .center){
                                TextField("team.code".trad(), text: $viewModel.teamCode).textFieldStyle(TextFieldDark()).padding(.trailing)
                                
                                //.padding(.bottom)
                                Text(viewModel.side).font(.title2).padding(.vertical, 10).padding(.horizontal).background(.white.opacity(0.1)).clipShape(Capsule()).onTapGesture {
                                    viewModel.side = viewModel.side == "A" ? "B" : "A"
                                }
                                Image(systemName: "qrcode").font(.title)
                                    .foregroundStyle(viewModel.rotation.filter{$0 != nil}.count == viewModel.match.n_players ? .white : .gray)
                                    .padding(.vertical, 10).padding(.horizontal).background(.white.opacity(0.1)).clipShape(Capsule()).onTapGesture {
                                        if viewModel.rotation.filter{$0 != nil}.count == viewModel.match.n_players{
                                            viewModel.qrModal.toggle()
                                        }
                                    }
                            }
                        }.padding().frame(maxWidth: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                        //                Spacer()
                        liberosForm().padding(.top)
                    
                    Text("change.mode".trad().uppercased()).font(.caption).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top])
                    Toggle("change.restrict.mode".trad(), isOn: $viewModel.strictChanges).disabled(viewModel.match.n_players<6).tint(.cyan).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("ask.details".trad().uppercased()).font(.caption).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top])
                    VStack{
                        Toggle("ask.details.error".trad(), isOn: $viewModel.errorDetail).disabled(viewModel.match.n_players<6).tint(.cyan)
//                        Toggle("ask.details.direction".trad(), isOn: $viewModel.directionDetail).disabled(viewModel.match.n_players<6).tint(.cyan)
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    NavigationLink(destination: StatsView(viewModel: StatsViewModel(team: viewModel.team, match: viewModel.match, set: viewModel.set)), isActive: $viewModel.saved){
                        Button(action:{
                            //                        self.presentationMode.wrappedValue.dismiss()
                            print("outside")
                            if !viewModel.validate(){
                                print("inside")
                                viewModel.onAddButtonClick()
                            }
                        }){
                            Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.validate() ? .gray : .cyan)
                    }.padding(.top)
                }.padding()
            }
        }.frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("setup".trad() + " set \(viewModel.number)")
        .background(Color.swatch.dark.high).foregroundColor(.white)
        .overlay(viewModel.liberosModel ? liberosModal() : nil)
        .overlay(viewModel.qrModal ? qrModal() : nil)
        .onAppear{
            
            if viewModel.set.stats().count > 0 {
                self.presentationMode.wrappedValue.dismiss()
            }
            viewModel.players = viewModel.team.activePlayers()
        }
    }
    
    @ViewBuilder
    func qrModal() -> some View {
        VStack{
            ZStack{
                Image(systemName: "multiply").font(.title2).onTapGesture {
                    viewModel.qrModal.toggle()
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
            let r = Rotation(team: viewModel.team, one: viewModel.rotation[0], two: viewModel.rotation[1], three: viewModel.rotation[2], four: viewModel.rotation[3], five: viewModel.rotation[4], six: viewModel.rotation[5])
            r.genrateQR(set: viewModel.set, teamSide: viewModel.side, teamCode: viewModel.teamCode).interpolation(.none).resizable().scaledToFit().padding()
        }.padding()
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 25))
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(width:500, height: 500)
    }
    
    @ViewBuilder
    func liberosModal() -> some View {
        VStack{
            ZStack{
                Image(systemName: "multiply").font(.title2).onTapGesture {
                    viewModel.liberosModel.toggle()
                }.frame(maxWidth: .infinity, alignment: .trailing)
                Text("pick.libero".trad()).font(.title2).frame(maxWidth: .infinity, alignment: .center)
            }
            
            LazyVGrid(columns:[GridItem](repeating: GridItem(), count: 2)){
                ForEach(viewModel.players.filter{$0.position == .libero && !viewModel.liberos.contains($0)}, id:\.id){libero in
                    VStack{
                        Text("\(libero.number)").font(.title2)
                        Text("\(libero.name)")
                    }.padding().frame(maxWidth: .infinity).background(.blue).clipShape(RoundedRectangle(cornerRadius: 8)).padding().onTapGesture {
                        viewModel.liberos[viewModel.liberoIdx] = libero
                        viewModel.liberosModel.toggle()
                    }
                }
            }
            
        }.padding()
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .frame(width:500, height: 250)
        
    }
    
    @ViewBuilder
    func liberosForm()-> some View {
        VStack{
            VStack{
                Text("LIBEROS").font(.caption).foregroundColor(.gray).padding(.horizontal)
            }.frame(maxWidth: .infinity, alignment: .leading)
            VStack{
                Toggle("liberos.activate".trad(), isOn: $viewModel.hasLiberos).disabled(viewModel.match.n_players<6).tint(.cyan)
                HStack{
                    if viewModel.hasLiberos{
                        VStack{
                            Text("Libero 1:".uppercased()).font(.caption).frame(maxWidth: .infinity, alignment:.leading).foregroundStyle(.gray)
                            VStack{
                                if viewModel.liberos[0] != nil{
                                    Text("\(viewModel.liberos[0]!.number)").font(.title2)
                                    Text("\(viewModel.liberos[0]!.name)")
                                }else{
                                    Image(systemName: "person.fill.badge.plus").font(.title2).foregroundStyle(.cyan)
                                    Text("no.libero.selected".trad())
                                }
                            }.padding().frame(maxWidth: .infinity).background(viewModel.liberos[0] != nil ? .blue : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                viewModel.liberoIdx = 0
                                viewModel.liberos[0] = nil
                                viewModel.liberosModel.toggle()
                            }
                        }.padding(.top)
                        VStack{
                            Text("Libero 2:".uppercased()).font(.caption).frame(maxWidth: .infinity, alignment:.leading).foregroundStyle(.gray)
                            VStack{
                                if viewModel.liberos[1] != nil{
                                    Text("\(viewModel.liberos[1]!.number)").font(.title2)
                                    Text("\(viewModel.liberos[1]!.name)")
                                }else{
                                    Image(systemName: "person.fill.badge.plus").font(.title2).foregroundStyle(.cyan)
                                    Text("no.libero.selected".trad())
                                }
                            }.padding().frame(maxWidth: .infinity).background(viewModel.liberos[1] != nil ? .blue : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                viewModel.liberoIdx = 1
                                viewModel.liberos[1] = nil
                                viewModel.liberosModel.toggle()
                            }
                        }.padding(.top)
                    }
                }
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    @ViewBuilder
    func rotation() -> some View{
        VStack{
            VStack{
                Text("rotation".trad().uppercased()).font(.caption).foregroundColor(.gray).padding(.horizontal)
            }.frame(maxWidth: .infinity, alignment: .leading)
            VStack{
                Text("start.rotation.number".trad()).font(.caption).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                Picker("", selection: $viewModel.rotationNumber){
                    ForEach(1..<7){
                        Text("\($0)").tag($0)
                    }
                }.pickerStyle(.segmented).padding(.bottom)
                Text("rotation".trad()).font(.caption).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                VStack{
                    Court(rotation: $viewModel.rotation, numberPlayers: viewModel.match.n_players, showName: true, editable: true, teamPlayers: viewModel.players.filter{$0.position != .libero})
                    HStack{
                        Image(systemName: "backward.fill").frame(maxWidth:.infinity, maxHeight: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            viewModel.rotate(inverse: true)
                        }
                        Text("clear".trad()).frame(maxWidth:.infinity, maxHeight: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            viewModel.rotation = [nil, nil, nil, nil, nil, nil]
                        }
                        Image(systemName: "forward.fill").frame(maxWidth:.infinity, maxHeight: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            viewModel.rotate(inverse: false)
                        }
                    }.frame(width: 300, height: 50)
                    if (viewModel.rotation.filter{p in p != nil}.count == viewModel.match.n_players && !viewModel.checkSetters()){
                        Text("not.enough.setters".trad()).font(.caption).foregroundColor(.red).padding()
                    }
                    HStack{
                        ForEach(viewModel.match.sets(), id:\.id){set in
                            Text("Set \(set.number)").foregroundStyle(set.first_serve != 0 ? .cyan : .gray).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                if set.first_serve != 0{
                                    viewModel.rotationNumber = set.rotationNumber
                                    viewModel.rotation = set.rotation.get(rotate: set.rotationTurns)
                                }
                            }
                        }
                    }.padding(.top)
                }.padding().frame(maxWidth: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                
            }.padding().frame(maxWidth: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

class SetDataModel: ObservableObject{
    @Published var number: Int = 0
    @Published var first_serve: Int = 0
    @Published var rotationNumber: Int = 1
    @Published var showAlert: Bool = false
    @Published var liberos: [Player?] = [nil, nil]
    @Published var hasLiberos: Bool = false
    @Published var players: [Player] = []
    @Published var saved:Bool = false
    @Published var gameMode: String = "6-6"
    @Published var side: String = "A"
    @Published var teamCode: String
    @Published var liberosModel: Bool = false
    @Published var strictChanges: Bool = true
    @Published var errorDetail: Bool = true
    @Published var directionDetail: Bool = false
    @Published var isPlaying: Bool = false
    @Published var liberoIdx: Int = 0
    @Binding var closeModal: Bool
    @Published var qrModal: Bool = false
    var match: Match
    @Published var rotation: [Player?] = [nil, nil, nil, nil, nil, nil]
    var set: Set
    let team: Team
    
    init(team: Team, match: Match, set: Set, isPlaying: Bool = false, closeModal:Binding<Bool> = .constant(false)){
        self.number = set.number
        self.first_serve = set.first_serve
        self.match = match
        self.set = set
        self.team = team
        self.players = team.activePlayers()
        self.teamCode = team.name.prefix(3).uppercased()
        self.isPlaying = isPlaying
        self._closeModal = closeModal
        self.directionDetail = set.directionDetail
        self.errorDetail = set.errorDetail
        self.strictChanges = set.restrictChanges
        self.liberos = set.liberos.map{Player.find(id: $0 ?? 0)}
        self.hasLiberos = liberos.filter{p in p != nil}.count > 0
        self.gameMode = set.gameMode
        self.rotation = set.rotation.get(rotate: set.rotationTurns)
    }
    func validate()->Bool{
        return first_serve==0 || rotation.filter{p in p != nil}.count < match.n_players || !checkSetters()
    }
    
    func checkSetters()->Bool{
        if gameMode == "5-1"{
            return rotation.filter{$0?.position == .setter}.count >= 1
        }else if gameMode == "6-2" || gameMode == "4-2"{
            if rotation[1]?.position == .setter && rotation[4]?.position == .setter{
                return true
            }
            if rotation[2]?.position == .setter && rotation[5]?.position == .setter{
                return true
            }
            if rotation[3]?.position == .setter && rotation[0]?.position == .setter{
                return true
            }
        }else{
            return true
        }
        return false
    }
    
    func rotate(inverse: Bool = false){
        if !inverse{
            let tmp = rotation[0]
            for index in 1..<match.n_players{
                rotation[index - 1] = rotation[index]
            }
            rotation[match.n_players-1] = tmp
        }else{
            let tmp = rotation[match.n_players-1]
            for index in (0..<match.n_players-1).reversed(){
                rotation[index + 1] = rotation[index]
            }
            rotation[0] = tmp
        }
    }
    
    func onAddButtonClick(){
        set.number = number
        set.first_serve = first_serve
        set.match = match.id
        set.errorDetail = errorDetail
        set.directionDetail = directionDetail
        set.restrictChanges = strictChanges
        set.gameMode = gameMode
        set.rotationNumber = rotationNumber
//        set.rotation = rotation
        set.liberos = liberos.map{$0 != nil ? $0!.id : 0}
        if(first_serve==0 || rotation.filter{p in p != nil}.count < match.n_players){
            showAlert = true
        }else {
            let newr = Rotation.create(rotation: Rotation(team: team, one: rotation[0], two: rotation[1], three: rotation[2], four: rotation[3], five: rotation[4], six: rotation[5]))
            if newr != nil {
                set.rotation = newr!.1
                set.rotationTurns = newr!.0
                let id = set.update()
                if id {
                    if isPlaying {
                        closeModal.toggle()
                    }else{
                        self.saved = true
                    }
                }
            }
        }
        showAlert = false
    }
}
