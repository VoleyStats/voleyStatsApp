import SQLite
import SwiftUI

class Player: Model, Hashable {
    typealias Expression = SQLite.Expression
//    var id:Int;
    var number:Int
    var team:Int
    var name:String
    var active:Int
    var birthday: Date
    var position : PlayerPosition
    var mainTeam: Bool
    var playerTeam: Int
    
    init(name:String, number:Int, team:Int, active:Int, birthday:Date, position: PlayerPosition =  .universal, mainTeam: Bool = true, playerTeam: Int = 0, id:Int?){
        self.name=name
        self.number=number
        self.team=team
        self.active=active
        self.birthday = birthday
        self.position = position
        self.mainTeam = mainTeam
        self.playerTeam = playerTeam
        super.init(id: id ?? 0)
        
    }
    init(){
        self.name="their.player".trad()
        self.number=0
        self.team=0
        self.active=0
        self.birthday = .now
        self.position = .universal
//        self.id=0
        self.mainTeam = true
        self.playerTeam = 0
        super.init(id: 0)
    }
    init(){
        self.name="their.player".trad()
        self.number=0
        self.team=0
        self.active=0
        self.birthday = .now
        self.position = .universal
        self.id=0
        self.mainTeam = true
    }
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
    override var description : String {
        return self.name
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func createPlayer(player: Player)->Player?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if player.id != 0{
                try database.run(Table("player").insert(
                    Expression<String>("name") <- player.name,
                    Expression<Int>("number") <- player.number,
                    Expression<Int>("team") <- player.team,
                    Expression<Int>("active") <- player.active,
                    Expression<Date>("birthday") <- player.birthday,
                    Expression<Int>("id") <- player.id,
                    Expression<String>("position") <- player.position.rawValue
                ))
            }else{
                let id = try database.run(Table("player").insert(
                    Expression<String>("name") <- player.name,
                    Expression<Int>("number") <- player.number,
                    Expression<Int>("active") <- player.active,
                    Expression<Date>("birthday") <- player.birthday,
                    Expression<Int>("team") <- player.team,
                    Expression<String>("position") <- player.position.rawValue
                ))
                player.id = Int(id)
            }
            
//            DB.saveToFirestore(collection: "player", object: player)
            return player
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
                var update = Table("player").filter(self.id == Expression<Int>("id")).update([
                    Expression<String>("name") <- self.name,
                    Expression<Int>("number") <- self.number,
                    Expression<Int>("active") <- self.active,
                    Expression<Date>("birthday") <- self.birthday,
                    Expression<Int>("team") <- self.team,
                    Expression<String>("position") <- self.position.rawValue
                ])
            if !self.mainTeam {
                update = Table("player_teams").filter(self.id == Expression<Int>("player") && self.team == Expression<Int>("team")).update([
                    Expression<Int>("number") <- self.number,
                    Expression<Int>("active") <- self.active,
                    Expression<String>("position") <- self.position.rawValue
                ])
            }
            if try database.run(update) > 0 {
                
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func delete(fromTeam: Bool = false) -> Bool{
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            try database.run(Table("player_teams").filter(Expression<Int>("player") == self.id && self.team == Expression<Int>("team")).delete())
            if fromTeam {
                let delete = Table("player").filter(self.id == Expression<Int>("id")).update([
                    Expression<Int>("team") <- 0
                ])
                try database.run(delete)
            }else{
                let delete = Table("player").filter(self.id == Expression<Int>("id") && self.team == Expression<Int>("team")).delete()
                try database.run(delete)
            }
            
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    static func all() -> [Player]{
        var players: [Player] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for player in try database.prepare(Table("player")) {
                players.append(Player(
                    name: player[Expression<String>("name")],
                    number: player[Expression<Int>("number")],
                    team: player[Expression<Int>("team")],
                    active: player[Expression<Int>("active")],
                    birthday: player[Expression<Date>("birthday")],
                    position: PlayerPosition(rawValue: player[Expression<String>("position")])!,
                    id: player[Expression<Int>("id")]))
            }
            return players
        } catch {
            print(error)
            return []
        }
    }
    static func allActive() -> [Player]{
        var players: [Player] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for player in try database.prepare(Table("player").filter(Expression<Int>("active") == 1)) {
                players.append(Player(
                    name: player[Expression<String>("name")],
                    number: player[Expression<Int>("number")],
                    team: player[Expression<Int>("team")],
                    active: player[Expression<Int>("active")],
                    birthday: player[Expression<Date>("birthday")],
                    position: PlayerPosition(rawValue: player[Expression<String>("position")])!,
                    id: player[Expression<Int>("id")]))
            }
            return players
            
        } catch {
            print(error)
            return []
        }
    }
    
    func deleteFromTeams() -> Bool{
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
                var update = Table("player").filter(self.id == Expression<Int>("id")).update([
                    Expression<Int>("team") <- 0
                ])
            try database.run(Table("player_teams").filter(Expression<Int>("player") == self.id).delete())
            if try database.run(update) > 0 {
//                if self.mainTeam{
//                    DB.saveToFirestore(collection: "player", object: self)
//                }else{
//                    DB.saveToFirestore(collection: "player_teams", object: [
//                        "id":self.playerTeam,
//                        "player":self.id,
//                        "team":self.team,
//                        "position":self.position.rawValue,
//                        "active":self.active,
//                        "number":self.number
//                    ])
//                }
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func getBirthDay() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: self.birthday)
    }
    
    static func deleted() -> [Player]{
        var players: [Player] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for player in try database.prepare(Table("player").filter(Expression<Int>("team")==0)) {
                players.append(Player(
                    name: player[Expression<String>("name")],
                    number: player[Expression<Int>("number")],
                    team: player[Expression<Int>("team")],
                    active: player[Expression<Int>("active")],
                    birthday: player[Expression<Date>("birthday")],
                    position: PlayerPosition(rawValue: player[Expression<String>("position")])!,
                    id: player[Expression<Int>("id")]))
            }
            return players
        } catch {
            print(error)
            return []
        }
    }
    
