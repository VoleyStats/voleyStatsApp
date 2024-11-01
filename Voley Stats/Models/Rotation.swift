import SQLite
import SwiftUI
import CoreImage.CIFilterBuiltins

class Rotation: Model {
    typealias Expression = SQLite.Expression
//    var id:Int;
    var name:String?
    var team: Team
    var one:Player?
    var two:Player?
    var three:Player?
    var four: Player?
    var five: Player?
    var six:Player?
    static func ==(lhs: Rotation, rhs: Rotation) -> Bool {
        return lhs.id == rhs.id
    }
    init(team:Team, one:Player?, two:Player?, three: Player?, four:Player?, five:Player?, six: Player?){
        self.team=team
        self.one = one
        self.two = two
        self.three = three
        self.four = four
        self.five = five
        self.six = six
        super.init(id: 0)
    }
    
    init(team:Team, rotationArray:[Player?]){
        self.team=team
        self.one = rotationArray[0]
        self.two = rotationArray[1]
        self.three = rotationArray[2]
        self.four = rotationArray[3]
        self.five = rotationArray[4]
        self.six = rotationArray[5]
        super.init(id: 0)
    }
    
    init(team:Team, one:Player, two:Player, three: Player, four:Player){
        self.team=team
        self.one = one
        self.two = two
        self.three = three
        self.four = four
        super.init(id: 0)
    }
    
    init(team:Team, one:Player, two:Player, three: Player){
        self.team=team
        self.one = one
        self.two = two
        self.three = three
        super.init(id: 0)
    }
    
    init(team:Team){
        self.team=team
        super.init(id: 0)
    }
    init(){
        self.team=Team(name: "", organization: "", category: "", gender: "", color: .red, order: 0, pass: false, id: 0)
        super.init(id: 0)
    }
    
    init(id:Int, name:String?, team:Team, one:Player?, two:Player?, three: Player?, four:Player?, five:Player?, six: Player?){
        self.name=name
        self.team=team
        self.one = one
        self.two = two
        self.three = three
        self.four = four
        self.five = five
        self.six = six
        super.init(id: id)
    }
    
    override var description : String {
        var text: String = self.get(rotate: 0).filter{$0 != nil}.reduce("["){ $0 + $1!.name + ", " }
        return text.prefix(text.count-2) + "]"
    }
    
    override func toJSON()->Dictionary<String, Any>{
        return [
            "id":self.id,
            "name": self.name,
            "team": self.team.id,
            "one": Player.find(id: self.one?.id ?? 0)?.toJSON(),
            "two": Player.find(id: self.two?.id ?? 0)?.toJSON(),
            "three": Player.find(id: self.three?.id ?? 0)?.toJSON(),
            "four": Player.find(id: self.four?.id ?? 0)?.toJSON(),
            "five": Player.find(id: self.five?.id ?? 0)?.toJSON(),
            "six": Player.find(id: self.six?.id ?? 0)?.toJSON()
        ]
    }
    
