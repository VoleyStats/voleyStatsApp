import SQLite
import SwiftUI

class Set: Model {
    typealias Expression = SQLite.Expression
//    var id:Int;
    var number:Int
    var first_serve:Int
    var match:Int
    var rotation:Rotation
    var result: Int = 0
    var score_us: Int = 0
    var score_them: Int = 0
    var liberos: [Int?]
    var gameMode: String = "6-6"
    var rotationTurns: Int
    var rotationNumber:Int
    var directionDetail:Bool
    var errorDetail:Bool
    var restrictChanges:Bool
    
    init(number:Int, first_serve:Int, match:Int, rotation:Rotation, liberos:[Int?], rotationTurns: Int, rotationNumber:Int, directionDetail:Bool, errorDetail:Bool, restrictChanges:Bool, gameMode:String = "6-6"){
        self.number=number
        self.first_serve=first_serve
        self.match=match
        self.rotation=rotation
//        self.id = 0
        self.liberos = liberos
        self.gameMode = gameMode
        self.rotationTurns = rotationTurns
        self.directionDetail = directionDetail
        self.errorDetail = errorDetail
        self.rotationNumber = rotationNumber
        self.restrictChanges = restrictChanges
        super.init(id: 0)
    }
    init(id:Int, number:Int, first_serve:Int, match:Int, rotation:Rotation, liberos:[Int?], rotationTurns: Int, rotationNumber:Int, directionDetail:Bool, errorDetail:Bool, restrictChanges:Bool, result: Int, score_us:Int, score_them:Int, gameMode:String = "6-6"){
        self.number=number
        self.first_serve=first_serve
        self.match=match
        self.rotation=rotation
//        self.id=id
        self.result = result
        self.score_us = score_us
        self.score_them = score_them
        self.liberos = liberos
        self.gameMode = gameMode
        self.rotationTurns = rotationTurns
        self.directionDetail = directionDetail
        self.errorDetail = errorDetail
        self.rotationNumber = rotationNumber
        self.restrictChanges = restrictChanges
        super.init(id: id)
    }
    static func ==(lhs: Set, rhs: Set) -> Bool {
        return lhs.id == rhs.id
    }
    
    override func toJSON()->Dictionary<String,Any>{
        return [
            "id":self.id,
            "number":self.number,
            "first_serve":self.first_serve,
            "match":self.match,
            "rotation":self.rotation.id,
            "result":self.result,
            "score_us":self.score_us,
            "score_them":self.score_them,
            "liberos":self.liberos,
            "gameMode":self.gameMode,
            "rotation_turns":self.rotationTurns,
            "rotation_number":self.rotationNumber,
            "direction_detail":self.directionDetail,
            "error_detail":self.errorDetail,
            "restrict_changes":self.restrictChanges
        ]
    }
    
