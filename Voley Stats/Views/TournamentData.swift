import SwiftUI

struct TournamentData: View {
    @ObservedObject var viewModel: TournamentDataModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack{
            VStack {
                VStack{
                    VStack(alignment: .leading){
                        Text("team".trad()).font(.caption)
                        ZStack{
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(.white.opacity(0.1))
                                .frame(height: 40)
                            Text(viewModel.team.name).foregroundColor(.white.opacity(0.5)).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                        }
                    }.padding(.bottom)
                    VStack(alignment: .leading){
                        Text("name".trad()).font(.caption)
                        TextField("name".trad(), text: $viewModel.name).textFieldStyle(TextFieldDark())
                    }.padding(.bottom)
                    VStack(alignment: .leading){
                        Text("location".trad()).font(.caption)
                        TextField("location".trad(), text: $viewModel.location).textFieldStyle(TextFieldDark())
                    }.padding(.bottom)
                    DatePicker("start.date".trad(), selection: $viewModel.startDate).padding(.vertical, 3)
                    DatePicker("end.date".trad(), selection: $viewModel.endDate).padding(.vertical, 3)
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
//                Text(viewModel.pass ? "remove pass" : "add pass").padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding().onTapGesture {
//                    viewModel.pass.toggle()
//                }
                Button(action:{
                    viewModel.onAddButtonClick()
                    if viewModel.back{
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }){
                    Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                }.disabled(viewModel.emptyFields()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.emptyFields() ? .gray : .cyan)
            }.padding()
        }
        .navigationTitle(viewModel.tournament == nil ? "tournament.new".trad() : "tournament.setup".trad())
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.swatch.dark.high).foregroundColor(.white)
    }
}

class TournamentDataModel: ObservableObject{
    @Published var name: String = ""
    @Published var location: String = ""
    @Published var startDate:Date = Date()
    @Published var endDate:Date = Date()
    @Published var back:Bool=false
    @Published var pass:Bool = false
    var team: Team
    var tournament: Tournament? = nil
    
    init(team: Team, tournament:Tournament?){
        self.team = team
        name = tournament?.name ?? ""
        location = tournament?.location ?? ""
        startDate = tournament?.startDate ?? Date()
        endDate = tournament?.endDate ?? Date()
        self.tournament = tournament
        self.pass = tournament?.pass ?? false
    }
    func emptyFields()->Bool{
        return name == "" || location == ""
    }
    func onAddButtonClick(){
        if self.tournament != nil {
            tournament!.name = self.name
            tournament!.location = self.location
            tournament!.startDate = self.startDate
            tournament!.endDate = self.endDate
            if !tournament!.pass && self.pass{
                tournament!.addPass()
                self.back = true
            }else{
                let updated = tournament!.update()
                if updated {
                    self.back=true
                }
            }
        }else{
            let newTournament = Tournament(name: self.name, team: self.team, location: self.location, startDate: self.startDate, endDate: self.endDate, pass: self.team.pass)
            let id = Tournament.create(tournament: newTournament)
            if id != nil {
                self.back=true
            }
        }
        
        
    }
}