    static func create(rotation: Rotation, force: Bool = false)->(Int, Rotation)?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            let exists = Rotation.exists(team: rotation.team, one: rotation.one, two: rotation.two, three: rotation.three, four: rotation.four, five: rotation.five, six: rotation.six)
            if exists != nil && !force{
                return exists
            }else{
                if rotation.id != 0{
                    try database.run(Table("rotation").insert(
                        Expression<Int>("id") <- rotation.id,
                        Expression<String?>("name") <- rotation.name,
                        Expression<Int>("team") <- rotation.team.id,
                        Expression<Int>("1") <- rotation.one?.id ?? 0,
                        Expression<Int>("2") <- rotation.two?.id ?? 0,
                        Expression<Int>("3") <- rotation.three?.id ?? 0,
                        Expression<Int>("4") <- rotation.four?.id ?? 0,
                        Expression<Int>("5") <- rotation.five?.id ?? 0,
                        Expression<Int>("6") <- rotation.six?.id ?? 0
                    ))
                }else{
                    let id = try database.run(Table("rotation").insert(
                        Expression<String?>("name") <- rotation.name,
                        Expression<Int>("team") <- rotation.team.id,
                        Expression<Int>("1") <- rotation.one?.id ?? 0,
                        Expression<Int>("2") <- rotation.two?.id ?? 0,
                        Expression<Int>("3") <- rotation.three?.id ?? 0,
                        Expression<Int>("4") <- rotation.four?.id ?? 0,
                        Expression<Int>("5") <- rotation.five?.id ?? 0,
                        Expression<Int>("6") <- rotation.six?.id ?? 0
                    ))
                    rotation.id = Int(id)
                }
//                DB.saveToFirestore(collection: "rotations", object: rotation)
            }
            return (0, rotation)
        } catch {
            print("ERROR: \(error)")
        }
        return nil
    }
    func update() -> Bool{
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            
            let update = Table("rotation").filter(self.id == Expression<Int>("id")).update([
                Expression<String?>("name") <- self.name,
                Expression<Int>("team") <- self.team.id,
                Expression<Int>("1") <- self.one?.id ?? 0,
                Expression<Int>("2") <- self.two?.id ?? 0,
                Expression<Int>("3") <- self.three?.id ?? 0,
                Expression<Int>("4") <- self.four?.id ?? 0,
                Expression<Int>("5") <- self.five?.id ?? 0,
                Expression<Int>("6") <- self.six?.id ?? 0
            ])
            if try database.run(update) > 0 {
//                DB.saveToFirestore(collection: "rotations", object: self)
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    func delete() -> Bool{
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            let delete = Table("rotation").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
//            DB.deleteOnFirestore(collection: "rotations", object: self)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    static func all() -> [Rotation]{
        var rotations: [Rotation] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for rotation in try database.prepare(Table("rotation")) {
                rotations.append(Rotation(
                    id: rotation[Expression<Int>("id")],
                    name: rotation[Expression<String?>("name")],
                    team: Team.find(id: rotation[Expression<Int>("team")])!,
                    one: Player.find(id: rotation[Expression<Int>("1")]),
                    two: Player.find(id: rotation[Expression<Int>("2")]),
                    three: Player.find(id: rotation[Expression<Int>("3")]),
                    four: Player.find(id: rotation[Expression<Int>("4")]),
                    five: Player.find(id: rotation[Expression<Int>("5")]),
                    six: Player.find(id: rotation[Expression<Int>("6")])))
            }
            return rotations
        } catch {
            print(error)
            return []
        }
    }
    static func find(id: Int) -> Rotation?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
//            print("Finding: ", try database.pluck(Table("rotation").filter(Expression<Int>("id") == id)))
            guard let rotation = try database.pluck(Table("rotation").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Rotation(
                    id: rotation[Expression<Int>("id")],
                    name: rotation[Expression<String?>("name")],
                    team: Team.find(id: rotation[Expression<Int>("team")])!,
                    one: Player.find(id: rotation[Expression<Int>("1")]),
                    two: Player.find(id: rotation[Expression<Int>("2")]),
                    three: Player.find(id: rotation[Expression<Int>("3")]),
                    four: Player.find(id: rotation[Expression<Int>("4")]),
                    five: Player.find(id: rotation[Expression<Int>("5")]),
                    six: Player.find(id: rotation[Expression<Int>("6")]))
        } catch {
            print(error)
            return nil
        }
    }
    func get(rotate: Int = 0, inverse: Bool = false) -> [Player?]{
        var rotation = [one, two, three, four, five, six]
        let count = rotation.filter{$0 != nil}.count
        if !inverse {
            for i in 0..<rotate {
                let tmp = rotation[0]
                for index in 1..<count{
                    rotation[index - 1] = rotation[index]
                }
                rotation[count-1] = tmp
            }
        } else {
            for i in 0..<rotate{
                let tmp = rotation[count-1]
                for index in (0..<count-1).reversed(){
                    rotation[index+1]=rotation[index]
                }
                rotation[0]=tmp
            }
        }
        return rotation
    }
    func server(rotate: Int = 0) -> Player{
        return self.get(rotate: rotate)[0]!
    }
    static func exists(team:Team, one:Player?, two:Player?, three: Player?, four:Player?, five:Player?, six: Player?) -> (Int, Rotation)?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            let search = Rotation(team: team, one: one, two: two, three: three, four: four, five: five, six: six)
//            print("search:", search.description)
            var rotation:Row? = nil
            var rotate: Int = 0
            for r in 0..<search.countPlayers(){
                var rotArray = search.get(rotate: r, inverse: false)
//                print(r, rotArray.map{$0?.name})
                rotation = try database.pluck(Table("rotation").filter(
                    Expression<Int>("1") == rotArray[0]?.id ?? 0 &&
                    Expression<Int>("2") == rotArray[1]?.id ?? 0 &&
                    Expression<Int>("3") == rotArray[2]?.id ?? 0 &&
                    Expression<Int>("4") == rotArray[3]?.id ?? 0 &&
                    Expression<Int>("5") == rotArray[4]?.id ?? 0 &&
                    Expression<Int>("6") == rotArray[5]?.id ?? 0 &&
                    Expression<Int>("team") == team.id
                ))
                if rotation != nil {
                    rotate = r == 0 ? 0 : 6-r
                    break
                }
            }