    static func createSet(set: Set)->Set?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if set.id != 0{
                try database.run(Table("set").insert(
                    Expression<Int>("number") <- set.number,
                    Expression<Int>("first_serve") <- set.first_serve,
                    Expression<Int>("match") <- set.match,
                    Expression<Int>("rotation") <- set.rotation.id,
                    Expression<Int?>("libero1") <- set.liberos[0],
                    Expression<Int?>("libero2") <- set.liberos[1],
                    Expression<Int>("result") <- set.result,
                    Expression<Int>("score_us") <- set.score_us,
                    Expression<Int>("score_them") <- set.score_them,
                    Expression<Int>("rotation_turns") <- set.rotationTurns,
                    Expression<Int>("rotation_number") <- set.rotationNumber,
                    Expression<Bool>("error_detail") <- set.errorDetail,
                    Expression<Bool>("direction_detail") <- set.directionDetail,
                    Expression<Bool>("restrict_changes") <- set.restrictChanges,
                    Expression<String>("game_mode") <- set.gameMode,
                    Expression<Int>("id") <- set.id
                ))
            }else{
                let id = try database.run(Table("set").insert(
                    Expression<Int>("number") <- set.number,
                    Expression<Int>("first_serve") <- set.first_serve,
                    Expression<Int>("match") <- set.match,
                    Expression<Int>("rotation") <- set.rotation.id,
                    Expression<Int?>("libero1") <- set.liberos[0],
                    Expression<Int?>("libero2") <- set.liberos[1],
                    Expression<Int>("result") <- set.result,
                    Expression<Int>("score_us") <- set.score_us,
                    Expression<Int>("score_them") <- set.score_them,
                    Expression<Int>("rotation_turns") <- set.rotationTurns,
                    Expression<Int>("rotation_number") <- set.rotationNumber,
                    Expression<Bool>("error_detail") <- set.errorDetail,
                    Expression<Bool>("direction_detail") <- set.directionDetail,
                    Expression<Bool>("restrict_changes") <- set.restrictChanges,
                    Expression<String>("game_mode") <- set.gameMode
                ))
                set.id = Int(id)
            }
//            DB.saveToFirestore(collection: "sets", object: set)
            return set
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
            let update = Table("set").filter(self.id == Expression<Int>("id")).update([
                Expression<Int>("number") <- self.number,
                Expression<Int>("first_serve") <- self.first_serve,
                Expression<Int>("match") <- self.match,
                Expression<Int>("rotation") <- self.rotation.id,
                Expression<Int?>("libero1") <- self.liberos[0],
                Expression<Int?>("libero2") <- self.liberos[1],
                Expression<Int>("result") <- self.result,
                Expression<Int>("score_us") <- self.score_us,
                Expression<Int>("score_them") <- self.score_them,
                Expression<Int>("rotation_turns") <- self.rotationTurns,
                Expression<Int>("rotation_number") <- self.rotationNumber,
                Expression<Bool>("error_detail") <- self.errorDetail,
                Expression<Bool>("direction_detail") <- self.directionDetail,
                Expression<Bool>("restrict_changes") <- self.restrictChanges,
                Expression<String>("game_mode") <- self.gameMode
            ])
            if try database.run(update) > 0 {
//                DB.saveToFirestore(collection: "sets", object: self)
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
            self.stats().forEach({$0.delete()})
            let delete = Table("set").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
//            DB.deleteOnFirestore(collection: "sets", object: self)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    func reset(){
        self.first_serve=0
        self.result = 0
        self.score_us = 0
        self.score_them = 0
        self.rotation = Rotation()
        self.update()
        self.stats().forEach({$0.delete()})
    }
    static func all() -> [Set]{
        var sets: [Set] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for set in try database.prepare(Table("set")) {
                sets.append(Set(
                    id: set[Expression<Int>("id")],
                    number: set[Expression<Int>("number")],
                    first_serve: set[Expression<Int>("first_serve")],
                    match: set[Expression<Int>("match")],
                    rotation: Rotation.find(id: set[Expression<Int>("rotation")]) ?? Rotation(),
                    liberos: [set[Expression<Int?>("libero1")], set[Expression<Int?>("libero2")]],
                    rotationTurns: set[Expression<Int>("rotation_turns")],
                    rotationNumber: set[Expression<Int>("rotation_number")],
                    directionDetail: set[Expression<Bool>("direction_detail")],
                    errorDetail: set[Expression<Bool>("error_detail")],
                    restrictChanges: set[Expression<Bool>("restrict_changes")],
                    result: set[Expression<Int>("result")],
                    score_us: set[Expression<Int>("score_us")],
                    score_them: set[Expression<Int>("score_them")],
                    gameMode: set[Expression<String>("game_mode")]))
            }
            return sets
        } catch {
            print(error)
            return []
        }
    }
    func stats() -> [Stat]{
        var stats: [Stat] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for stat in try database.prepare(Table("stat").filter(Expression<Int>("set")==self.id).order(Expression<Double>("order"))) {
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
                    date: nil,
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
    func timeOuts()->(Int, Int){
        var result = (0,0)
        do{
            guard let database = DB.shared.db else {
                return (0,0)
            }
            let us = try database.scalar(Table("stat").filter(self.id == Expression<Int>("set") && Expression<Int>("action")==0 && Expression<Int>("to") == 1).count)
            let them = try database.scalar(Table("stat").filter(self.id == Expression<Int>("set") && Expression<Int>("action")==0 && Expression<Int>("to") == 2).count)
            result = (us, them)
            return result
        } catch {
            print(error)
            return (0,0)
        }
    }
    func changes()->[(Player, Player)]{
        var players:[(Player, Player)] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for stat in try database.prepare(Table("stat").filter(self.id == Expression<Int>("set") && Expression<Int>("action")==99)){
                players.append((Player.find(id: stat[Expression<Int>("player")])!, Player.find(id: stat[Expression<Int?>("player_in")]!)!))
            }
            return players
        } catch {
            
            return []
        }
    }
    static func find(id: Int) -> Set?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let set = try database.pluck(Table("set").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Set(
                id: set[Expression<Int>("id")],
                number: set[Expression<Int>("number")],
                first_serve: set[Expression<Int>("first_serve")],
                match: set[Expression<Int>("match")],
                rotation: Rotation.find(id: set[Expression<Int>("rotation")])!,
                liberos: [set[Expression<Int?>("libero1")], set[Expression<Int?>("libero2")]],
                rotationTurns: set[Expression<Int>("rotation_turns")],
                rotationNumber: set[Expression<Int>("rotation_number")],
                directionDetail: set[Expression<Bool>("direction_detail")],
                errorDetail: set[Expression<Bool>("error_detail")],
                restrictChanges: set[Expression<Bool>("restrict_changes")],
                result: set[Expression<Int>("result")],
                score_us: set[Expression<Int>("score_us")],
                score_them: set[Expression<Int>("score_them")],
                gameMode: set[Expression<String>("game_mode")])
        } catch {
            print(error)
            return nil
        }
    }
    static func truncate(){
        do{
            guard let database = DB.shared.db else {
                return
            }
            try database.run(Table("set").delete())
        }catch{
            print("error truncating set")
            return
        }
    }
    func summary()->Dictionary<String, Dictionary<String, Int>>{
        let stats = self.stats()
        let atk = stats.filter{s in return s.player != 0 && actionsByType["attack"]!.contains(s.action)}
        let blk = stats.filter{s in return s.player != 0 && actionsByType["block"]!.contains(s.action)}
        let rcv = stats.filter{s in return s.player != 0 && actionsByType["receive"]!.contains(s.action)}
        let srv = stats.filter{s in return s.server.id != 0 && s.stage == 0 && [8,12,15,32,39,40,41].contains(s.action)}
        let op = rcv.filter{s in return s.action==1}.count
        let r1 = rcv.filter{s in return s.action==2}.count
        let r2 = rcv.filter{s in return s.action==3}.count
        let r3 = rcv.filter{s in return s.action==4}.count
        let rerrors = rcv.filter{s in return s.action==22}.count
        let rtotal = rcv.count
        let rcvmk = Float(op/2 + r1 + 2*r2 + 3*r3)/Float(rtotal)
        let s2 = srv.filter{s in return s.action==39}.count
        let s1 = srv.filter{s in return s.action==40}.count
        let sop = srv.filter{s in return s.action==41}.count
        let s3 = srv.filter{s in return s.action==8}.count
        let stotal = srv.count
        let srvmk = stotal > 0 ? Float(sop/2 + s1 + 2*s2 + 3*s3)/Float(stotal) : 0
        let changes = stats.filter{s in s.action==99}.count
        let laststat = stats.sorted(by: {$0.id>$1.id}).last
        var server = laststat!.server
        if server.id == 0 && laststat!.to == 1{
            server = laststat!.rotation.get(rotate: laststat!.rotationTurns+1)[0]!
        } else if server.id != 0 && laststat!.to == 2{
            server = Player()
        }
        var result: Dictionary<String, Dictionary<String, Int>> = [
            "header":[
                "changes":changes,
                "serving":server.id,
                "score_us":laststat!.score_us,
                "score_them":laststat!.score_them
            ],
            "attack":[
                "total": atk.count,
                "kills": atk.filter{s in return [9, 10, 11, 12].contains(s.action)}.count,
                "error": atk.filter{s in return [16, 17, 18, 19].contains(s.action)}.count,
            ],
            "receive":[
                "total":rtotal,
                "error":rerrors,
                "mark":Int(rcvmk*100)
            ],
            "serve":[
                "total":stotal,
                "error":srv.filter{s in return [15, 32].contains(s.action)}.count,
                "mark":Int(srvmk*100)
            ],
            "block":[
                "total":blk.count,
                "blocks":blk.filter{s in return s.action == 13}.count,
                "error":blk.filter{s in return [20, 31].contains(s.action)}.count,
            ],
        ]
        return result
    }
}