    static func find(id: Int) -> Player?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let player = try database.pluck(Table("player").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Player(
                name: player[Expression<String>("name")],
                number: player[Expression<Int>("number")],
                team: player[Expression<Int>("team")],
                active: player[Expression<Int>("active")],
                birthday: player[Expression<Date>("birthday")],
                position: PlayerPosition(rawValue: player[Expression<String>("position")])!,
                id: player[Expression<Int>("id")])
        } catch {
            print(error)
            return nil
        }
    }
    
    func stats(match: Match? = nil, tournament: Tournament? = nil, dateRange: (Date, Date)? = nil) -> [Stat] {
        var stats: [Stat] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            var sql = Table("stat").filter(Expression<Int>("player") == self.id || Expression<Int>("server") == self.id || Expression<Int>("setter") == self.id)
            if match != nil{
                sql = sql.filter(Expression<Int>("match") == match!.id)
            }
            if tournament != nil{
                sql = sql.filter(tournament!.matches().map{$0.id}.contains(Expression<Int>("match")))
            }
            if dateRange != nil{
                let team = Team.find(id: self.team)
                sql = sql.filter(team!.matches(startDate: dateRange!.0, endDate: dateRange!.1).map{$0.id}.contains(Expression<Int>("match")))
            }
            for stat in try database.prepare(sql) {
                stats.append(
                    Stat(
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
                    )
                )
            }
            return stats
        } catch {
            print(error)
            return []
        }
    }
    
    func measurements() -> [PlayerMeasures] {
        var measures: [PlayerMeasures] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for measure in try database.prepare(Table("player_measures").filter(Expression<Int>("player") == self.id).order(Expression<Date>("date").asc)) {
                measures.append(
                    PlayerMeasures(
                        id: measure[Expression<Int>("id")],
                        player: Player.find(id: measure[Expression<Int>("player")])!,
                        date:measure[Expression<Date>("date")],
                        height: measure[Expression<Int>("height")],
                        weight: measure[Expression<Double>("weight")],
                        oneHandReach: measure[Expression<Int>("one_hand_reach")],
                        twoHandReach: measure[Expression<Int>("two_hand_reach")],
                        attackReach: measure[Expression<Int>("attack_reach")],
                        blockReach: measure[Expression<Int>("block_reach")],
                        breadth: measure[Expression<Int>("breadth")])
                )
            }
            return measures
        } catch {
            print(error)
            return []
        }
    }
    
    func actualMeasures() -> PlayerMeasures? {
        var measures: PlayerMeasures? = nil
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return nil
            }
            guard let measure = try database.pluck(Table("player_measures").filter(Expression<Int>("player") == self.id).order(Expression<Date>("date").desc)) else {
                return nil
            }
                measures=PlayerMeasures(
                        id: measure[Expression<Int>("id")],
                        player: Player.find(id: measure[Expression<Int>("player")])!,
                        date:measure[Expression<Date>("date")],
                        height: measure[Expression<Int>("height")],
                        weight: measure[Expression<Double>("weight")],
                        oneHandReach: measure[Expression<Int>("one_hand_reach")],
                        twoHandReach: measure[Expression<Int>("two_hand_reach")],
                        attackReach: measure[Expression<Int>("attack_reach")],
                        blockReach: measure[Expression<Int>("block_reach")],
                        breadth: measure[Expression<Int>("breadth")])
            return measures
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
            try database.run(Table("player").delete())
        }catch{
            print("error truncating player")
            return
        }
    }
    
    override func toJSON()->Dictionary<String,Any>{
        return [
            "id":self.id,
            "name":self.name,
            "number":self.number,
            "team":self.team,
            "active":self.active,
            "birthday":self.birthday.timeIntervalSince1970,
            "position":self.position.rawValue
        ]
    }
    
    func report(match: Match? = nil, tournament: Tournament? = nil, dateRange: (Date, Date)? = nil)->Dictionary<String,Dictionary<String,Float>>{
        
        var stats = self.stats(match: match, tournament: tournament, dateRange: dateRange)
        let serves = stats.filter{s in return s.server == self && s.stage != 1}
        let serveTot = serves.filter{ s in s.to != 0}.count
        let aces = serves.filter{s in return s.action==8}.count
        let serve1 = serves.filter{s in return s.action==39}.count
        let serve2 = serves.filter{s in return s.action==40}.count
        let serve3 = serves.filter{s in return s.action==41}.count
        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
        let serveMark = serveTot == 0 ? 0.00 : (Float(serve1)/2 + Float(serve2) + 2*Float(serve3) + 3*Float(aces))/Float(serveTot)
        let rcv = stats.filter{s in return [1, 2, 3, 4, 22].contains(s.action) && s.player == self.id}
        let Rerr = rcv.filter{s in return s.action==22}.count
        let op = rcv.filter{s in return s.action==1}.count
        let s1 = rcv.filter{s in return s.action==2}.count
        let s2 = rcv.filter{s in return s.action==3}.count
        let s3 = rcv.filter{s in return s.action==4}.count
        let mark = rcv.count == 0 ? 0.00 : (Float(op)/2 + Float(s1) + 2*Float(s2) + 3*Float(s3))/Float(rcv.count)
        let atk = stats.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action) && s.player == self.id}
        let Aerr = atk.filter{s in return [16, 17, 18, 19].contains(s.action) && s.detail.lowercased() != "block"}.count
        let blocked = atk.filter{s in return [16, 17, 18, 19].contains(s.action) && s.detail.lowercased() == "block"}.count
        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
        let atkMark = atk.count > 0 ? Float(kills*3)/Float(atk.count) : 0.00
        let blocks = stats.filter{s in return [7, 13, 20, 31].contains(s.action) && s.player == self.id}
        let blocksEarn = blocks.filter{s in return s.action==13}.count
        let blockErr = blocks.filter{s in return [20, 31].contains(s.action)}.count
        let blockMark = blocks.count > 0 ? Float(blocksEarn*3)/Float(blocks.count) : 0.00
        let dig = stats.filter{s in return [23, 5, 21].contains(s.action) && s.player == self.id}
        let digErr = dig.filter{s in return [23, 21].contains(s.action)}.count
        let digMark = dig.count > 0 ? (Float(dig.count-digErr)*3)/Float(dig.count) : 0.00
        let matchCount = Swift.Set(stats.map({$0.match})).count
        let setCount = Swift.Set(stats.map({$0.set})).count
        var result : Dictionary<String,Dictionary<String,Float>> = [
            "serve":[
                "total": Float(serveTot),
                     "ace":Float(aces),
                     "++":Float(serve3),
                     "-":Float(serve1+serve2),
                     "error":Float(Serr),
                     "mark":serveMark],
            "receive":[
                "total":Float(rcv.count),
                       "++":Float(s3),
                       "+":Float(s2),
                       "-":Float(s1),
                       "error":Float(Rerr),
                       "mark":mark],
            "attack":["total":Float(atk.count),
                      "kill":Float(kills),
                      "block":Float(blocked),
                      "error":Float(Aerr),
                      "mark":atkMark],
            "block":["total":Float(blocks.count),
                     "points":Float(blocksEarn),
                     "error":Float(blockErr),
                     "mark":blockMark],
            "dig":["total":Float(dig.count),
                   "error":Float(digErr),
                   "mark":digMark],
            "general":["matches":Float(matchCount),
                       "sets":Float(setCount)]
        ]
        
        return result
    }
    
    static func playerTeamsToJSON()->Array<Dictionary<String, Any>>{
        var result:Array<Dictionary<String, Any>> = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for pt in try database.prepare(Table("player_teams")){
                result.append([
                    "id":pt[Expression<Int>("id")],
                    "player":pt[Expression<Int>("player")],
                    "team":pt[Expression<Int>("team")],
                    "position":pt[Expression<String>("position")],
                    "active":pt[Expression<Int>("active")],
                    "number":pt[Expression<Int>("number")]
                ])
            }
            return result
        }catch{
            print("error exporting player_teams")
            return []
        }
        
        
    }
    
    static func importTeams(id: Int, player: Int, team:Int, position: String, number: Int, active: Int)->Bool{
        do {
            guard let database = DB.shared.db else {
                return false
            }
            let id = try database.run(Table("player_teams").insert(
                Expression<Int>("player") <- player,
                Expression<Int>("team") <- team,
                Expression<Int>("id") <- id,
                Expression<String>("position") <- position,
                Expression<Int>("number") <- number,
                Expression<Int>("active") <- active
            ))
            return id < 0
        } catch {
            print(error)
        }
        return false
    }
}

enum PlayerPosition:String, CaseIterable, Identifiable{
    case setter
    case opposite
    case outside
    case midBlock
    case universal
    case libero
    
    var id: String {self.rawValue}
}




