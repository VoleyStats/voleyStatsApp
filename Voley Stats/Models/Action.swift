import SQLite
import SwiftUI
import AppIntents

enum ActionAreas:Int{
    case receive
    case block
    case dig
    case set
    case serve
    case attack
    case fault
    case adjust
}

enum StatsActionAreas:String, Codable, Sendable, AppEnum{
    static var caseDisplayRepresentations: [StatsActionAreas : DisplayRepresentation] = [
        .receive: DisplayRepresentation(title: "Receive"),
        .serve: DisplayRepresentation(title: "Serve"),
        .attack: DisplayRepresentation(title: "Attack"),
//        .block: DisplayRepresentation(title: "Block")
    ]
    
    case receive = "0"
//    case block = "1"
    case serve = "4"
    case attack = "5"
    
    static var titleDisplayName: String = "Area"
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
            TypeDisplayRepresentation(
                name: "Area"
//                numericFormat: LocalizedStringResource("\(placeholder: .int) activities", table: "AppIntents")
            )
        }
}

enum Stages:Int{
    case K1 = 1
    case K2 = 0
    case K3 = 2
}
enum Directions:Int{
    case none
    case us
    case them
}
enum ActionType:Int{
    case error = 2
    case earn = 1
    case inGame = 0
    case adjust = 4
    case fault = 3
}
class Action: Equatable, Hashable {
    var id:Int;
    var name:String
    var type:Int
    var stages: [Stages]
    var directions: Directions
    var area: ActionAreas
    
    init(name:String, type:Int, id:Int, area: ActionAreas, stages: [Stages] = [.K1,.K2,.K3], directions:Directions = .none){
        self.name=name
        self.type=type
        self.id=id
        self.stages = stages
        self.directions = directions
        self.area = area
    }
    static func ==(lhs: Action, rhs: Action) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func all() -> [[Action]]{
        return buttons
    }
    func color() -> Color {
        switch self.type {
        case 0:
            return .gray
        case 1:
            return Color(hex: "6ECB63") ?? .green
        case 2:
            return Color(hex: "f2ac0a") ?? .yellow
        case 3:
            return Color(hex: "DC3535") ?? .red
        default:
            return .gray
        }
    }
    func shortName()->String{
        if self.area == .serve{
            return "serve".trad().capitalized
        }
        if self.area == .fault{
            return "fault".trad().capitalized
        }
        if self.name == "dump"{
            return "tip".trad()
        }
        if self.id == 21{
            return "dig".trad()
        }
        if self.name == "downhit"{
            return "downhit.short".trad()
        }
        return self.name.trad()
    }
    static func getByArea(area: ActionAreas)->[Action]{
        return buttons.flatMap{$0.filter{$0.area == area}}
    }
    static func getByType(type: Int)->[Action]{
        return buttons.flatMap{sub in
            sub.filter{action in
                return action.type == type
            }
        }
    }
    func getArea()->String{
        for (area, actions) in actionsByType{
            for a in actions{
                if (self.id == a){
                    return area
                }
            }
        }
        return ""
    }
    func getType()->String{
        switch self.type {
        case 0:
            return "in.play"
        case 1:
            return "earn"
        case 2:
            return "error"
        case 3:
            return "fault"
        default:
            return "in.play"
        }
    }
    static func find(id: Int) -> Action?{
        for actions in buttons {
            for action in actions {
                if action.id == id {
                    return action
                }
            }
        }
        return nil
    }
    
    func toJSON() -> Dictionary<String, Any>{
        return [
            "id":self.id,
            "name":self.name,
            "type":getType(),
            "area":self.area.rawValue
        ]
    }
}

