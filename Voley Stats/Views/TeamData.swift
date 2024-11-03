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
                                                    if player.team == viewModel.team!.id {
                                                        player.team = 0
                                                        if player.update(){
                                                            viewModel.getPlayers()
                                                        }
                                                    }else{
                                                        if viewModel.team!.deletePlayer(player: player){
                                                            viewModel.getPlayers()
                                                        }
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
                                            Text("category".trad().uppercased()).font(.caption)
                                            Dropdown(selection: $viewModel.category, items: viewModel.categories)
                                        }.padding(.bottom).frame(maxWidth: .infinity, alignment: .leading).zIndex(1)
                                        //                                    HStack{
                                        //                                        Text("category".trad()).frame(maxWidth: .infinity, alignment: .leading)
                                        //                                        Picker(selection: $viewModel.categoryId, label: Text("category".trad())) {
                                        //                                            Text("pick.one".trad()).tag(0)
                                        //                                            Text("benjamin".trad()).tag(1)
                                        //                                            Text("alevin".trad()).tag(2)
                                        //                                            Text("infantil".trad()).tag(3)
                                        //                                            Text("cadete".trad()).tag(4)
                                        //                                            Text("juvenil".trad()).tag(5)
                                        //                                            Text("junior".trad()).tag(6)
                                        //                                            Text("senior".trad()).tag(7)
                                        //                                        }
                                        //                                    }.padding(.bottom)
                                        //                                    Spacer()
                                        VStack(alignment: .leading){
                                            Text("gender".trad()).font(.caption)
                                            Picker(selection: $viewModel.genderId, label: Text("gender".trad())) {
                                                Text("male".trad()).tag(1)
                                                Text("female".trad()).tag(2)
                                            }.pickerStyle(.segmented)
                                        }.padding(.bottom)
                                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                                }.clipped()
                            }.padding(.bottom)
//                            Spacer()
                            Section{
                                VStack{
                                    Text("Color").font(.caption).padding([.top, .leading]).frame(maxWidth: .infinity, alignment: .leading)
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
                                    }.padding()
                                }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            }.padding(.bottom)
//                            Spacer()
//                            Text(viewModel.pass ? "remove pass" : "add pass").padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding().onTapGesture {
//                                viewModel.pass.toggle()
//                            }
//                            Spacer()
                            Button(action:{
                                if viewModel.onAddButtonClick(){
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }){
                                Text("save".trad())
                            }.frame(maxWidth: .infinity, alignment: .center).disabled(viewModel.emptyFields()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.emptyFields() ? .gray : .cyan)
                            if viewModel.team != nil{
                                Button(action:{
                                    if viewModel.team!.delete(){
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
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
        
        .onAppear{
            viewModel.getPlayers()
        }
        .background(Color.swatch.dark.high).foregroundColor(.white)
        .navigationTitle("team.data".trad())
    }
}

class TeamDataModel: ObservableObject{
    @Published var deleteDialog: Bool = false
    @Published var name: String = ""
    @Published var organization: String = ""
    @Published var selectedColor: Int = 0
    var categories: [Category] = [Category(id: 1, name: "Benjamin"), Category(id: 2, name: "Alevin"), Category(id: 3, name: "Infantil"), Category(id: 4, name: "Cadete"), Category(id: 5, name: "Juvenil"), Category(id: 6, name: "Junior"), Category(id: 7, name: "Senior")]
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
        pass = team?.pass ?? false
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
                let newTeam = Team(name: name, organization: organization, category: category!.name, gender: gender[genderId], color: color, order: (Team.all().last?.order ?? 0)+1, pass: SeasonPass().active, id: nil)
                let id = Team.createTeam(team: newTeam)
                return id != nil
            }
        }
        return false
    }
}


