import SwiftUI

struct TeamData: View {
    @ObservedObject var viewModel: TeamDataModel
    @EnvironmentObject var path: PathManager
    let colors : [Color] = [.red, .blue, .green, .orange, .purple, .gray]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
            VStack {
                HStack(alignment: .top) {
                    if (viewModel.team != nil){
                        VStack {
                            Text("players".trad()).font(.title).padding()
                            Divider().background(Color.gray)
                            if viewModel.players.isEmpty {
                                EmptyState(icon: Image(systemName: "person.3.fill"), msg: "no.players".trad(), width: 100, button:{
                                    NavigationLink(destination: PlayerData(viewModel: PlayerDataModel(team: viewModel.team!, player: nil))){
                                        Text("player.add".trad())
                                    }.foregroundStyle(.cyan)
                                })
                            }else{
                                ScrollView(.vertical, showsIndicators: false){
                                    ForEach(viewModel.players, id:\.id){player in
                                        //                                    NavigationLink(destination: PlayerData(viewModel: PlayerDataModel(team: viewModel.team, player: player))){
                                        NavigationLink(destination: PlayerView(viewModel: PlayerViewModel(player: player))){
                                            HStack {
                                                if (player.active == 1){
                                                    Button(action:{
                                                        player.active = 0
                                                        if player.update(){
                                                            viewModel.getPlayers()
                                                        }
                                                    }){
                                                        Image(systemName: "eye.fill")
                                                    }
                                                }else{
                                                    Button(action:{
                                                        player.active = 1
                                                        if player.update(){
                                                            viewModel.getPlayers()
                                                        }
                                                    }){
                                                        Image(systemName: "eye.slash.fill").foregroundColor(.gray)
                                                    }
                                                }
                                                Text("\(player.number)").padding()
                                                Text("\(player.name)").frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Button(action:{
                                                    if player.delete(fromTeam: true){
                                                            viewModel.getPlayers()
                                                        }
                                                }){
                                                    Image(systemName: "multiply")
                                                }.padding()
                                            }
                                            .padding(.horizontal)
                                            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(player.active == 1 ? 0.1 : 0.05)))
                                            .frame(maxWidth: .infinity)
                                            .confirmationDialog("player.delete.description".trad(), isPresented: $viewModel.deleteDialog, titleVisibility: .visible){
                                                Button("player.delete".trad(), role: .destructive){
                                                    if player.delete(){
                                                        viewModel.getPlayers()
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }.padding()
                            }
                            Divider().background(Color.gray)
                            NavigationLink(destination: PlayerData(viewModel: PlayerDataModel(team: viewModel.team!, player: nil))){
                                Image(systemName: "plus")
                                Text("player.add".trad())
                            }.padding().foregroundColor(Color.cyan)
                        }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().frame(maxWidth: .infinity)
                        
                    }
                    VStack{
                        
                        VStack{
                            Section{
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1))
                                    VStack{
                                        //                                    Spacer()
                                        VStack(alignment: .leading){
                                            Text("name".trad()).font(.caption)
                                            TextField("name".trad(), text: $viewModel.name.max(18)).textFieldStyle(TextFieldDark())
                                            if viewModel.name.count >= 18{
                                                Text("max.characters".trad()).font(.caption)
                                            }
                                        }.padding(.bottom)
                                        //                                    Spacer()
                                        VStack(alignment: .leading){
                                            Text("organization".trad()).font(.caption)
                                            TextField("organization".trad(), text: $viewModel.organization).textFieldStyle(TextFieldDark())
                                        }.padding(.bottom)
                                        //                                    Spacer()
                                        VStack(alignment: .leading){
                                            Text("category".trad()).font(.caption)
                                            Dropdown(selection: $viewModel.category, items: viewModel.categories)
                                        }.padding(.bottom).frame(maxWidth: .infinity, alignment: .leading).zIndex(1)
                                        VStack(alignment: .leading){
                                            Text("gender".trad()).font(.caption)
                                            Picker(selection: $viewModel.genderId, label: Text("gender".trad())) {
                                                Text("male".trad()).tag(1)
                                                Text("female".trad()).tag(2)
                                            }.pickerStyle(.segmented)
                                        }.padding(.bottom)
                                        
                                        VStack{
                                            Text("Color").font(.caption).frame(maxWidth: .infinity, alignment: .leading)
                                            ScrollView(.horizontal){
                                                HStack{
                                                    ForEach(colors, id: \.self){color in
                                                        ZStack{
                                                            Circle().strokeBorder(viewModel.color == color ? .white : .clear, lineWidth: 3)
                                                                .background(Circle().fill(color)).frame(width: 40, height: 40).onTapGesture{
                                                                    viewModel.color = color
                                                                }
                                                            
                                                        }.padding(.horizontal, 3)
                                                    }
                                                }
                                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                        }.padding(.bottom)
                                        
                                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                                }.clipped()
                            }.padding(.bottom)
                            
                            Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                                .disabled(viewModel.emptyFields())
                                .padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.emptyFields() ? .gray : .cyan).onTapGesture {
                                if viewModel.onAddButtonClick(){
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                            
                            if viewModel.team != nil{
                                Button(action:{
                                    viewModel.deleteTeamDialog.toggle()
                                }){
                                    HStack{
                                        Text("team.delete.title".trad())
                                        Image(systemName: "trash.fill").padding(.horizontal)
                                    }
                                }.frame(maxWidth: .infinity, alignment: .center).disabled(viewModel.team == nil).padding().background(viewModel.team == nil ? .white.opacity(0.1) : .red.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor( viewModel.team == nil ? .gray : .red )
                            }
//                            Spacer()
//                            Spacer()
                        }.padding()
                    }
                }.frame(maxHeight: .infinity, alignment: .top)
            }
            .alert("team.delete.message".trad(), isPresented: $viewModel.deleteTeamDialog){
                Button("cancel".trad(), role: .cancel){}
                Button("keep.players".trad()){
                    if viewModel.team!.delete(deletePlayers: false){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                Button("team.delete.title".trad(), role: .destructive){
                    if viewModel.team!.delete(){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
            }
        .onAppear{
            viewModel.getPlayers()
        }
        .background(Color.swatch.dark.high).foregroundColor(.white)
        .navigationTitle("team.data".trad())
    }
}

class TeamDataModel: ObservableObject{
    @Published var deleteDialog: Bool = false
    @Published var deleteTeamDialog: Bool = false
    @Published var name: String = ""
    @Published var organization: String = ""
    @Published var selectedColor: Int = 0
    var categories: [Category] = [Category(id: 1, name: "benjamin"), Category(id: 2, name: "alevin"), Category(id: 3, name: "infantil"), Category(id: 4, name: "cadete"), Category(id: 5, name: "juvenil"), Category(id: 6, name: "junior"), Category(id: 7, name: "senior")]
    @Published var category: Category? = nil
//    @Published var categorySel: [CategoryGroup] = []
    var gender: Array = ["pick.one".trad(), "Male", "Female"]
    @Published var genderId: Int = 0
    @Published var team: Team? = nil
    @Published var players: [Player] = []
    @Published var showAlert: Bool = false
    @Published var color: Color = .orange
    @Published var load: Bool = true
    @Published var pass: Bool = false
    var update: Bool = false
    
    init(team: Team?){
        self.team = team
        name = team?.name ?? ""
        organization = team?.orgnization ?? ""
        category = categories.filter{$0.name == team?.category}.first
        genderId = gender.firstIndex(of: team?.gender ?? "pick.one".trad())!
        color = team?.color ?? .orange
        pass = team?.pass ?? SeasonPass().active
    }
    func emptyFields() -> Bool{
        return genderId == 0 || category == nil || name.isEmpty || organization.isEmpty
    }
    func getPlayers(){
        players = self.team?.players().sorted{ $0.number < $1.number} ?? []
    }
    func onAddButtonClick()->Bool{
        if(name == "" || organization == "" || genderId == 0 || category == nil) {
            showAlert = true
        }else{
            if self.team != nil {
                team!.name = name
                team!.category = category!.name
                team!.gender = gender[genderId]
                team!.orgnization = organization
                team!.color = color
                if !team!.pass && self.pass{
                    team?.addPass()
                    return true
                }else{
                    return team!.update()
                }
            }else{
                let newTeam = Team(name: name, organization: organization, category: category!.name, gender: gender[genderId], color: color, order: (Team.all().last?.order ?? 0)+1, pass: pass, seasonEnd: SeasonPass().endDate, id: nil)
                let id = Team.createTeam(team: newTeam)
                return id != nil
            }
        }
        return false
    }
}