let buttons = [
    [
        Action(name:"ace", type: 1, id: 8, area: .serve),
        Action(name:"spike", type: 1, id: 9, area: .attack),
        Action(name:"tip", type: 1, id: 10, area: .attack),
        Action(name:"blockout", type: 1, id: 11, area: .attack),
        Action(name:"downhit", type: 1, id: 12, area: .attack),
        Action(name:"block", type: 1, id: 13, area: .block),
    ],
    [
        Action(name:"serve", type: 2, id: 15, area: .serve),
        Action(name:"receive", type: 2, id: 22, area: .receive),
        
        Action(name:"dig", type: 2, id: 23, area: .dig),
        Action(name:"free ball", type: 2, id: 25, area: .dig),
        Action(name:"whose.ball", type: 2, id: 21, area: .dig),
    ],
    [
        Action(name:"spike", type: 2, id: 16, area: .attack),
        Action(name:"tip", type: 2, id: 17, area: .attack),
//        Action(name:"dump", type: 2, id: 18, area: .attack),
        Action(name:"downhit", type: 2, id: 19, area: .attack),
        Action(name:"block", type: 2, id: 20, area: .block),
        Action(name:"set", type: 2, id: 24, area: .set),
    ],
    [
        Action(name:"net", type: 3, id: 28, area: .fault),
        Action(name:"ball.handling", type: 3, id: 29, area: .fault),
        Action(name:"under", type: 3, id: 30, area: .fault),
        Action(name:"over.the.net", type: 3, id: 31, area: .fault),
        Action(name:"foot", type: 3, id: 32, area: .fault),
        Action(name:"out.rotation", type: 3, id: 33, area: .fault),
        Action(name:"backrow.attack", type: 3, id: 34, area: .fault)
    ],
    [
        Action(name:"over.pass.in.play", type: 0, id: 1, area: .receive, stages: [.K1]),
        Action(name:"1-"+"receive".trad(), type: 0, id: 2, area: .receive, stages: [.K1]),
        Action(name:"2-"+"receive".trad(), type: 0, id: 3, area: .receive, stages: [.K1]),
        Action(name:"3-"+"receive".trad(), type: 0, id: 4, area: .receive, stages: [.K1]),
        Action(name:"1-"+"serve".trad(), type: 0, id: 39, area: .serve, stages: [.K2]),
        Action(name:"2-"+"serve".trad(), type: 0, id: 40, area: .serve, stages: [.K2]),
        Action(name:"3-"+"serve".trad(), type: 0, id: 41, area: .serve, stages: [.K2]),
        Action(name:"1-free ball", type: 0, id: 35, area: .dig, stages: [.K3]),
        Action(name:"2-free ball", type: 0, id: 36, area: .dig, stages: [.K3]),
        Action(name:"3-free ball", type: 0, id: 37, area: .dig, stages: [.K3]),
        Action(name:"assist", type: 0, id: 42, area: .set),
        Action(name:"hit.in.play", type: 0, id: 6, area: .attack),
        Action(name:"downhit.in.play", type: 0, id: 14, area: .attack),
        Action(name:"block.in.play", type: 0, id: 7, area: .block),
        Action(name:"dig", type: 0, id: 5, area: .dig),
    ],
    [
        Action(name:"time.out.by", type: 4, id: 0, area: .adjust),
        Action(name:"change.player", type: 4, id: 99, area: .adjust),
        Action(name:"score.adjust", type: 4, id: 98, area: .adjust),
    ]
    
]
let actionsByType = [
    "block": [7, 13, 20, 31],
    "serve":[15, 8, 32, 39, 40, 41],
    "dig":[23, 5, 21],
    "receive":[1, 2, 3, 4, 22],
    "fault":[28, 29, 30, 31, 32, 33, 34],
    "attack":[6, 9, 10, 11, 16, 17, 18, 34],
    "set": [24, 42],
    "free": [25, 35, 36, 37],
    "downhit": [12, 14, 19]
]

let actionsToStat = [
    ActionAreas.receive:[
        "error":[22],
        "-":[2],
        "+":[3],
        "++":[4]
    ],
    ActionAreas.serve:[
        "ace":[8],
        "error":[15]
    ],
    ActionAreas.attack:[
        "kills":[6,9,10,11],
        "errors":[16,17,18,34]
    ]
]

let inGameActions = [
    [
        Action(name:"dig", type: 0, id: 5, area: .dig),
        Action(name:"1-free ball", type: 0, id: 35, area: .dig),
        Action(name:"2-free ball", type: 0, id: 36, area: .dig),
        Action(name:"3-free ball", type: 0, id: 37, area: .dig),
        

    ],
    [
        Action(name:"hit.in.play", type: 0, id: 6, area: .attack),
        Action(name:"downhit.in.play", type: 0, id: 14, area: .attack),
        Action(name:"block.in.play", type: 0, id: 7, area: .block),
        Action(name:"assist", type: 0, id: 42, area: .set)
    ],
    [
        Action(name:"over.pass.in.play", type: 0, id: 1, area: .receive, stages: [.K1]),
        Action(name:"1-"+"receive".trad(), type: 0, id: 2, area: .receive, stages: [.K1]),
        Action(name:"2-"+"receive".trad(), type: 0, id: 3, area: .receive, stages: [.K1]),
        Action(name:"3-"+"receive".trad(), type: 0, id: 4, area: .receive, stages: [.K1]),
        
        
    ],
    [
        Action(name:"1-"+"serve".trad(), type: 0, id: 39, area: .serve, stages: [.K2]),
        Action(name:"2-"+"serve".trad(), type: 0, id: 40, area: .serve, stages: [.K2]),
        Action(name:"3-"+"serve".trad(), type: 0, id: 41, area: .serve, stages: [.K2]),
    ]
]



