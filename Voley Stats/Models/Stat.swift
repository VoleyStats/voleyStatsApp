import SQLite
import SwiftUI
import FirebaseFirestore

class Stat: Model {
    typealias Expression = SQLite.Expression
//    var id:Int;
    var set:Int
    var player:Int
    var match:Int
    var rotation:Rotation
    var rotationTurns:Int
    var action: Int
    var score_us: Int = 0
    var score_them: Int = 0
    var to: Int = 0
    var stage: Int
    var server: Player
    var player_in: Int? = nil
    var detail: String = ""
    var rotationCount:Int
    var setter: Player?
    var date: Date? = nil
    var order: Double
    var direction: String
    
    init(match:Int, set:Int, player:Int, action:Int, rotation:Rotation, rotationTurns: Int, rotationCount: Int, score_us:Int, score_them:Int, to:Int, stage:Int, server:Player, player_in:Int?, detail:String, setter: Player? = nil, order: Double, direction: String){
        self.match=match
        self.set=set
        self.player=player
        self.rotation=rotation
        self.action = action
        self.direction = direction
        self.score_us = score_us
        self.score_them = score_them
        self.to = to
        self.stage = stage
        self.server = server
        self.player_in = player_in
        self.detail = detail
        self.rotationTurns = rotationTurns
        self.rotationCount = rotationCount
        self.setter = setter
        self.date = nil
        self.order = order
        super.init(id: 0)
    }
    init(player:Int, action:Int, detail:String, date: Date, direction: String, setter: Player? = nil){
        self.match=0
        self.set=0
        self.player=player
        self.rotation=Rotation()
        self.action = action
        self.direction = direction
        self.score_us = 0
        self.score_them = 0
        self.to = 0
        self.stage = 0
        self.server = Player()
        self.player_in = nil
        self.detail = detail
        self.rotationTurns = 0
        self.rotationCount = 0
        self.setter = setter
        self.date = date
        self.order = 0
        super.init(id: 0)
    }
    init(id: Int, player:Int, action:Int, detail:String, date: Date, direction: String, setter: Player? = nil){
        self.match=0
        self.set=0
        self.player=player
        self.rotation=Rotation()
        self.action = action
        self.direction = direction
        self.score_us = 0
        self.score_them = 0
        self.to = 0
        self.stage = 0
        self.server = Player()
        self.player_in = nil
        self.detail = detail
        self.rotationTurns = 0
        self.rotationCount = 0
        self.setter = setter
        self.date = date
        self.order = 0
        super.init(id: id)
    }
    init(id:Int, match:Int, set:Int, player:Int, action:Int, rotation:Rotation, rotationTurns: Int, rotationCount: Int, score_us:Int, score_them:Int, to:Int, stage:Int, server:Player, player_in:Int?, detail:String, setter: Player? = nil, date: Date? = nil, order:Double, direction: String){
        self.match=match
        self.set=set
        self.player=player
        self.rotation=rotation
        self.action = action
        self.score_us = score_us
        self.score_them = score_them
        self.to = to
        self.stage = stage
        self.server = server
        self.player_in = player_in
        self.detail = detail
        self.rotationTurns = rotationTurns
        self.rotationCount = rotationCount
        self.setter = setter
        self.date = nil
        self.order = order
        self.direction = direction
        super.init(id: id)
    }
    static func ==(lhs: Stat, rhs: Stat) -> Bool {
        return lhs.id == rhs.id
    }
    override var description : String {
//        var text: String = self.get(rotate: 0).filter{$0 != nil}.reduce("["){ $0 + $1!.name + ", " }
        return "\(self.id.description)-\(self.order)-\(self.action)"
    }
    static func createStat(stat: Stat)->Stat?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if stat.id != 0 {
                try database.run(Table("stat").insert(
                    Expression<Int>("player") <- stat.player,
                    Expression<Int>("set") <- stat.set,
                    Expression<Int>("match") <- stat.match,
                    Expression<Int>("rotation") <- stat.rotation.id,
                    Expression<Int>("rotation_turns") <- stat.rotationTurns,
                    Expression<Int>("rotation_count") <- stat.rotationCount,
                    Expression<Int>("to") <- stat.to,
                    Expression<Int>("action") <- stat.action,
                    Expression<Int>("score_us") <- stat.score_us,
                    Expression<Int>("score_them") <- stat.score_them,
                    Expression<Int>("stage") <- stat.stage,
                    Expression<Int>("server") <- stat.server.id,
                    Expression<Int?>("player_in") <- stat.player_in,
                    Expression<String>("detail") <- stat.detail,
                    Expression<String>("direction") <- stat.direction,
                    Expression<Int>("setter") <- stat.setter?.id ?? 0,
                    Expression<Date?>("date") <- stat.date,
                    Expression<Double>("order") <- stat.order,
                    Expression<Int>("id") <- stat.id
                ))
            }else{
                let id = try database.run(Table("stat").insert(
                    Expression<Int>("player") <- stat.player,
                    Expression<Int>("set") <- stat.set,
                    Expression<Int>("match") <- stat.match,
                    Expression<Int>("rotation") <- stat.rotation.id,
                    Expression<Int>("rotation_turns") <- stat.rotationTurns,
                    Expression<Int>("rotation_count") <- stat.rotationCount,
                    Expression<Int>("to") <- stat.to,
                    Expression<Int>("action") <- stat.action,
                    Expression<Int>("score_us") <- stat.score_us,
                    Expression<Int>("score_them") <- stat.score_them,
                    Expression<Int>("stage") <- stat.stage,
                    Expression<Int>("server") <- stat.server.id,
                    Expression<String>("detail") <- stat.detail,
                    Expression<String>("direction") <- stat.direction,
                    Expression<Int>("setter") <- stat.setter?.id ?? 0,
                    Expression<Int?>("player_in") <- stat.player_in,
                    Expression<Double>("order") <- stat.order,
                    Expression<Date?>("date") <- stat.date
                ))
                stat.id = Int(id)
            }
//            DB.saveToFirestore(collection: "stats", object: stat)
            return stat
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
            let update = Table("stat").filter(self.id == Expression<Int>("id")).update([
                Expression<Int>("player") <- self.player,
                Expression<Int>("set") <- self.set,
                Expression<Int>("match") <- self.match,
                Expression<Int>("rotation") <- self.rotation.id,
                Expression<Int>("rotation_turns") <- self.rotationTurns,
                Expression<Int>("rotation_count") <- self.rotationCount,
                Expression<Int>("to") <- self.to,
                Expression<Int>("action") <- self.action,
                Expression<Int>("score_us") <- self.score_us,
                Expression<Int>("score_them") <- self.score_them,
                Expression<Int>("stage") <- self.stage,
                Expression<Int>("server") <- self.server.id,
                Expression<String>("detail") <- self.detail,
                Expression<String>("direction") <- self.direction,
                Expression<Int>("setter") <- self.setter?.id ?? 0,
                Expression<Int?>("player_in") <- self.player_in,
                Expression<Double>("order") <- self.order,
                Expression<Date?>("date") <- self.date
            ])
            if try database.run(update) > 0 {
//                DB.saveToFirestore(collection: "stats", object: self)
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
            let delete = Table("stat").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
//            DB.deleteOnFirestore(collection: "stats", object: self)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    
    static func all() -> [Stat]{
        var stats: [Stat] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for stat in try database.prepare(Table("stat").order(Expression<Double>("order"))) {
                stats.append(Stat(
                    id: stat[Expression<Int>("id")],
                    match: stat[Expression<Int>("match")],
                    set: stat[Expression<Int>("set")],
                    player: stat[Expression<Int>("player")],
                    action: stat[Expression<Int>("action")],
                    rotation: Rotation.find(id: stat[Expression<Int>("rotation")]) ?? Rotation(),
                    rotationTurns: stat[Expression<Int>("rotation_turns")],
                    rotationCount: stat[Expression<Int>("rotation_count")],
                    score_us: stat[Expression<Int>("score_us")],
                    score_them: stat[Expression<Int>("score_them")],
                    to: stat[Expression<Int>("to")],
                    stage: stat[Expression<Int>("stage")],
                    server: Player.find(id: stat[Expression<Int>("server")]) ?? Player(),
                    player_in: stat[Expression<Int?>("player_in")],
                    detail: stat[Expression<String>("detail")],
                    setter: Player.find(id: stat[Expression<Int>("setter")]),
                    date: stat[Expression<Date?>("date")],
                    order: stat[Expression<Double>("order")],
                    direction: stat[Expression<String>("direction")]
                ))
            }
            return stats
        } catch {
            print(error)
            return []
        }
    }
    