//            guard let rotation = try database.pluck(Table("rotation").filter(Expression<Int>("1") == one?.id ?? 0 && Expression<Int>("2") == two?.id ?? 0 && Expression<Int>("3") == three?.id ?? 0 && Expression<Int>("4") == four?.id ?? 0 && Expression<Int>("5") == five?.id ?? 0 && Expression<Int>("6") == six?.id ?? 0 && Expression<Int>("team") == team.id)) else {
//                return nil
//            }
            if rotation == nil{
                return nil
            }
            
            let found = Rotation(
                    id: rotation![Expression<Int>("id")],
                    name: rotation![Expression<String?>("name")],
                    team: Team.find(id: rotation![Expression<Int>("team")])!,
                    one: Player.find(id: rotation![Expression<Int>("1")]),
                    two: Player.find(id: rotation![Expression<Int>("2")]),
                    three: Player.find(id: rotation![Expression<Int>("3")]),
                    four: Player.find(id: rotation![Expression<Int>("4")]),
                    five: Player.find(id: rotation![Expression<Int>("5")]),
                    six: Player.find(id: rotation![Expression<Int>("6")]))
            return (rotate, found)
        } catch {
            print(error)
            return nil
        }
    }
    func changePlayer(player: Player, change: Player, rotationTurns: Int)->(Int, Rotation)?{
        let newRotation = self;
        if newRotation.one == player{
            newRotation.one = change
        }
        if newRotation.two == player{
            newRotation.two = change
        }
        if newRotation.three == player{
            newRotation.three = change
        }
        if newRotation.four == player{
            newRotation.four = change
        }
        if newRotation.five == player{
            newRotation.five = change
        }
        if newRotation.six == player{
            newRotation.six = change
        }
        let rotArray = newRotation.get(rotate: rotationTurns)
        let new = Rotation.create(rotation: Rotation(team: self.team, one: rotArray[0], two: rotArray[1], three: rotArray[2], four: rotArray[3], five: rotArray[4], six: rotArray[5]))
        return new
    }
    static func truncate(){
        do{
            guard let database = DB.shared.db else {
                return
            }
            try database.run(Table("rotation").delete())
        }catch{
            print("error truncating rotation")
            return
        }
    }
    func checkSetters(gameMode: String, rotationTurns: Int)->Bool{
        let rotation = self.get(rotate: rotationTurns)
        let front = [rotation[1],rotation[2],rotation[3]].filter{$0?.position == .setter}.count
        let back = [rotation[0],rotation[4],rotation[5]].filter{$0?.position == .setter}.count
        if gameMode == "5-1"{
            return front+back >= 1
        }else if gameMode == "6-2" || gameMode == "4-2"{
            return back >= 1 && front >= 1
        }else{
            return true
        }
    }
    func getSetter(gameMode: String, rotationTurns: Int) -> Player{
        let rotation = self.get(rotate: rotationTurns)
        switch gameMode{
        case "6-6":
            return self.four == nil ? rotation[1]! : rotation[2]!
        case "4-2":
            return [rotation[1], rotation[2], rotation[3]].filter{$0?.position == .setter}.first!!
        case "6-2":
            return [rotation[0], rotation[4], rotation[5]].filter{$0?.position == .setter}.first!!
        case "5-1":
            return rotation.filter{$0?.position == .setter}.first!!
        default:
            return self.two!
        }
    }
    func countPlayers()->Int{
        return self.get().filter{$0 != nil}.count
    }
    func genrateQR(set: Set, teamSide: String, teamCode: String) -> Image{
        var data = [teamCode, teamSide,
                    "{\"ZN1\":\"\(self.one!.number)\",\"ZN2\":\"\(self.two!.number)\",\"ZN3\":\"\(self.three!.number)\",\"ZN4\":\"\(self.four!.number)\",\"ZN5\":\"\(self.five != nil ? String(self.five!.number) : "null")\",\"ZN6\":\"\(self.six != nil ? String(self.six!.number) : "null")\"}",
                    "\(set.number)"]
        let context = CIContext()
        let generator = CIFilter.qrCodeGenerator()
        generator.message = Data(data.description.utf8)
        if let output = generator.outputImage{
            if let cgimg = context.createCGImage(output, from: output.extent){
                return Image(uiImage: UIImage(cgImage: cgimg))
            }
        }
        return Image(systemName: "xmark.circle")
    }
}
