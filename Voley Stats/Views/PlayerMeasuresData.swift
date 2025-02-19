import SwiftUI

struct PlayerMeasuresData: View {
    @ObservedObject var viewModel: PlayerMeasuresDataModel
    @Binding var measureAdded: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            VStack{
                Section{
                    VStack{
                        VStack(alignment: .leading){
                            Text("player".trad()).font(.caption)
//                            TextField("player".trad(), text: $viewModel.player.name).textFieldStyle(TextFieldDark()).disabled(true)
                            ZStack{
                                RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.05)).frame(height: 45)
                                Text(viewModel.player.name).foregroundStyle(.white.opacity(0.5)).padding().frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }.padding(.bottom)
                        DatePicker("date".trad(), selection: $viewModel.date, displayedComponents: [.date]).padding(.vertical, 3)
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Section{
                    HStack{
                        VStack(alignment: .leading){
                            Text("height".trad()).font(.caption)
                            TextField("height".trad(), value: $viewModel.height, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("weight".trad()).font(.caption)
                            TextField("weight".trad(), value: $viewModel.weight, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("breadth".trad()).font(.caption)
                            TextField("breadth".trad(), value: $viewModel.breadth, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Section{
                    HStack{
                        VStack(alignment: .leading){
                            Text("one.hand.reach".trad()).font(.caption)
                            TextField("one.hand.reach".trad(), value: $viewModel.oneHandReach, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("two.hand.reach".trad()).font(.caption)
                            TextField("two.hand.reach".trad(), value: $viewModel.twoHandReach, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Section{
                    HStack{
                        VStack(alignment: .leading){
                            Text("attack.reach".trad()).font(.caption)
                            TextField("attack.reach".trad(), value: $viewModel.attackReach, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("block.reach".trad()).font(.caption)
                            TextField("block.reach".trad(), value: $viewModel.blockReach, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Button(action:{
                    viewModel.onAddButtonClick()
                    if viewModel.saved{
//                        dismiss()
                        measureAdded.toggle()
                    }
                }){
                    Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(.cyan)
                
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
        
        }//.background(Color.swatch.dark.high)
            .foregroundColor(.white)
            .navigationTitle("player.measures".trad())
    }
}

class PlayerMeasuresDataModel: ObservableObject{
    @Published var height: Int = 0
    @Published var weight: Double = 0
    @Published var oneHandReach: Int = 0
    @Published var twoHandReach: Int = 0
    @Published var attackReach: Int = 0
    @Published var blockReach: Int = 0
    @Published var breadth: Int = 0
    @Published var date: Date = Date()
    @Published var saved: Bool = false
    
    var player: Player
    var playerMeasures: PlayerMeasures?
    
    init(player: Player, measures: PlayerMeasures? = nil){
        self.playerMeasures = measures
        self.player = player
        self.height = measures?.height ?? 0
        self.weight = measures?.weight ?? 0
        self.oneHandReach = measures?.oneHandReach ?? 0
        self.twoHandReach = measures?.twoHandReach ?? 0
        self.attackReach = measures?.attackReach ?? 0
        self.blockReach = measures?.blockReach ?? 0
        self.breadth = measures?.breadth ?? 0
        self.date = measures?.date ?? .now
        
    }
    func onAddButtonClick(){
        if self.playerMeasures != nil {
            playerMeasures!.date = date
            playerMeasures!.height = height
            playerMeasures!.weight = weight
            playerMeasures!.breadth = breadth
            playerMeasures!.oneHandReach = oneHandReach
            playerMeasures!.twoHandReach = twoHandReach
            playerMeasures!.attackReach = attackReach
            playerMeasures!.blockReach = blockReach
            let updated = playerMeasures?.update()
            if updated ?? false {
                saved.toggle()
            }
        }else{
            let newPlayer = PlayerMeasures(player: player, date: date, height: height, weight: weight, oneHandReach: oneHandReach, twoHandReach: twoHandReach, attackReach: attackReach, blockReach: blockReach, breadth: breadth)
            let id = PlayerMeasures.create(measure: newPlayer)
            if id != nil {
                saved.toggle()
            }
        }
        
        
    }
}