    static func find(id: Int) -> Stat?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let stat = try database.pluck(Table("stat").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Stat(
                id: stat[Expression<Int>("id")],
                match: stat[Expression<Int>("match")],
                set: stat[Expression<Int>("set")],
                player: stat[Expression<Int>("player")],
                action: stat[Expression<Int>("action")],
                rotation: Rotation.find(id: stat[Expression<Int>("rotation")]) ?? Rotation(),
                rotationTurns: stat[Expression<Int>("rotation_turns")],
                rotationCount: stat[Expression<Int>("rotation_count")],
                score_us: stat[Expression<Int>("score_us")],
                score_them: stat[Expression<Int>("score_them")],
                to: stat[Expression<Int>("to")],
                stage: stat[Expression<Int>("stage")],
                server: Player.find(id: stat[Expression<Int>("server")]) ?? Player(),
                player_in: stat[Expression<Int?>("player_in")],
                detail: stat[Expression<String>("detail")],
                setter: Player.find(id: stat[Expression<Int>("setter")]),
                date: stat[Expression<Date?>("date")],
                order: stat[Expression<Double>("order")],
                direction: stat[Expression<String>("direction")]
            )
        } catch {
            print(error)
            return nil
        }
    }
    
    func shareLive(){
        let db = Firestore.firestore()
        let match = Match.find(id: self.match)!
        db.collection("live_matches").document(match.code).collection("stats").document("\(self.id)").setData(toJSON())
    }
    
    static func truncate(){
        do{
            guard let database = DB.shared.db else {
                return
            }
            try database.run(Table("stat").delete())
        }catch{
            print("error truncating stat")
            return
        }
    }
    
    func hasDirectionDetail()->Bool{
        return [1, 2, 3, 4, 8, 9, 10, 11, 22, 23, 39, 40, 41].contains(self.action)
    }
    
    func hasActionDetail()->Bool{
        return [15, 16, 17, 18, 19].contains(self.action)
    }
    
    static func getMark(stats: [Stat], serve: Bool) -> Double {
        if serve {
            let s2 = stats.filter{s in return s.action==39}.count
            let s1 = stats.filter{s in return s.action==40}.count
            let op = stats.filter{s in return s.action==41}.count
            let s3 = stats.filter{s in return s.action==8}.count
            let total = stats.count
            return total > 0 ? Double(op/2 + s1 + 2*s2 + 3*s3)/Double(total) : 0
        } else {
            let op = stats.filter{s in return s.action==1}.count
            let s1 = stats.filter{s in return s.action==2}.count
            let s2 = stats.filter{s in return s.action==3}.count
            let s3 = stats.filter{s in return s.action==4}.count
            let total = stats.count
            return total > 0 ? Double(op/2 + s1 + 2*s2 + 3*s3)/Double(total) : 0
        }
    }
    
    override func toJSON()->Dictionary<String,Any>{
        return [
            "id":self.id,
            "match":self.match,
            "set":Set.find(id: self.set)?.toJSON(),
            "player":Player.find(id: self.player)?.toJSON(),
            "rotation":self.rotation.toJSON(),
            "action":Action.find(id: self.action)!.toJSON(),
            "score_us":self.score_us,
            "score_them":self.score_them,
            "to":self.to,
            "stage":self.stage,
            "server":self.server.toJSON(),
            "player_in":Player.find(id: self.player_in ?? 0)?.toJSON(),
            "detail":self.detail,
            "rotationTurns":self.rotationTurns,
            "rotationCount":self.rotationCount,
            "setter":self.setter?.toJSON(),
            "date": self.date,
            "order": self.order,
            "direction":self.direction
        ]
    }
}





