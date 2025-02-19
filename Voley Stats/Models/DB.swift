import SQLite
import Foundation
import UniformTypeIdentifiers
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class DB {
    typealias Expression = SQLite.Expression
    var db: Connection? = nil
    private var version = 6
    static var shared = DB()
    var tables: [Any] = [Team.Type.self, Player.Type.self, ]
    init() {
        if db == nil {
//            if let docDir = AppGroup.database.containerURL {
                let dirPath = AppGroup.database.containerURL.appendingPathComponent("database")
                
                do {
                    try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                    let dbPath = dirPath.appendingPathComponent("db.sqlite").path
                    db = try Connection(dbPath)
                    initDatabase()
                    
                    
                    print("SQLiteDataStore init successfully at: \(dbPath) ")
                } catch {
                    db = nil
                    print("SQLiteDataStore init error: \(error)")
                }
//            } else {
//                db = nil
//            }
        }
        
    }
    
    private func initDatabase(){
        guard let database = db else {
            return
        }
        do {
            try database.run(Table("season_pass").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Bool>("pass"), defaultValue: false)
                t.column(Expression<Date>("date_end"))
            })
            if try database.scalar(Table("season_pass").count) == 0{
                try database.run(Table("season_pass").insert(
                    Expression<Bool>("pass") <- false,
                    Expression<Date>("date_end") <- .distantPast
                ))
            }
        } catch {
            print("SEASON_PASS Error: \(error)")
        }
        
        do {
            try database.run(Table("team").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<String>("organization"))
                t.column(Expression<String>("category"))
                t.column(Expression<String>("gender"))
                t.column(Expression<String>("color"))
            })
        } catch {
            print("TEAM Error: \(error)")
        }
        do {
            try database.run(Table("player").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<Int>("number"))
                t.column(Expression<Int>("active"))
                t.column(Expression<Date>("birthday"))
                t.column(Expression<String>("position"))
                t.column(Expression<Int>("team"))
                t.foreignKey(Expression<Int>("team"), references: Table("team"), Expression<Int>("id"), update: .cascade, delete: .cascade)
            })
        } catch {
            print("PLAYER Error: \(error)")
        }
        
        do {
            try database.run(Table("player_measures").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("player"))
                t.column(Expression<Date>("date"))
                t.column(Expression<Int>("height"))
                t.column(Expression<Double>("weight"))
                t.column(Expression<Int>("one_hand_reach"))
                t.column(Expression<Int>("two_hand_reach"))
                t.column(Expression<Int>("attack_reach"))
                t.column(Expression<Int>("block_reach"))
                t.column(Expression<Int>("breadth"))
            })
        } catch {
            print("PLAYER_MEASURES Error: \(error)")
        }
        
        do {
            try database.run(Table("tournament").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<Int>("team"))
                t.column(Expression<String>("location"))
                t.column(Expression<Date>("date_start"))
                t.column(Expression<Date>("date_end"))
                t.foreignKey(Expression<Int>("team"), references: Table("team"), Expression<Int>("id"), update: .cascade, delete: .cascade)
            })
        } catch {
            print("TOURNAMENT Error: \(error)")
        }
        
        do {
            try database.run(Table("action").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<Int>("type"))
                t.column(Expression<Int>("stage"))
                t.column(Expression<Int>("area"))
                t.column(Expression<Int>("order"))
            })
        } catch {
            print("ACTION Error: \(error)")
        }
        
        do {
            try database.run(Table("match").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("opponent"))
                t.column(Expression<String>("location"))
                t.column(Expression<Bool>("home"))
                t.column(Expression<Bool>("league"), defaultValue: false)
                t.column(Expression<Date>("date"))
                t.column(Expression<Int>("n_sets"))
                t.column(Expression<Int>("n_players"))
                t.column(Expression<Int>("team"))
                t.column(Expression<Int>("tournament"), defaultValue: 0)
                t.foreignKey(Expression<Int>("team"), references: Table("team"), Expression<Int>("id"), update: .cascade, delete: .cascade)
            })
        } catch {
            print("MATCH Error: \(error)")
        }
        do {
            try database.run(Table("rotation").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String?>("name"))
                t.column(Expression<Int>("1"))
                t.column(Expression<Int>("2"))
                t.column(Expression<Int>("3"))
                t.column(Expression<Int>("4"))
                t.column(Expression<Int>("5"))
                t.column(Expression<Int>("6"))
                t.column(Expression<Int>("team"))
                t.foreignKey(Expression<Int>("team"), references: Table("team"), Expression<Int>("id"), update: .cascade, delete: .cascade)
            })
        } catch {
            print("ROTATION Error: \(error)")
        }
        do {
            try database.run(Table("set").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("number"))
                t.column(Expression<Int>("first_serve"))
                t.column(Expression<Int>("match"))
                t.column(Expression<Int>("rotation"))
                t.column(Expression<Int?>("libero1"))
                t.column(Expression<Int?>("libero2"))
                t.column(Expression<Int?>("result"), defaultValue: 0)
                t.column(Expression<Int?>("score_us"), defaultValue: 0)
                t.column(Expression<Int?>("score_them"), defaultValue: 0)
                t.column(Expression<String>("game_mode"))
            })
        } catch {
            print("SET 1 Error: \(error)")
        }
        do {
            try database.run(Table("stat").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("match"))
                t.column(Expression<Int>("set"))
                t.column(Expression<Int>("player"))
                t.column(Expression<Int>("rotation"))
                t.column(Expression<Int>("rotation_turns"))
                t.column(Expression<Int>("rotation_count"))
                t.column(Expression<Int>("server"))
                t.column(Expression<Int>("action"))
                t.column(Expression<Int>("setter"))
                t.column(Expression<Int?>("player_in"), defaultValue: nil)
                t.column(Expression<Int?>("to"), defaultValue: 0)
                t.column(Expression<Int>("score_us"))
                t.column(Expression<Int>("score_them"))
                t.column(Expression<Int>("stage"))
                t.column(Expression<String>("detail"))
            })
            
            
        } catch {
            print("STAT Error: \(error)")
        }
        
        do {
            try database.run(Table("player_teams").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("player"))
                t.column(Expression<Int>("team"))
                t.column(Expression<Int>("number"))
                t.column(Expression<Int>("active"))
                t.column(Expression<String>("position"))
            })
        } catch {
            print("PLAYER_TEAMS Error: \(error)")
        }
        
        let uv = self.db?.userVersion as! Int32
//                    print(uv)
        if uv < version && uv > 0{
            self.migrate(userVersion: uv)
        }else if uv == 0{
            self.migrate(userVersion: uv)
        }
        
//        do{
//            if try database.scalar(Table("team").count) == 0{
//                self.createDemoTeam()
//                print("demo team created")
//            }
//        }catch{
//            print("error creating demo team")
//        }
        
//        do{
//            try database.run(Table("team").addColumn(Expression<Int>("code"), defaultValue: 0))
//        }catch{
//            print("error migrating")
//        }
    }
    
    func migrate(userVersion: Int32){
        guard let database = db else {
            return
        }
        if userVersion < 2 && self.version >= 2 {
            do{
//                let sc = SchemaChanger(connection: db!)
                do{
//                    try database.run(Table("team").addColumn(Expression<String>("code"), defaultValue: ""))
//                    database.run(Table("team"))
//                    try sc.alter(table: "team"){table in
//                        table.drop(column: "code")
//                    }
                    try database.run(Table("team").addColumn(Expression<String>("code"), defaultValue: ""))
                    try database.run(Table("team").addColumn(Expression<Int>("order"), defaultValue: 0))
                }catch{
                    print("error migrating teams")
                }
                do{
                    try database.run(Table("stat").addColumn(Expression<Date?>("date"), defaultValue: nil))
                    try database.run(Table("stat").addColumn(Expression<Double>("order"), defaultValue: 0))
                }catch{
                    print("error migrating stats")
                }
                try db?.execute("PRAGMA user_version = \(version)")
                print("migrated!")
            }catch{
                print("error migrating")
            }
        }
        if userVersion < 3 && self.version >= 3 {
            do{
//                let sc = SchemaChanger(connection: db!)
            
                do{
                    try database.run(Table("match").addColumn(Expression<String>("code"), defaultValue: ""))
                    try database.run(Table("match").addColumn(Expression<Bool>("live"), defaultValue: false))
                }catch{
                    print("error migrating stats")
                }
                try db?.execute("PRAGMA user_version = \(version)")
                print("migrated!")
            }catch{
                print("error migrating")
            }
        }
        if userVersion < 4 && self.version >= 4 {
            do{
//                let sc = SchemaChanger(connection: db!)
            
                do{
                    try database.run(Table("set").addColumn(Expression<Int>("rotation_turns"), defaultValue: 0))
                }catch{
                    print("error migrating set")
                }
                try db?.execute("PRAGMA user_version = \(version)")
                print("migrated!")
            }catch{
                print("error migrating")
            }
        }
        
        if userVersion < 5 && self.version >= 5 {
            do{
//                let sc = SchemaChanger(connection: db!)
            
                do{
                    try database.run(Table("set").addColumn(Expression<Int>("rotation_number"), defaultValue: 1))
                    try database.run(Table("set").addColumn(Expression<Bool>("direction_detail"), defaultValue: true))
                    try database.run(Table("set").addColumn(Expression<Bool>("error_detail"), defaultValue: true))
                    try database.run(Table("set").addColumn(Expression<Bool>("restrict_changes"), defaultValue: true))
                    try database.run(Table("stat").addColumn(Expression<String>("direction"), defaultValue: ""))
                }catch{
                    print("error migrating directions")
                }
                try db?.execute("PRAGMA user_version = \(version)")
                print("migrated!")
            }catch{
                print("error migrating")
            }
        }
        
        if userVersion < 6 && self.version >= 6 {
            do{
//                let sc = SchemaChanger(connection: db!)
            
                do{
                    
                    try database.run(Table("team").addColumn(Expression<Bool>("pass"), defaultValue: false))
                    try database.run(Table("team").addColumn(Expression<Date>("season_end"), defaultValue: Date.distantPast))
                    try database.run(Table("tournament").addColumn(Expression<Bool>("pass"), defaultValue: false))
                    try database.run(Table("match").addColumn(Expression<Bool>("pass"), defaultValue: false))
//                    try database.run(Table("team").addColumn(Expression<Int>("season")))
                    
                }catch{
                    print("error migrating pricing")
                }
                try db?.execute("PRAGMA user_version = \(version)")
                print("migrated!")
            }catch{
                print("error migrating")
            }
        }
    }
    
    static func saveToFirestore(collection: String, object: Model)->Bool{
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        var success = false
        db.collection(uid).document("iPad").collection(collection).document(object.id.description).setData(object.toJSON()){ err in
            success = err != nil
        }
        return success
    }
    
    static func saveToFirestore(collection: String, object: Dictionary<String,Any>)->Bool{
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        var success = false
//        let id = object["id"] as! Int64
        db.collection(uid).document("iPad").collection(collection).document(object["id"] as! String).setData(object){ err in
            success = err != nil
        }
        return success
    }
    
    static func deleteOnFirestore(collection: String, object: Model)->Bool{
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        var success = false
        db.collection(uid).document("iPad").collection(collection).document(object.id.description).delete(){ err in
            success = err != nil
        }
        return success
    }
    
    static func deleteOnFirestore(collection: String, id: Int)->Bool{
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        var success = false
        db.collection(uid).document("iPad").collection(collection).document(id.description).delete(){ err in
                success = err != nil
            }
        return success
    }
    
    static func truncateDatabase () {
        Team.truncate()
        Player.truncate()
        PlayerMeasures.truncate()
        Match.truncate()
        Tournament.truncate()
        Set.truncate()
        Stat.truncate()
//        Scout.truncate()
        Rotation.truncate()
        do {
            guard let database = DB.shared.db else {
                return
            }
            try database.run(Table("player_teams").delete())
        } catch {
            print(error)
        }
    }
    
    static func truncateDatabase () {
        Team.truncate()
        Player.truncate()
        PlayerMeasures.truncate()
        Match.truncate()
        Tournament.truncate()
        Set.truncate()
        Stat.truncate()
        Scout.truncate()
        Rotation.truncate()
        do {
            guard let database = DB.shared.db else {
                return
            }
            try database.run(Table("player_teams").delete())
        } catch {
            print(error)
        }
    }
    
    static func createCSV() -> URL {
        var csvString = "id,name,organization,category,gender,color\n"
        for team in Team.all() {
            csvString = csvString.appending("\(team.id),\(team.name),\(team.orgnization),\(team.category),\(team.gender),\(team.color)\n")
        }
        csvString = csvString.appending(":\n id,name,number,active,team,birthday\n")
        for player in Player.all(){
            csvString = csvString.appending("\(player.id),\(player.name),\(player.number),\(player.active),\(player.team),\(player.getBirthDay())\n")
        }
        csvString = csvString.appending(":\n id,opponent,location,home,date,n_sets,n_players,team,league,tournament\n")
        for match in Match.all(){
            csvString = csvString.appending("\(match.id),\(match.opponent),\(match.location),\(match.home),\(match.getDate()),\(match.n_sets),\(match.n_players),\(match.team),\(match.league),\(match.tournament?.id ?? 0)\n")
        }
        csvString = csvString.appending(":\n id,number,first_serve,match,rotation,libero1,libero2,result,score_us,score_them\n")
        for set in Set.all(){
            csvString = csvString.appending("\(set.id),\(set.number),\(set.first_serve),\(set.match),\"\(set.rotation.id)\",\(set.liberos[0]),\(set.liberos[1]),\(set.result),\(set.score_us),\(set.score_them)\n")
        }
        csvString = csvString.appending(":\n id,match,set,player,rotation,server,action,player_in,to,score_us,score_them,stage,detail,rotation_turns,rotation_count\n")
        for stat in Stat.all(){
            csvString = csvString.appending("\(stat.id),\(stat.match),\(stat.set),\(stat.player),\"\(stat.rotation.id)\",\( stat.server),\(stat.action),\(stat.player_in),\(stat.to),\(stat.score_us),\(stat.score_them),\(stat.stage),\"\(stat.detail)\",\(stat.rotationTurns),\(stat.rotationCount)\n")
        }
        csvString = csvString.appending(":\n id,name,team,location,date_start,date_end\n")
        for tournament in Tournament.all(){
            
            csvString = csvString.appending("\(tournament.id),\(tournament.name),\(tournament.team.id),\(tournament.location),\(tournament.getStartDateString()),\(tournament.getEndDateString())\n")
            
        }
        guard let database = DB.shared.db else {
            fatalError("DB error")
        }
        do {
            csvString = csvString.appending(":\n id,player,team\n")
            for pt in try database.prepare(Table("player_teams")){
                csvString = csvString.appending("\(pt[Expression<Int>("id")]),\(pt[Expression<Int>("player")]),\(pt[Expression<Int>("team")])\n")
            }
        } catch {
            print("Exporting Error: \(error)")
        }
        
        guard let path = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("db.csv")
        else { fatalError("DB Destination URL not created") }
        do{
//            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false).appendingPathComponent("db.csv")
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            return path
        }catch{
            fatalError("error exporting db")
        }
    }
    
    static func createCSVString() -> String {
        var csvString = "id,name,organization,category,gender,color;"
        for team in Team.all() {
            csvString = csvString.appending("\(team.id),\(team.name),\(team.orgnization),\(team.category),\(team.gender),\(team.color);")
        }
        csvString = csvString.appending(":id,name,number,active,team,birthday;")
        for player in Player.all(){
            csvString = csvString.appending("\(player.id),\(player.name),\(player.number),\(player.active),\(player.team),\(player.getBirthDay());")
        }
        csvString = csvString.appending(":id,opponent,location,home,date,n_sets,n_players,team,league,tournament;")
        for match in Match.all(){
            csvString = csvString.appending("\(match.id),\(match.opponent),\(match.location),\(match.home),\(match.getDate()),\(match.n_sets),\(match.n_players),\(match.team),\(match.league),\(match.tournament?.id ?? 0);")
        }
        csvString = csvString.appending(":id,number,first_serve,match,rotation,libero1,libero2,result,score_us,score_them;")
        for set in Set.all(){
            csvString = csvString.appending("\(set.id),\(set.number),\(set.first_serve),\(set.match),\(set.rotation.id),\(set.liberos[0]),\(set.liberos[1]),\(set.result),\(set.score_us),\(set.score_them);")
        }
        csvString = csvString.appending(":id,match,set,player,rotation,server,action,player_in,to,score_us,score_them,stage,detail,rotation_turns,rotation_count;")
        for stat in Stat.all(){
            csvString = csvString.appending("\(stat.id),\(stat.match),\(stat.set),\(stat.player),\(stat.rotation.id),\( stat.server),\(stat.action),\(stat.player_in),\(stat.to),\(stat.score_us),\(stat.score_them),\(stat.stage),\"\(stat.detail)\",\(stat.rotationTurns),\(stat.rotationCount);")
        }
        csvString = csvString.appending(":id,name,team,location,date_start,date_end;")
        for tournament in Tournament.all(){
            csvString = csvString.appending("\(tournament.id),\(tournament.name),\(tournament.team.id),\(tournament.location),\(tournament.getStartDateString()),\(tournament.getEndDateString());")
        }
        guard let database = DB.shared.db else {
            fatalError("DB error")
        }
        do {
            csvString = csvString.appending(":id,player,team;")
            for pt in try database.prepare(Table("player_teams")){
                csvString = csvString.appending("\(pt[Expression<Int>("id")]),\(pt[Expression<Int>("player")]),\(pt[Expression<Int>("team")]);")
            }
        } catch {
            print("Exporting Error: \(error)")
        }
        
        csvString = csvString.appending(":id,name,team,one,two,three,four,five,six;")
        for r in Rotation.all(){
            csvString = csvString.appending("\(r.id),\(r.name),\(r.team.id),\(r.one?.id ?? 0),\(r.two?.id ?? 0),\(r.three?.id ?? 0),\(r.four?.id ?? 0),\(r.five?.id ?? 0),\(r.six?.id ?? 0);")
        }
        
        return csvString
        
    }
    
    func createDemoTeam(){
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        let t1 = Team.createTeam(team: Team(name: "Demo team", organization: "Volleyball stats", category: "Infantil", gender: "Female", color: .orange, order: 1, pass: true, id: 1))!
        
        let p1 = Player.createPlayer(player: Player(name: "Cindy", number: 9, team: 1, active: 1, birthday: df.date(from: "2023/09/26") ?? .now, position: PlayerPosition(rawValue: "midBlock")!, id: 1))!
        let p2 = Player.createPlayer(player: Player(name: "Donna", number: 11, team: 1, active: 1, birthday: df.date(from: "2023/09/26") ?? .now, position: PlayerPosition(rawValue: "midBlock")!, id: 2))!
        let p3 = Player.createPlayer(player: Player(name: "Beth", number: 7, team: 1, active: 1, birthday: df.date(from: "2023/09/26") ?? .now, position: PlayerPosition(rawValue: "setter")!, id: 3))!
        let p4 = Player.createPlayer(player: Player(name: "Kate", number: 19, team: 1, active: 1, birthday: df.date(from: "2023/09/26") ?? .now, position: PlayerPosition(rawValue: "outside")!, id: 4))!
        let p5 = Player.createPlayer(player: Player(name: "Irene", number: 13, team: 1, active: 1, birthday: df.date(from: "2023/09/26") ?? .now, position: PlayerPosition(rawValue: "setter")!, id: 5))!
        let p6 = Player.createPlayer(player: Player(name: "Lulu", number: 20, team: 1, active: 0, birthday: df.date(from: "2023/09/26") ?? .now, position: PlayerPosition(rawValue: "outside")!, id: 6))!
        let p7 = Player.createPlayer(player: Player(name: "Laura", number: 26, team: 1, active: 1, birthday: df.date(from: "2023/09/26") ?? .now, position: PlayerPosition(rawValue: "setter")!, id: 7))!
        let p8 = Player.createPlayer(player: Player(name: "Erin", number: 12, team: 1, active: 1, birthday: df.date(from: "2023/10/31") ?? .now, position: PlayerPosition(rawValue: "outside")!, id: 8))!
        let p9 = Player.createPlayer(player: Player(name: "Jacky", number: 18, team: 1, active: 1, birthday: df.date(from: "2023/10/31") ?? .now, position: PlayerPosition(rawValue: "outside")!, id: 9))!
        let p10 = Player.createPlayer(player: Player(name: "Helen", number: 10, team: 1, active: 1, birthday: df.date(from: "2023/10/31") ?? .now, position: PlayerPosition(rawValue: "outside")!, id: 10))!
        let p11 = Player.createPlayer(player: Player(name: "Fran", number: 14, team: 1, active: 1, birthday: df.date(from: "2023/10/31") ?? .now, position: PlayerPosition(rawValue: "midBlock")!, id: 11))!
        let p12 = Player.createPlayer(player: Player(name: "Grace", number: 16, team: 1, active: 1, birthday: df.date(from: "2023/12/23") ?? .now, position: PlayerPosition(rawValue: "setter")!, id: 12))!
        let p13 = Player.createPlayer(player: Player(name: "Abby", number: 3, team: 1, active: 1, birthday: df.date(from: "2024/09/14") ?? .now, position: PlayerPosition(rawValue: "midBlock")!, id: 13))!
        
        let m1 = Match.createMatch(match: Match(opponent: "Demo opponent", date: .now, location: "Demo arena", home: false, n_sets: 5, n_players: 6, team: 1, league: false, code: "", live: false, pass: true, tournament: nil, id: 1))!
        
        let r1 = Rotation.create(rotation: Rotation(id: 1, name: "", team: t1, one: p3, two: p9, three: p1, four: p12, five: p4, six: p11))!.1
        let r2 = Rotation.create(rotation: Rotation(id: 2, name: "", team: t1, one: p13, two: p12, three: p4, four: p11, five: p3, six: p9))!.1
        let r3 = Rotation.create(rotation: Rotation(id: 3, name: "", team: t1, one: p7, two: p4, three: p11, four: p3, five: p9, six: p13))!.1
        let r4 = Rotation.create(rotation: Rotation(id: 4, name: "", team: t1, one: p7, two: p10, three: p13, four: p5, five: p8, six: p2))!.1
        let r5 = Rotation.create(rotation: Rotation(id: 5, name: "", team: t1, one: p2, two: p7, three: p4, four: p13, five: p3, six: p8))!.1
        let r6 = Rotation.create(rotation: Rotation(id: 6, name: "", team: t1, one: p7, two: p4, three: p1, four: p3, five: p8, six: p2))!.1
        let r7 = Rotation.create(rotation: Rotation(id: 7, name: "", team: t1, one: p7, two: p4, three: p1, four: p3, five: p9, six: p2))!.1
        let r8 = Rotation.create(rotation: Rotation(id: 8, name: "", team: t1, one: p7, two: p4, three: p1, four: p12, five: p9, six: p2))!.1
        let r9 = Rotation.create(rotation: Rotation(id: 9, name: "", team: t1, one: p10, two: p1, three: p12, four: p9, five: p2, six: p7))!.1
        
        let set1 = Set.createSet(set: Set(id: 1, number: 1, first_serve: 2, match: m1.id, rotation: r1, liberos: [0,0], rotationTurns: 0, rotationNumber: 1, directionDetail: false, errorDetail: true, restrictChanges: true, result: 0, score_us: 25, score_them: 21, gameMode: "6-2"))!
        let set2 = Set.createSet(set: Set(id: 2, number: 2, first_serve: 1, match: m1.id, rotation: r4, liberos: [0,0], rotationTurns: 0, rotationNumber: 1, directionDetail: false, errorDetail: true, restrictChanges: true, result: 0, score_us: 24, score_them: 14, gameMode: "6-2"))!
        let set3 = Set.createSet(set: Set(id: 3, number: 3, first_serve: 2, match: m1.id, rotation: r5, liberos: [0,0], rotationTurns: 0, rotationNumber: 1, directionDetail: false, errorDetail: true, restrictChanges: true, result: 0, score_us: 25, score_them: 11, gameMode: "6-2"))!
        let set4 = Set.createSet(set: Set(id: 4, number: 4, first_serve: 0, match: m1.id, rotation: Rotation(), liberos: [0,0], rotationTurns: 0, rotationNumber: 1, directionDetail: false, errorDetail: true, restrictChanges: true, result: 0, score_us: 0, score_them: 0, gameMode: "6-6"))!
        let set5 = Set.createSet(set: Set(id: 5, number: 5, first_serve: 0, match: m1.id, rotation: Rotation(), liberos: [0,0], rotationTurns: 0, rotationNumber: 1, directionDetail: false, errorDetail: true, restrictChanges: true, result: 0, score_us: 0, score_them: 0, gameMode: "6-6"))!
        
        let st1 = Stat.createStat(stat: Stat(id: 1, match: m1.id, set: set1.id, player: 12, action: 4, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 0, score_them: 0, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 1.0, direction: ""))
        let st2 = Stat.createStat(stat: Stat(id: 2, match: m1.id, set: set1.id, player: 0, action: 28, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 1, score_them: 0, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 2.0, direction: ""))
        let st3 = Stat.createStat(stat: Stat(id: 3, match: m1.id, set: set1.id, player: 9, action: 41, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 1, score_them: 0, to: 0, stage: 0, server: p9, player_in: nil, detail: "", setter: p3, order: 3.0, direction: ""))
        let st4 = Stat.createStat(stat: Stat(id: 4, match: m1.id, set: set1.id, player: 4, action: 9, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 2, score_them: 0, to: 1, stage: 2, server: p9, player_in: nil, detail: "", setter: p3, order: 4.0, direction: ""))
        let st5 = Stat.createStat(stat: Stat(id: 5, match: m1.id, set: set1.id, player: 9, action: 40, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 2, score_them: 0, to: 0, stage: 0, server: p9, player_in: nil, detail: "", setter: p3, order: 5.0, direction: ""))
        let st6 = Stat.createStat(stat: Stat(id: 6, match: m1.id, set: set1.id, player: 1, action: 17, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 2, score_them: 1, to: 2, stage: 2, server: p9, player_in: nil, detail: "Net", setter: p3, order: 6.0, direction: ""))
        let st7 = Stat.createStat(stat: Stat(id: 7, match: m1.id, set: set1.id, player: 3, action: 4, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 2, score_them: 1, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 7.0, direction: ""))
        let st8 = Stat.createStat(stat: Stat(id: 8, match: m1.id, set: set1.id, player: 0, action: 16, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 3, score_them: 1, to: 1, stage: 2, server: Player(), player_in: nil, detail: "Out", setter: p3, order: 8.0, direction: ""))
        let st9 = Stat.createStat(stat: Stat(id: 9, match: m1.id, set: set1.id, player: 1, action: 8, rotation: r1, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 1, to: 1, stage: 0, server: p1, player_in: nil, detail: "", setter: p3, order: 9.0, direction: ""))
        let st10 = Stat.createStat(stat: Stat(id: 10, match: m1.id, set: set1.id, player: 1, action: 39, rotation: r1, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 1, to: 0, stage: 0, server: p1, player_in: nil, detail: "", setter: p3, order: 10.0, direction: ""))
        let st11 = Stat.createStat(stat: Stat(id: 11, match: m1.id, set: set1.id, player: 11, action: 29, rotation: r1, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 2, to: 2, stage: 2, server: p1, player_in: nil, detail: "", setter: p3, order: 11.0, direction: ""))
        let st12 = Stat.createStat(stat: Stat(id: 12, match: m1.id, set: set1.id, player: 4, action: 3, rotation: r1, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 2, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 12.0, direction: ""))
        let st13 = Stat.createStat(stat: Stat(id: 13, match: m1.id, set: set1.id, player: 4, action: 6, rotation: r1, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 2, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 13.0, direction: ""))
        let st14 = Stat.createStat(stat: Stat(id: 14, match: m1.id, set: set1.id, player: 4, action: 6, rotation: r1, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 2, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 14.0, direction: ""))
        let st15 = Stat.createStat(stat: Stat(id: 15, match: m1.id, set: set1.id, player: 0, action: 19, rotation: r1, rotationTurns: 2, rotationCount: 3, score_us: 5, score_them: 2, to: 1, stage: 2, server: Player(), player_in: nil, detail: "Net", setter: p3, order: 15.0, direction: ""))
        let st16 = Stat.createStat(stat: Stat(id: 16, match: m1.id, set: set1.id, player: 12, action: 41, rotation: r1, rotationTurns: 3, rotationCount: 4, score_us: 5, score_them: 2, to: 0, stage: 0, server: p12, player_in: nil, detail: "", setter: p12, order: 16.0, direction: ""))
        let st17 = Stat.createStat(stat: Stat(id: 17, match: m1.id, set: set1.id, player: 4, action: 16, rotation: r1, rotationTurns: 3, rotationCount: 4, score_us: 5, score_them: 3, to: 2, stage: 2, server: p12, player_in: nil, detail: "Out", setter: p12, order: 17.0, direction: ""))
        let st18 = Stat.createStat(stat: Stat(id: 18, match: m1.id, set: set1.id, player: 1, action: 2, rotation: r1, rotationTurns: 3, rotationCount: 4, score_us: 5, score_them: 3, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p12, order: 18.0, direction: ""))
        let st19 = Stat.createStat(stat: Stat(id: 19, match: m1.id, set: set1.id, player: 12, action: 24, rotation: r1, rotationTurns: 3, rotationCount: 4, score_us: 5, score_them: 4, to: 2, stage: 2, server: Player(), player_in: nil, detail: "", setter: p12, order: 19.0, direction: ""))
        let st20 = Stat.createStat(stat: Stat(id: 20, match: m1.id, set: set1.id, player: 9, action: 3, rotation: r1, rotationTurns: 3, rotationCount: 4, score_us: 5, score_them: 4, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p12, order: 20.0, direction: ""))
        let st21 = Stat.createStat(stat: Stat(id: 21, match: m1.id, set: set1.id, player: 3, action: 6, rotation: r1, rotationTurns: 3, rotationCount: 4, score_us: 5, score_them: 4, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p12, order: 21.0, direction: ""))
        let st22 = Stat.createStat(stat: Stat(id: 22, match: m1.id, set: set1.id, player: 11, action: 9, rotation: r1, rotationTurns: 3, rotationCount: 4, score_us: 6, score_them: 4, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p12, order: 22.0, direction: ""))
        let st23 = Stat.createStat(stat: Stat(id: 23, match: m1.id, set: set1.id, player: 4, action: 41, rotation: r1, rotationTurns: 4, rotationCount: 5, score_us: 6, score_them: 4, to: 0, stage: 0, server: p4, player_in: nil, detail: "", setter: p12, order: 23.0, direction: ""))
        let st24 = Stat.createStat(stat: Stat(id: 24, match: m1.id, set: set1.id, player: 12, action: 24, rotation: r1, rotationTurns: 4, rotationCount: 5, score_us: 6, score_them: 5, to: 2, stage: 2, server: p4, player_in: nil, detail: "", setter: p12, order: 24.0, direction: ""))
        let st25 = Stat.createStat(stat: Stat(id: 25, match: m1.id, set: set1.id, player: 0, action: 32, rotation: r1, rotationTurns: 4, rotationCount: 5, score_us: 7, score_them: 5, to: 1, stage: 1, server: Player(), player_in: nil, detail: "", setter: p12, order: 25.0, direction: ""))
        let st26 = Stat.createStat(stat: Stat(id: 26, match: m1.id, set: set1.id, player: 11, action: 15, rotation: r1, rotationTurns: 5, rotationCount: 6, score_us: 7, score_them: 6, to: 2, stage: 0, server: p11, player_in: nil, detail: "Net", setter: p12, order: 26.0, direction: ""))
        let st27 = Stat.createStat(stat: Stat(id: 27, match: m1.id, set: set1.id, player: 11, action: 4, rotation: r1, rotationTurns: 5, rotationCount: 6, score_us: 7, score_them: 6, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p12, order: 27.0, direction: ""))
        let st28 = Stat.createStat(stat: Stat(id: 28, match: m1.id, set: set1.id, player: 11, action: 23, rotation: r1, rotationTurns: 5, rotationCount: 6, score_us: 7, score_them: 7, to: 2, stage: 2, server: Player(), player_in: nil, detail: "", setter: p12, order: 28.0, direction: ""))
        let st29 = Stat.createStat(stat: Stat(id: 29, match: m1.id, set: set1.id, player: 0, action: 15, rotation: r1, rotationTurns: 5, rotationCount: 6, score_us: 8, score_them: 7, to: 1, stage: 1, server: Player(), player_in: nil, detail: "Net", setter: p12, order: 29.0, direction: ""))
        let st30 = Stat.createStat(stat: Stat(id: 30, match: m1.id, set: set1.id, player: 3, action: 8, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 9, score_them: 7, to: 1, stage: 0, server: p3, player_in: nil, detail: "", setter: p3, order: 30.0, direction: ""))
        let st31 = Stat.createStat(stat: Stat(id: 31, match: m1.id, set: set1.id, player: 3, action: 41, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 9, score_them: 7, to: 0, stage: 0, server: p3, player_in: nil, detail: "", setter: p3, order: 31.0, direction: ""))
        let st32 = Stat.createStat(stat: Stat(id: 32, match: m1.id, set: set1.id, player: 9, action: 6, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 9, score_them: 7, to: 0, stage: 2, server: p3, player_in: nil, detail: "", setter: p3, order: 32.0, direction: ""))
        let st33 = Stat.createStat(stat: Stat(id: 33, match: m1.id, set: set1.id, player: 9, action: 6, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 9, score_them: 7, to: 0, stage: 2, server: p3, player_in: nil, detail: "", setter: p3, order: 33.0, direction: ""))
        let st34 = Stat.createStat(stat: Stat(id: 34, match: m1.id, set: set1.id, player: 4, action: 19, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 9, score_them: 8, to: 2, stage: 2, server: p3, player_in: nil, detail: "Out", setter: p3, order: 34.0, direction: ""))
        let st35 = Stat.createStat(stat: Stat(id: 35, match: m1.id, set: set1.id, player: 12, action: 2, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 9, score_them: 8, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 35.0, direction: ""))
        let st36 = Stat.createStat(stat: Stat(id: 36, match: m1.id, set: set1.id, player: 12, action: 20, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 9, score_them: 9, to: 2, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 36.0, direction: ""))
        let st37 = Stat.createStat(stat: Stat(id: 37, match: m1.id, set: set1.id, player: 0, action: 15, rotation: r1, rotationTurns: 0, rotationCount: 1, score_us: 10, score_them: 9, to: 1, stage: 1, server: Player(), player_in: nil, detail: "Net", setter: p3, order: 37.0, direction: ""))
        let st38 = Stat.createStat(stat: Stat(id: 38, match: m1.id, set: set1.id, player: 9, action: 41, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 10, score_them: 9, to: 0, stage: 0, server: p9, player_in: nil, detail: "", setter: p3, order: 38.0, direction: ""))
        let st39 = Stat.createStat(stat: Stat(id: 39, match: m1.id, set: set1.id, player: 4, action: 16, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 10, score_them: 10, to: 2, stage: 2, server: p9, player_in: nil, detail: "Out", setter: p3, order: 39.0, direction: ""))
        let st40 = Stat.createStat(stat: Stat(id: 40, match: m1.id, set: set1.id, player: 3, action: 2, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 10, score_them: 10, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 40.0, direction: ""))
        let st41 = Stat.createStat(stat: Stat(id: 41, match: m1.id, set: set1.id, player: 12, action: 28, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 10, score_them: 11, to: 2, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 41.0, direction: ""))
        let st42 = Stat.createStat(stat: Stat(id: 42, match: m1.id, set: set1.id, player: 3, action: 2, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 10, score_them: 11, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 42.0, direction: ""))
        let st43 = Stat.createStat(stat: Stat(id: 43, match: m1.id, set: set1.id, player: 9, action: 23, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 10, score_them: 12, to: 2, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 43.0, direction: ""))
        let st44 = Stat.createStat(stat: Stat(id: 44, match: m1.id, set: set1.id, player: 11, action: 2, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 10, score_them: 12, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 44.0, direction: ""))
        let st45 = Stat.createStat(stat: Stat(id: 45, match: m1.id, set: set1.id, player: 1, action: 24, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 10, score_them: 13, to: 2, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 45.0, direction: ""))
        let st46 = Stat.createStat(stat: Stat(id: 46, match: m1.id, set: set1.id, player: 1, action: 16, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 10, score_them: 14, to: 2, stage: 1, server: Player(), player_in: nil, detail: "Net", setter: p3, order: 46.0, direction: ""))
        let st47 = Stat.createStat(stat: Stat(id: 47, match: m1.id, set: set1.id, player: 0, action: 15, rotation: r1, rotationTurns: 1, rotationCount: 2, score_us: 11, score_them: 14, to: 1, stage: 1, server: Player(), player_in: nil, detail: "Out", setter: p3, order: 47.0, direction: ""))
        let st48 = Stat.createStat(stat: Stat(id: 48, match: m1.id, set: set1.id, player: 1, action: 99, rotation: r1, rotationTurns: 2, rotationCount: 3, score_us: 11, score_them: 14, to: 0, stage: 0, server: p1, player_in: 13, detail: "", setter: nil, order: 48.0, direction: ""))
        let st49 = Stat.createStat(stat: Stat(id: 49, match: m1.id, set: set1.id, player: 13, action: 15, rotation: r2, rotationTurns: 0, rotationCount: 3, score_us: 11, score_them: 15, to: 2, stage: 0, server: p13, player_in: nil, detail: "Net", setter: p3, order: 49.0, direction: ""))
        let st50 = Stat.createStat(stat: Stat(id: 50, match: m1.id, set: set1.id, player: 4, action: 10, rotation: r2, rotationTurns: 0, rotationCount: 3, score_us: 12, score_them: 15, to: 1, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 50.0, direction: ""))
        let st51 = Stat.createStat(stat: Stat(id: 51, match: m1.id, set: set1.id, player: 12, action: 39, rotation: r2, rotationTurns: 1, rotationCount: 4, score_us: 12, score_them: 15, to: 0, stage: 0, server: p12, player_in: nil, detail: "", setter: p12, order: 51.0, direction: ""))
        let st52 = Stat.createStat(stat: Stat(id: 52, match: m1.id, set: set1.id, player: 13, action: 23, rotation: r2, rotationTurns: 1, rotationCount: 4, score_us: 12, score_them: 16, to: 2, stage: 2, server: p12, player_in: nil, detail: "", setter: p12, order: 52.0, direction: ""))
        let st53 = Stat.createStat(stat: Stat(id: 53, match: m1.id, set: set1.id, player: 13, action: 2, rotation: r2, rotationTurns: 1, rotationCount: 4, score_us: 12, score_them: 16, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p12, order: 53.0, direction: ""))
        let st54 = Stat.createStat(stat: Stat(id: 54, match: m1.id, set: set1.id, player: 4, action: 6, rotation: r2, rotationTurns: 1, rotationCount: 4, score_us: 12, score_them: 16, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p12, order: 54.0, direction: ""))
        let st55 = Stat.createStat(stat: Stat(id: 55, match: m1.id, set: set1.id, player: 9, action: 23, rotation: r2, rotationTurns: 1, rotationCount: 4, score_us: 12, score_them: 17, to: 2, stage: 2, server: Player(), player_in: nil, detail: "", setter: p12, order: 55.0, direction: ""))
        let st56 = Stat.createStat(stat: Stat(id: 56, match: m1.id, set: set1.id, player: 12, action: 99, rotation: r2, rotationTurns: 1, rotationCount: 4, score_us: 12, score_them: 17, to: 0, stage: 1, server: Player(), player_in: 7, detail: "", setter: nil, order: 56.0, direction: ""))
        let st57 = Stat.createStat(stat: Stat(id: 57, match: m1.id, set: set1.id, player: 3, action: 3, rotation: r3, rotationTurns: 0, rotationCount: 4, score_us: 12, score_them: 17, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 57.0, direction: ""))
        let st58 = Stat.createStat(stat: Stat(id: 58, match: m1.id, set: set1.id, player: 4, action: 9, rotation: r3, rotationTurns: 0, rotationCount: 4, score_us: 13, score_them: 17, to: 1, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 58.0, direction: ""))
        let st59 = Stat.createStat(stat: Stat(id: 59, match: m1.id, set: set1.id, player: 4, action: 15, rotation: r3, rotationTurns: 1, rotationCount: 5, score_us: 13, score_them: 18, to: 2, stage: 0, server: p4, player_in: nil, detail: "Net", setter: p7, order: 59.0, direction: ""))
        let st60 = Stat.createStat(stat: Stat(id: 60, match: m1.id, set: set1.id, player: 13, action: 2, rotation: r3, rotationTurns: 1, rotationCount: 5, score_us: 13, score_them: 18, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 60.0, direction: ""))
        let st61 = Stat.createStat(stat: Stat(id: 61, match: m1.id, set: set1.id, player: 9, action: 6, rotation: r3, rotationTurns: 1, rotationCount: 5, score_us: 13, score_them: 18, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 61.0, direction: ""))
        let st62 = Stat.createStat(stat: Stat(id: 62, match: m1.id, set: set1.id, player: 3, action: 13, rotation: r3, rotationTurns: 1, rotationCount: 5, score_us: 14, score_them: 18, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 62.0, direction: ""))
        let st63 = Stat.createStat(stat: Stat(id: 63, match: m1.id, set: set1.id, player: 11, action: 41, rotation: r3, rotationTurns: 2, rotationCount: 6, score_us: 14, score_them: 18, to: 0, stage: 0, server: p11, player_in: nil, detail: "", setter: p7, order: 63.0, direction: ""))
        let st64 = Stat.createStat(stat: Stat(id: 64, match: m1.id, set: set1.id, player: 4, action: 23, rotation: r3, rotationTurns: 2, rotationCount: 6, score_us: 14, score_them: 19, to: 2, stage: 2, server: p11, player_in: nil, detail: "", setter: p7, order: 64.0, direction: ""))
        let st65 = Stat.createStat(stat: Stat(id: 65, match: m1.id, set: set1.id, player: 4, action: 4, rotation: r3, rotationTurns: 2, rotationCount: 6, score_us: 14, score_them: 19, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 65.0, direction: ""))
        let st66 = Stat.createStat(stat: Stat(id: 66, match: m1.id, set: set1.id, player: 9, action: 10, rotation: r3, rotationTurns: 2, rotationCount: 6, score_us: 15, score_them: 19, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 66.0, direction: ""))
        let st67 = Stat.createStat(stat: Stat(id: 67, match: m1.id, set: set1.id, player: 3, action: 41, rotation: r3, rotationTurns: 3, rotationCount: 1, score_us: 15, score_them: 19, to: 0, stage: 0, server: p3, player_in: nil, detail: "", setter: p3, order: 67.0, direction: ""))
        let st68 = Stat.createStat(stat: Stat(id: 68, match: m1.id, set: set1.id, player: 9, action: 10, rotation: r3, rotationTurns: 3, rotationCount: 1, score_us: 16, score_them: 19, to: 1, stage: 2, server: p3, player_in: nil, detail: "", setter: p3, order: 68.0, direction: ""))
        let st69 = Stat.createStat(stat: Stat(id: 69, match: m1.id, set: set1.id, player: 3, action: 39, rotation: r3, rotationTurns: 3, rotationCount: 1, score_us: 16, score_them: 19, to: 0, stage: 0, server: p3, player_in: nil, detail: "", setter: p3, order: 69.0, direction: ""))
        let st70 = Stat.createStat(stat: Stat(id: 70, match: m1.id, set: set1.id, player: 13, action: 10, rotation: r3, rotationTurns: 3, rotationCount: 1, score_us: 17, score_them: 19, to: 1, stage: 2, server: p3, player_in: nil, detail: "", setter: p3, order: 70.0, direction: ""))
        let st71 = Stat.createStat(stat: Stat(id: 71, match: m1.id, set: set1.id, player: 3, action: 8, rotation: r3, rotationTurns: 3, rotationCount: 1, score_us: 18, score_them: 19, to: 1, stage: 0, server: p3, player_in: nil, detail: "", setter: p3, order: 71.0, direction: ""))
        let st72 = Stat.createStat(stat: Stat(id: 72, match: m1.id, set: set1.id, player: 3, action: 39, rotation: r3, rotationTurns: 3, rotationCount: 1, score_us: 18, score_them: 19, to: 0, stage: 0, server: p3, player_in: nil, detail: "", setter: p3, order: 72.0, direction: ""))
        let st73 = Stat.createStat(stat: Stat(id: 73, match: m1.id, set: set1.id, player: 11, action: 23, rotation: r3, rotationTurns: 3, rotationCount: 1, score_us: 18, score_them: 20, to: 2, stage: 2, server: p3, player_in: nil, detail: "", setter: p3, order: 73.0, direction: ""))
        let st74 = Stat.createStat(stat: Stat(id: 74, match: m1.id, set: set1.id, player: 7, action: 4, rotation: r3, rotationTurns: 3, rotationCount: 1, score_us: 18, score_them: 20, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 74.0, direction: ""))
        let st75 = Stat.createStat(stat: Stat(id: 75, match: m1.id, set: set1.id, player: 7, action: 9, rotation: r3, rotationTurns: 3, rotationCount: 1, score_us: 19, score_them: 20, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 75.0, direction: ""))
        let st76 = Stat.createStat(stat: Stat(id: 76, match: m1.id, set: set1.id, player: 9, action: 41, rotation: r3, rotationTurns: 4, rotationCount: 2, score_us: 19, score_them: 20, to: 0, stage: 0, server: p9, player_in: nil, detail: "", setter: p3, order: 76.0, direction: ""))
        let st77 = Stat.createStat(stat: Stat(id: 77, match: m1.id, set: set1.id, player: 13, action: 10, rotation: r3, rotationTurns: 4, rotationCount: 2, score_us: 20, score_them: 20, to: 1, stage: 2, server: p9, player_in: nil, detail: "", setter: p3, order: 77.0, direction: ""))
        let st78 = Stat.createStat(stat: Stat(id: 78, match: m1.id, set: set1.id, player: 9, action: 8, rotation: r3, rotationTurns: 4, rotationCount: 2, score_us: 21, score_them: 20, to: 1, stage: 0, server: p9, player_in: nil, detail: "", setter: p3, order: 78.0, direction: ""))
        let st79 = Stat.createStat(stat: Stat(id: 79, match: m1.id, set: set1.id, player: 9, action: 8, rotation: r3, rotationTurns: 4, rotationCount: 2, score_us: 22, score_them: 20, to: 1, stage: 0, server: p9, player_in: nil, detail: "", setter: p3, order: 79.0, direction: ""))
        let st80 = Stat.createStat(stat: Stat(id: 80, match: m1.id, set: set1.id, player: 9, action: 39, rotation: r3, rotationTurns: 4, rotationCount: 2, score_us: 22, score_them: 20, to: 0, stage: 0, server: p9, player_in: nil, detail: "", setter: p3, order: 80.0, direction: ""))
        let st81 = Stat.createStat(stat: Stat(id: 81, match: m1.id, set: set1.id, player: 4, action: 10, rotation: r3, rotationTurns: 4, rotationCount: 2, score_us: 23, score_them: 20, to: 1, stage: 2, server: p9, player_in: nil, detail: "", setter: p3, order: 81.0, direction: ""))
        let st82 = Stat.createStat(stat: Stat(id: 82, match: m1.id, set: set1.id, player: 9, action: 40, rotation: r3, rotationTurns: 5, rotationCount: 3, score_us: 23, score_them: 20, to: 0, stage: 0, server: p13, player_in: nil, detail: "", setter: p3, order: 82.0, direction: ""))
        let st83 = Stat.createStat(stat: Stat(id: 83, match: m1.id, set: set1.id, player: 4, action: 16, rotation: r3, rotationTurns: 5, rotationCount: 3, score_us: 23, score_them: 21, to: 2, stage: 2, server: p13, player_in: nil, detail: "Net", setter: p3, order: 83.0, direction: ""))
        let st84 = Stat.createStat(stat: Stat(id: 84, match: m1.id, set: set1.id, player: 11, action: 2, rotation: r3, rotationTurns: 5, rotationCount: 3, score_us: 23, score_them: 21, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 84.0, direction: ""))
        let st85 = Stat.createStat(stat: Stat(id: 85, match: m1.id, set: set1.id, player: 13, action: 6, rotation: r3, rotationTurns: 5, rotationCount: 3, score_us: 23, score_them: 21, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 85.0, direction: ""))
        let st86 = Stat.createStat(stat: Stat(id: 86, match: m1.id, set: set1.id, player: 13, action: 6, rotation: r3, rotationTurns: 5, rotationCount: 3, score_us: 23, score_them: 21, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 86.0, direction: ""))
        let st87 = Stat.createStat(stat: Stat(id: 87, match: m1.id, set: set1.id, player: 0, action: 28, rotation: r3, rotationTurns: 5, rotationCount: 3, score_us: 24, score_them: 21, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 87.0, direction: ""))
        let st88 = Stat.createStat(stat: Stat(id: 88, match: m1.id, set: set1.id, player: 13, action: 8, rotation: r3, rotationTurns: 0, rotationCount: 4, score_us: 25, score_them: 21, to: 1, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 88.0, direction: ""))
        let st89 = Stat.createStat(stat: Stat(id: 89, match: m1.id, set: set2.id, player: 7, action: 41, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 0, score_them: 0, to: 0, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 0.0, direction: ""))
        let st90 = Stat.createStat(stat: Stat(id: 90, match: m1.id, set: set2.id, player: 10, action: 16, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 0, score_them: 1, to: 2, stage: 2, server: p7, player_in: nil, detail: "Out", setter: p7, order: 1.0, direction: ""))
        let st91 = Stat.createStat(stat: Stat(id: 91, match: m1.id, set: set2.id, player: 5, action: 4, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 0, score_them: 1, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 2.0, direction: ""))
        let st92 = Stat.createStat(stat: Stat(id: 92, match: m1.id, set: set2.id, player: 5, action: 6, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 0, score_them: 1, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 3.0, direction: ""))
        let st93 = Stat.createStat(stat: Stat(id: 93, match: m1.id, set: set2.id, player: 10, action: 10, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 1, score_them: 1, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 4.0, direction: ""))
        let st94 = Stat.createStat(stat: Stat(id: 94, match: m1.id, set: set2.id, player: 10, action: 39, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 1, score_them: 1, to: 0, stage: 0, server: p10, player_in: nil, detail: "", setter: p7, order: 5.0, direction: ""))
        let st95 = Stat.createStat(stat: Stat(id: 95, match: m1.id, set: set2.id, player: 0, action: 24, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 2, score_them: 1, to: 1, stage: 2, server: p10, player_in: nil, detail: "", setter: p7, order: 6.0, direction: ""))
        let st96 = Stat.createStat(stat: Stat(id: 96, match: m1.id, set: set2.id, player: 10, action: 41, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 2, score_them: 1, to: 0, stage: 0, server: p10, player_in: nil, detail: "", setter: p7, order: 7.0, direction: ""))
        let st97 = Stat.createStat(stat: Stat(id: 97, match: m1.id, set: set2.id, player: 8, action: 9, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 3, score_them: 1, to: 1, stage: 2, server: p10, player_in: nil, detail: "", setter: p7, order: 8.0, direction: ""))
        let st98 = Stat.createStat(stat: Stat(id: 98, match: m1.id, set: set2.id, player: 10, action: 15, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 3, score_them: 2, to: 2, stage: 0, server: p10, player_in: nil, detail: "Out", setter: p7, order: 9.0, direction: ""))
        let st99 = Stat.createStat(stat: Stat(id: 99, match: m1.id, set: set2.id, player: 0, action: 15, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 4, score_them: 2, to: 1, stage: 1, server: Player(), player_in: nil, detail: "Net", setter: p7, order: 10.0, direction: ""))
        let st100 = Stat.createStat(stat: Stat(id: 100, match: m1.id, set: set2.id, player: 13, action: 41, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 2, to: 0, stage: 0, server: p13, player_in: nil, detail: "", setter: p7, order: 11.0, direction: ""))
        let st101 = Stat.createStat(stat: Stat(id: 101, match: m1.id, set: set2.id, player: 2, action: 6, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 2, to: 0, stage: 2, server: p13, player_in: nil, detail: "", setter: p7, order: 12.0, direction: ""))
        let st102 = Stat.createStat(stat: Stat(id: 102, match: m1.id, set: set2.id, player: 10, action: 23, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 3, to: 2, stage: 2, server: p13, player_in: nil, detail: "", setter: p7, order: 13.0, direction: ""))
        let st103 = Stat.createStat(stat: Stat(id: 103, match: m1.id, set: set2.id, player: 13, action: 22, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 4, to: 2, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 14.0, direction: ""))
        let st104 = Stat.createStat(stat: Stat(id: 104, match: m1.id, set: set2.id, player: 5, action: 2, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 4, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 15.0, direction: ""))
        let st105 = Stat.createStat(stat: Stat(id: 105, match: m1.id, set: set2.id, player: 7, action: 21, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 5, to: 2, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 16.0, direction: ""))
        let st106 = Stat.createStat(stat: Stat(id: 106, match: m1.id, set: set2.id, player: 8, action: 2, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 4, score_them: 5, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 17.0, direction: ""))
        let st107 = Stat.createStat(stat: Stat(id: 107, match: m1.id, set: set2.id, player: 2, action: 10, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 5, score_them: 5, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 18.0, direction: ""))
        let st108 = Stat.createStat(stat: Stat(id: 108, match: m1.id, set: set2.id, player: 5, action: 40, rotation: r4, rotationTurns: 3, rotationCount: 4, score_us: 5, score_them: 5, to: 0, stage: 0, server: p5, player_in: nil, detail: "", setter: p5, order: 19.0, direction: ""))
        let st109 = Stat.createStat(stat: Stat(id: 109, match: m1.id, set: set2.id, player: 0, action: 16, rotation: r4, rotationTurns: 3, rotationCount: 4, score_us: 6, score_them: 5, to: 1, stage: 2, server: p5, player_in: nil, detail: "Out", setter: p5, order: 20.0, direction: ""))
        let st110 = Stat.createStat(stat: Stat(id: 110, match: m1.id, set: set2.id, player: 5, action: 15, rotation: r4, rotationTurns: 3, rotationCount: 4, score_us: 6, score_them: 6, to: 2, stage: 0, server: p5, player_in: nil, detail: "Net", setter: p5, order: 21.0, direction: ""))
        let st111 = Stat.createStat(stat: Stat(id: 111, match: m1.id, set: set2.id, player: 13, action: 3, rotation: r4, rotationTurns: 3, rotationCount: 4, score_us: 6, score_them: 6, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p5, order: 22.0, direction: ""))
        let st112 = Stat.createStat(stat: Stat(id: 112, match: m1.id, set: set2.id, player: 7, action: 9, rotation: r4, rotationTurns: 3, rotationCount: 4, score_us: 7, score_them: 6, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p5, order: 23.0, direction: ""))
        let st113 = Stat.createStat(stat: Stat(id: 113, match: m1.id, set: set2.id, player: 8, action: 8, rotation: r4, rotationTurns: 4, rotationCount: 5, score_us: 8, score_them: 6, to: 1, stage: 0, server: p8, player_in: nil, detail: "", setter: p5, order: 24.0, direction: ""))
        let st114 = Stat.createStat(stat: Stat(id: 114, match: m1.id, set: set2.id, player: 8, action: 41, rotation: r4, rotationTurns: 4, rotationCount: 5, score_us: 8, score_them: 6, to: 0, stage: 0, server: p8, player_in: nil, detail: "", setter: p5, order: 25.0, direction: ""))
        let st115 = Stat.createStat(stat: Stat(id: 115, match: m1.id, set: set2.id, player: 7, action: 15, rotation: r4, rotationTurns: 4, rotationCount: 5, score_us: 8, score_them: 7, to: 2, stage: 2, server: p8, player_in: nil, detail: "Out", setter: p5, order: 26.0, direction: ""))
        let st116 = Stat.createStat(stat: Stat(id: 116, match: m1.id, set: set2.id, player: 0, action: 15, rotation: r4, rotationTurns: 4, rotationCount: 5, score_us: 9, score_them: 7, to: 1, stage: 1, server: Player(), player_in: nil, detail: "Net", setter: p5, order: 27.0, direction: ""))
        let st117 = Stat.createStat(stat: Stat(id: 117, match: m1.id, set: set2.id, player: 2, action: 8, rotation: r4, rotationTurns: 5, rotationCount: 6, score_us: 10, score_them: 7, to: 1, stage: 0, server: p2, player_in: nil, detail: "", setter: p5, order: 28.0, direction: ""))
        let st118 = Stat.createStat(stat: Stat(id: 118, match: m1.id, set: set2.id, player: 2, action: 32, rotation: r4, rotationTurns: 5, rotationCount: 6, score_us: 10, score_them: 8, to: 2, stage: 0, server: p2, player_in: nil, detail: "", setter: p5, order: 29.0, direction: ""))
        let st119 = Stat.createStat(stat: Stat(id: 119, match: m1.id, set: set2.id, player: 0, action: 15, rotation: r4, rotationTurns: 5, rotationCount: 6, score_us: 11, score_them: 8, to: 1, stage: 1, server: Player(), player_in: nil, detail: "Net", setter: p5, order: 30.0, direction: ""))
        let st120 = Stat.createStat(stat: Stat(id: 120, match: m1.id, set: set2.id, player: 7, action: 39, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 11, score_them: 8, to: 0, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 31.0, direction: ""))
        let st121 = Stat.createStat(stat: Stat(id: 121, match: m1.id, set: set2.id, player: 0, action: 16, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 12, score_them: 8, to: 1, stage: 2, server: p7, player_in: nil, detail: "Out", setter: p7, order: 32.0, direction: ""))
        let st122 = Stat.createStat(stat: Stat(id: 122, match: m1.id, set: set2.id, player: 7, action: 8, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 13, score_them: 8, to: 1, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 33.0, direction: ""))
        let st123 = Stat.createStat(stat: Stat(id: 123, match: m1.id, set: set2.id, player: 7, action: 8, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 14, score_them: 8, to: 1, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 34.0, direction: ""))
        let st124 = Stat.createStat(stat: Stat(id: 124, match: m1.id, set: set2.id, player: 7, action: 41, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 14, score_them: 8, to: 0, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 35.0, direction: ""))
        let st125 = Stat.createStat(stat: Stat(id: 125, match: m1.id, set: set2.id, player: 10, action: 13, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 15, score_them: 8, to: 1, stage: 2, server: p7, player_in: nil, detail: "", setter: p7, order: 36.0, direction: ""))
        let st126 = Stat.createStat(stat: Stat(id: 126, match: m1.id, set: set2.id, player: 7, action: 8, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 16, score_them: 8, to: 1, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 37.0, direction: ""))
        let st127 = Stat.createStat(stat: Stat(id: 127, match: m1.id, set: set2.id, player: 0, action: 0, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 16, score_them: 8, to: 2, stage: 0, server: p7, player_in: nil, detail: "", setter: nil, order: 38.0, direction: ""))
        let st128 = Stat.createStat(stat: Stat(id: 128, match: m1.id, set: set2.id, player: 7, action: 15, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 16, score_them: 9, to: 2, stage: 0, server: p7, player_in: nil, detail: "Out", setter: p7, order: 39.0, direction: ""))
        let st129 = Stat.createStat(stat: Stat(id: 129, match: m1.id, set: set2.id, player: 5, action: 2, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 16, score_them: 9, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 40.0, direction: ""))
        let st130 = Stat.createStat(stat: Stat(id: 130, match: m1.id, set: set2.id, player: 0, action: 16, rotation: r4, rotationTurns: 0, rotationCount: 1, score_us: 17, score_them: 9, to: 1, stage: 2, server: Player(), player_in: nil, detail: "Out", setter: p7, order: 41.0, direction: ""))
        let st131 = Stat.createStat(stat: Stat(id: 131, match: m1.id, set: set2.id, player: 10, action: 41, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 17, score_them: 9, to: 0, stage: 0, server: p10, player_in: nil, detail: "", setter: p7, order: 42.0, direction: ""))
        let st132 = Stat.createStat(stat: Stat(id: 132, match: m1.id, set: set2.id, player: 0, action: 24, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 18, score_them: 9, to: 1, stage: 2, server: p10, player_in: nil, detail: "", setter: p7, order: 43.0, direction: ""))
        let st133 = Stat.createStat(stat: Stat(id: 133, match: m1.id, set: set2.id, player: 10, action: 41, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 18, score_them: 9, to: 0, stage: 0, server: p10, player_in: nil, detail: "", setter: p7, order: 44.0, direction: ""))
        let st134 = Stat.createStat(stat: Stat(id: 134, match: m1.id, set: set2.id, player: 13, action: 9, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 19, score_them: 9, to: 1, stage: 2, server: p10, player_in: nil, detail: "", setter: p7, order: 45.0, direction: ""))
        let st135 = Stat.createStat(stat: Stat(id: 135, match: m1.id, set: set2.id, player: 10, action: 15, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 19, score_them: 10, to: 2, stage: 0, server: p10, player_in: nil, detail: "Net", setter: p7, order: 46.0, direction: ""))
        let st136 = Stat.createStat(stat: Stat(id: 136, match: m1.id, set: set2.id, player: 10, action: 4, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 19, score_them: 10, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 47.0, direction: ""))
        let st137 = Stat.createStat(stat: Stat(id: 137, match: m1.id, set: set2.id, player: 5, action: 6, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 19, score_them: 10, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 48.0, direction: ""))
        let st138 = Stat.createStat(stat: Stat(id: 138, match: m1.id, set: set2.id, player: 0, action: 16, rotation: r4, rotationTurns: 1, rotationCount: 2, score_us: 20, score_them: 10, to: 1, stage: 2, server: Player(), player_in: nil, detail: "Net", setter: p7, order: 49.0, direction: ""))
        let st139 = Stat.createStat(stat: Stat(id: 139, match: m1.id, set: set2.id, player: 13, action: 40, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 20, score_them: 10, to: 0, stage: 0, server: p13, player_in: nil, detail: "", setter: p7, order: 50.0, direction: ""))
        let st140 = Stat.createStat(stat: Stat(id: 140, match: m1.id, set: set2.id, player: 8, action: 6, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 20, score_them: 10, to: 0, stage: 2, server: p13, player_in: nil, detail: "", setter: p7, order: 51.0, direction: ""))
        let st141 = Stat.createStat(stat: Stat(id: 141, match: m1.id, set: set2.id, player: 0, action: 16, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 21, score_them: 10, to: 1, stage: 2, server: p13, player_in: nil, detail: "Net", setter: p7, order: 52.0, direction: ""))
        let st142 = Stat.createStat(stat: Stat(id: 142, match: m1.id, set: set2.id, player: 13, action: 41, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 21, score_them: 10, to: 0, stage: 0, server: p13, player_in: nil, detail: "", setter: p7, order: 53.0, direction: ""))
        let st143 = Stat.createStat(stat: Stat(id: 143, match: m1.id, set: set2.id, player: 5, action: 9, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 22, score_them: 10, to: 1, stage: 2, server: p13, player_in: nil, detail: "", setter: p7, order: 54.0, direction: ""))
        let st144 = Stat.createStat(stat: Stat(id: 144, match: m1.id, set: set2.id, player: 13, action: 8, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 23, score_them: 10, to: 1, stage: 0, server: p13, player_in: nil, detail: "", setter: p7, order: 55.0, direction: ""))
        let st145 = Stat.createStat(stat: Stat(id: 145, match: m1.id, set: set2.id, player: 0, action: 0, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 23, score_them: 10, to: 2, stage: 0, server: p13, player_in: nil, detail: "", setter: nil, order: 56.0, direction: ""))
        let st146 = Stat.createStat(stat: Stat(id: 146, match: m1.id, set: set2.id, player: 13, action: 8, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 10, to: 1, stage: 0, server: p13, player_in: nil, detail: "", setter: p7, order: 57.0, direction: ""))
        let st147 = Stat.createStat(stat: Stat(id: 147, match: m1.id, set: set2.id, player: 2, action: 6, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 10, to: 0, stage: 0, server: p13, player_in: nil, detail: "", setter: p7, order: 58.0, direction: ""))
        let st148 = Stat.createStat(stat: Stat(id: 148, match: m1.id, set: set2.id, player: 8, action: 16, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 11, to: 2, stage: 2, server: p13, player_in: nil, detail: "Net", setter: p7, order: 59.0, direction: ""))
        let st149 = Stat.createStat(stat: Stat(id: 149, match: m1.id, set: set2.id, player: 8, action: 3, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 11, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 60.0, direction: ""))
        let st150 = Stat.createStat(stat: Stat(id: 150, match: m1.id, set: set2.id, player: 5, action: 6, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 11, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 61.0, direction: ""))
        let st151 = Stat.createStat(stat: Stat(id: 151, match: m1.id, set: set2.id, player: 8, action: 6, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 11, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 62.0, direction: ""))
        let st152 = Stat.createStat(stat: Stat(id: 152, match: m1.id, set: set2.id, player: 13, action: 23, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 12, to: 2, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 63.0, direction: ""))
        let st153 = Stat.createStat(stat: Stat(id: 153, match: m1.id, set: set2.id, player: 13, action: 22, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 13, to: 2, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 64.0, direction: ""))
        let st154 = Stat.createStat(stat: Stat(id: 154, match: m1.id, set: set2.id, player: 13, action: 22, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 14, to: 2, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 65.0, direction: ""))
        let st155 = Stat.createStat(stat: Stat(id: 155, match: m1.id, set: set2.id, player: 10, action: 3, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 24, score_them: 14, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 66.0, direction: ""))
        let st156 = Stat.createStat(stat: Stat(id: 156, match: m1.id, set: set2.id, player: 0, action: 98, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 25, score_them: 14, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: nil, order: 67.0, direction: ""))
        let st157 = Stat.createStat(stat: Stat(id: 157, match: m1.id, set: set2.id, player: 0, action: 98, rotation: r4, rotationTurns: 2, rotationCount: 3, score_us: 25, score_them: 14, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: nil, order: 67.0, direction: ""))
        let st158 = Stat.createStat(stat: Stat(id: 158, match: m1.id, set: set3.id, player: 0, action: 15, rotation: r5, rotationTurns: 0, rotationCount: 1, score_us: 1, score_them: 0, to: 1, stage: 1, server: Player(), player_in: nil, detail: "Net", setter: p3, order: 0.0, direction: ""))
        let st159 = Stat.createStat(stat: Stat(id: 159, match: m1.id, set: set3.id, player: 7, action: 41, rotation: r5, rotationTurns: 1, rotationCount: 2, score_us: 1, score_them: 0, to: 0, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 1.0, direction: ""))
        let st160 = Stat.createStat(stat: Stat(id: 160, match: m1.id, set: set3.id, player: 13, action: 9, rotation: r5, rotationTurns: 1, rotationCount: 2, score_us: 2, score_them: 0, to: 1, stage: 2, server: p7, player_in: nil, detail: "", setter: p7, order: 2.0, direction: ""))
        let st161 = Stat.createStat(stat: Stat(id: 161, match: m1.id, set: set3.id, player: 7, action: 8, rotation: r5, rotationTurns: 1, rotationCount: 2, score_us: 3, score_them: 0, to: 1, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 3.0, direction: ""))
        let st162 = Stat.createStat(stat: Stat(id: 162, match: m1.id, set: set3.id, player: 4, action: 6, rotation: r5, rotationTurns: 1, rotationCount: 2, score_us: 3, score_them: 0, to: 0, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 4.0, direction: ""))
        let st163 = Stat.createStat(stat: Stat(id: 163, match: m1.id, set: set3.id, player: 7, action: 28, rotation: r5, rotationTurns: 1, rotationCount: 2, score_us: 3, score_them: 1, to: 2, stage: 2, server: p7, player_in: nil, detail: "", setter: p7, order: 5.0, direction: ""))
        let st164 = Stat.createStat(stat: Stat(id: 164, match: m1.id, set: set3.id, player: 4, action: 2, rotation: r5, rotationTurns: 1, rotationCount: 2, score_us: 3, score_them: 1, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 6.0, direction: ""))
        let st165 = Stat.createStat(stat: Stat(id: 165, match: m1.id, set: set3.id, player: 0, action: 29, rotation: r5, rotationTurns: 1, rotationCount: 2, score_us: 4, score_them: 1, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 7.0, direction: ""))
        let st166 = Stat.createStat(stat: Stat(id: 166, match: m1.id, set: set3.id, player: 4, action: 8, rotation: r5, rotationTurns: 2, rotationCount: 3, score_us: 5, score_them: 1, to: 1, stage: 0, server: p4, player_in: nil, detail: "", setter: p7, order: 8.0, direction: ""))
        let st167 = Stat.createStat(stat: Stat(id: 167, match: m1.id, set: set3.id, player: 4, action: 15, rotation: r5, rotationTurns: 2, rotationCount: 3, score_us: 5, score_them: 2, to: 2, stage: 0, server: p4, player_in: nil, detail: "Net", setter: p7, order: 9.0, direction: ""))
        let st168 = Stat.createStat(stat: Stat(id: 168, match: m1.id, set: set3.id, player: 8, action: 22, rotation: r5, rotationTurns: 2, rotationCount: 3, score_us: 5, score_them: 3, to: 2, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 10.0, direction: ""))
        let st169 = Stat.createStat(stat: Stat(id: 169, match: m1.id, set: set3.id, player: 0, action: 15, rotation: r5, rotationTurns: 2, rotationCount: 3, score_us: 6, score_them: 3, to: 1, stage: 1, server: Player(), player_in: nil, detail: "Out", setter: p7, order: 11.0, direction: ""))
        let st170 = Stat.createStat(stat: Stat(id: 170, match: m1.id, set: set3.id, player: 13, action: 41, rotation: r5, rotationTurns: 3, rotationCount: 4, score_us: 6, score_them: 3, to: 0, stage: 0, server: p13, player_in: nil, detail: "", setter: p7, order: 12.0, direction: ""))
        let st171 = Stat.createStat(stat: Stat(id: 171, match: m1.id, set: set3.id, player: 0, action: 29, rotation: r5, rotationTurns: 3, rotationCount: 4, score_us: 7, score_them: 3, to: 1, stage: 2, server: p13, player_in: nil, detail: "", setter: p7, order: 13.0, direction: ""))
        let st172 = Stat.createStat(stat: Stat(id: 172, match: m1.id, set: set3.id, player: 13, action: 41, rotation: r5, rotationTurns: 3, rotationCount: 4, score_us: 7, score_them: 3, to: 0, stage: 0, server: p13, player_in: nil, detail: "", setter: p7, order: 14.0, direction: ""))
        let st173 = Stat.createStat(stat: Stat(id: 173, match: m1.id, set: set3.id, player: 2, action: 9, rotation: r5, rotationTurns: 3, rotationCount: 4, score_us: 8, score_them: 3, to: 1, stage: 2, server: p13, player_in: nil, detail: "", setter: p7, order: 15.0, direction: ""))
        let st174 = Stat.createStat(stat: Stat(id: 174, match: m1.id, set: set3.id, player: 13, action: 41, rotation: r5, rotationTurns: 3, rotationCount: 4, score_us: 8, score_them: 3, to: 0, stage: 0, server: p13, player_in: nil, detail: "", setter: p7, order: 16.0, direction: ""))
        let st175 = Stat.createStat(stat: Stat(id: 175, match: m1.id, set: set3.id, player: 8, action: 9, rotation: r5, rotationTurns: 3, rotationCount: 4, score_us: 9, score_them: 3, to: 1, stage: 2, server: p13, player_in: nil, detail: "", setter: p7, order: 17.0, direction: ""))
        let st176 = Stat.createStat(stat: Stat(id: 176, match: m1.id, set: set3.id, player: 13, action: 15, rotation: r5, rotationTurns: 3, rotationCount: 4, score_us: 9, score_them: 4, to: 2, stage: 0, server: p13, player_in: nil, detail: "Net", setter: p7, order: 18.0, direction: ""))
        let st177 = Stat.createStat(stat: Stat(id: 177, match: m1.id, set: set3.id, player: 3, action: 4, rotation: r5, rotationTurns: 3, rotationCount: 4, score_us: 9, score_them: 4, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 19.0, direction: ""))
        let st178 = Stat.createStat(stat: Stat(id: 178, match: m1.id, set: set3.id, player: 0, action: 16, rotation: r5, rotationTurns: 3, rotationCount: 4, score_us: 10, score_them: 4, to: 1, stage: 2, server: Player(), player_in: nil, detail: "Net", setter: p7, order: 20.0, direction: ""))
        let st179 = Stat.createStat(stat: Stat(id: 179, match: m1.id, set: set3.id, player: 3, action: 40, rotation: r5, rotationTurns: 4, rotationCount: 5, score_us: 10, score_them: 4, to: 0, stage: 0, server: p3, player_in: nil, detail: "", setter: p3, order: 21.0, direction: ""))
        let st180 = Stat.createStat(stat: Stat(id: 180, match: m1.id, set: set3.id, player: 2, action: 20, rotation: r5, rotationTurns: 4, rotationCount: 5, score_us: 10, score_them: 5, to: 2, stage: 2, server: p3, player_in: nil, detail: "", setter: p3, order: 22.0, direction: ""))
        let st181 = Stat.createStat(stat: Stat(id: 181, match: m1.id, set: set3.id, player: 7, action: 16, rotation: r5, rotationTurns: 4, rotationCount: 5, score_us: 10, score_them: 6, to: 2, stage: 1, server: Player(), player_in: nil, detail: "Out", setter: p3, order: 23.0, direction: ""))
        let st182 = Stat.createStat(stat: Stat(id: 182, match: m1.id, set: set3.id, player: 7, action: 3, rotation: r5, rotationTurns: 4, rotationCount: 5, score_us: 10, score_them: 6, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 24.0, direction: ""))
        let st183 = Stat.createStat(stat: Stat(id: 183, match: m1.id, set: set3.id, player: 0, action: 28, rotation: r5, rotationTurns: 4, rotationCount: 5, score_us: 11, score_them: 6, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 25.0, direction: ""))
        let st184 = Stat.createStat(stat: Stat(id: 184, match: m1.id, set: set3.id, player: 8, action: 8, rotation: r5, rotationTurns: 5, rotationCount: 6, score_us: 12, score_them: 6, to: 1, stage: 0, server: p8, player_in: nil, detail: "", setter: p3, order: 26.0, direction: ""))
        let st185 = Stat.createStat(stat: Stat(id: 185, match: m1.id, set: set3.id, player: 8, action: 41, rotation: r5, rotationTurns: 5, rotationCount: 6, score_us: 12, score_them: 6, to: 0, stage: 0, server: p8, player_in: nil, detail: "", setter: p3, order: 27.0, direction: ""))
        let st186 = Stat.createStat(stat: Stat(id: 186, match: m1.id, set: set3.id, player: 4, action: 16, rotation: r5, rotationTurns: 5, rotationCount: 6, score_us: 12, score_them: 7, to: 2, stage: 2, server: p8, player_in: nil, detail: "Out", setter: p3, order: 28.0, direction: ""))
        let st187 = Stat.createStat(stat: Stat(id: 187, match: m1.id, set: set3.id, player: 3, action: 4, rotation: r5, rotationTurns: 5, rotationCount: 6, score_us: 12, score_them: 7, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 29.0, direction: ""))
        let st188 = Stat.createStat(stat: Stat(id: 188, match: m1.id, set: set3.id, player: 4, action: 11, rotation: r5, rotationTurns: 5, rotationCount: 6, score_us: 13, score_them: 7, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 30.0, direction: ""))
        let st189 = Stat.createStat(stat: Stat(id: 189, match: m1.id, set: set3.id, player: 2, action: 39, rotation: r5, rotationTurns: 0, rotationCount: 1, score_us: 13, score_them: 7, to: 0, stage: 0, server: p2, player_in: nil, detail: "", setter: p3, order: 31.0, direction: ""))
        let st190 = Stat.createStat(stat: Stat(id: 190, match: m1.id, set: set3.id, player: 4, action: 6, rotation: r5, rotationTurns: 0, rotationCount: 1, score_us: 13, score_them: 7, to: 0, stage: 2, server: p2, player_in: nil, detail: "", setter: p3, order: 32.0, direction: ""))
        let st191 = Stat.createStat(stat: Stat(id: 191, match: m1.id, set: set3.id, player: 2, action: 23, rotation: r5, rotationTurns: 0, rotationCount: 1, score_us: 13, score_them: 8, to: 2, stage: 2, server: p2, player_in: nil, detail: "", setter: p3, order: 33.0, direction: ""))
        let st192 = Stat.createStat(stat: Stat(id: 192, match: m1.id, set: set3.id, player: 4, action: 3, rotation: r5, rotationTurns: 0, rotationCount: 1, score_us: 13, score_them: 8, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p3, order: 34.0, direction: ""))
        let st193 = Stat.createStat(stat: Stat(id: 193, match: m1.id, set: set3.id, player: 4, action: 6, rotation: r5, rotationTurns: 0, rotationCount: 1, score_us: 13, score_them: 8, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 35.0, direction: ""))
        let st194 = Stat.createStat(stat: Stat(id: 194, match: m1.id, set: set3.id, player: 0, action: 21, rotation: r5, rotationTurns: 0, rotationCount: 1, score_us: 14, score_them: 8, to: 1, stage: 2, server: Player(), player_in: nil, detail: "", setter: p3, order: 36.0, direction: ""))
        let st195 = Stat.createStat(stat: Stat(id: 195, match: m1.id, set: set3.id, player: 13, action: 99, rotation: r5, rotationTurns: 1, rotationCount: 2, score_us: 14, score_them: 8, to: 0, stage: 0, server: p7, player_in: 1, detail: "", setter: nil, order: 37.0, direction: ""))
        let st196 = Stat.createStat(stat: Stat(id: 196, match: m1.id, set: set3.id, player: 7, action: 8, rotation: r6, rotationTurns: 0, rotationCount: 2, score_us: 15, score_them: 8, to: 1, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 38.0, direction: ""))
        let st197 = Stat.createStat(stat: Stat(id: 197, match: m1.id, set: set3.id, player: 7, action: 41, rotation: r6, rotationTurns: 0, rotationCount: 2, score_us: 15, score_them: 8, to: 0, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 39.0, direction: ""))
        let st198 = Stat.createStat(stat: Stat(id: 198, match: m1.id, set: set3.id, player: 1, action: 9, rotation: r6, rotationTurns: 0, rotationCount: 2, score_us: 16, score_them: 8, to: 1, stage: 2, server: p7, player_in: nil, detail: "", setter: p7, order: 40.0, direction: ""))
        let st199 = Stat.createStat(stat: Stat(id: 199, match: m1.id, set: set3.id, player: 0, action: 0, rotation: r6, rotationTurns: 0, rotationCount: 2, score_us: 16, score_them: 8, to: 2, stage: 0, server: p7, player_in: nil, detail: "", setter: nil, order: 41.0, direction: ""))
        let st200 = Stat.createStat(stat: Stat(id: 200, match: m1.id, set: set3.id, player: 7, action: 8, rotation: r6, rotationTurns: 0, rotationCount: 2, score_us: 17, score_them: 8, to: 1, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 42.0, direction: ""))
        let st201 = Stat.createStat(stat: Stat(id: 201, match: m1.id, set: set3.id, player: 7, action: 8, rotation: r6, rotationTurns: 0, rotationCount: 2, score_us: 18, score_them: 8, to: 1, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 43.0, direction: ""))
        let st202 = Stat.createStat(stat: Stat(id: 202, match: m1.id, set: set3.id, player: 8, action: 99, rotation: r6, rotationTurns: 0, rotationCount: 2, score_us: 18, score_them: 8, to: 0, stage: 0, server: p7, player_in: 9, detail: "", setter: nil, order: 44.0, direction: ""))
        let st203 = Stat.createStat(stat: Stat(id: 203, match: m1.id, set: set3.id, player: 7, action: 41, rotation: r7, rotationTurns: 0, rotationCount: 2, score_us: 18, score_them: 8, to: 0, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 45.0, direction: ""))
        let st204 = Stat.createStat(stat: Stat(id: 204, match: m1.id, set: set3.id, player: 1, action: 9, rotation: r7, rotationTurns: 0, rotationCount: 2, score_us: 19, score_them: 8, to: 1, stage: 2, server: p7, player_in: nil, detail: "", setter: p7, order: 46.0, direction: ""))
        let st205 = Stat.createStat(stat: Stat(id: 205, match: m1.id, set: set3.id, player: 7, action: 41, rotation: r7, rotationTurns: 0, rotationCount: 2, score_us: 19, score_them: 8, to: 0, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 47.0, direction: ""))
        let st206 = Stat.createStat(stat: Stat(id: 206, match: m1.id, set: set3.id, player: 4, action: 6, rotation: r7, rotationTurns: 0, rotationCount: 2, score_us: 19, score_them: 8, to: 0, stage: 2, server: p7, player_in: nil, detail: "", setter: p7, order: 48.0, direction: ""))
        let st207 = Stat.createStat(stat: Stat(id: 207, match: m1.id, set: set3.id, player: 1, action: 9, rotation: r7, rotationTurns: 0, rotationCount: 2, score_us: 20, score_them: 8, to: 1, stage: 2, server: p7, player_in: nil, detail: "", setter: p7, order: 49.0, direction: ""))
        let st208 = Stat.createStat(stat: Stat(id: 208, match: m1.id, set: set3.id, player: 3, action: 99, rotation: r7, rotationTurns: 0, rotationCount: 2, score_us: 20, score_them: 8, to: 0, stage: 0, server: p7, player_in: 12, detail: "", setter: nil, order: 50.0, direction: ""))
        let st209 = Stat.createStat(stat: Stat(id: 209, match: m1.id, set: set3.id, player: 7, action: 40, rotation: r8, rotationTurns: 0, rotationCount: 2, score_us: 20, score_them: 8, to: 0, stage: 0, server: p7, player_in: nil, detail: "", setter: p7, order: 51.0, direction: ""))
        let st210 = Stat.createStat(stat: Stat(id: 210, match: m1.id, set: set3.id, player: 2, action: 23, rotation: r8, rotationTurns: 0, rotationCount: 2, score_us: 20, score_them: 9, to: 2, stage: 2, server: p7, player_in: nil, detail: "", setter: p7, order: 52.0, direction: ""))
        let st211 = Stat.createStat(stat: Stat(id: 211, match: m1.id, set: set3.id, player: 0, action: 15, rotation: r8, rotationTurns: 0, rotationCount: 2, score_us: 21, score_them: 9, to: 1, stage: 1, server: Player(), player_in: nil, detail: "Out", setter: p7, order: 53.0, direction: ""))
        let st212 = Stat.createStat(stat: Stat(id: 212, match: m1.id, set: set3.id, player: 4, action: 99, rotation: r8, rotationTurns: 1, rotationCount: 3, score_us: 21, score_them: 9, to: 0, stage: 0, server: p4, player_in: 10, detail: "", setter: nil, order: 54.0, direction: ""))
        let st213 = Stat.createStat(stat: Stat(id: 213, match: m1.id, set: set3.id, player: 0, action: 98, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 22, score_them: 9, to: 0, stage: 0, server: p10, player_in: nil, detail: "", setter: nil, order: 55.0, direction: ""))
        let st214 = Stat.createStat(stat: Stat(id: 214, match: m1.id, set: set3.id, player: 0, action: 98, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 20, score_them: 9, to: 0, stage: 0, server: p10, player_in: nil, detail: "", setter: nil, order: 56.0, direction: ""))
        let st215 = Stat.createStat(stat: Stat(id: 215, match: m1.id, set: set3.id, player: 10, action: 41, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 20, score_them: 9, to: 0, stage: 0, server: p10, player_in: nil, detail: "", setter: p7, order: 57.0, direction: ""))
        let st216 = Stat.createStat(stat: Stat(id: 216, match: m1.id, set: set3.id, player: 12, action: 13, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 21, score_them: 9, to: 1, stage: 2, server: p10, player_in: nil, detail: "", setter: p7, order: 58.0, direction: ""))
        let st217 = Stat.createStat(stat: Stat(id: 217, match: m1.id, set: set3.id, player: 10, action: 8, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 22, score_them: 9, to: 1, stage: 0, server: p10, player_in: nil, detail: "", setter: p7, order: 59.0, direction: ""))
        let st218 = Stat.createStat(stat: Stat(id: 218, match: m1.id, set: set3.id, player: 10, action: 41, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 22, score_them: 9, to: 0, stage: 0, server: p10, player_in: nil, detail: "", setter: p7, order: 60.0, direction: ""))
        let st219 = Stat.createStat(stat: Stat(id: 219, match: m1.id, set: set3.id, player: 1, action: 9, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 23, score_them: 9, to: 1, stage: 2, server: p10, player_in: nil, detail: "", setter: p7, order: 61.0, direction: ""))
        let st220 = Stat.createStat(stat: Stat(id: 220, match: m1.id, set: set3.id, player: 10, action: 41, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 23, score_them: 9, to: 0, stage: 0, server: p10, player_in: nil, detail: "", setter: p7, order: 62.0, direction: ""))
        let st221 = Stat.createStat(stat: Stat(id: 221, match: m1.id, set: set3.id, player: 9, action: 21, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 23, score_them: 10, to: 2, stage: 2, server: p10, player_in: nil, detail: "", setter: p7, order: 63.0, direction: ""))
        let st222 = Stat.createStat(stat: Stat(id: 222, match: m1.id, set: set3.id, player: 10, action: 4, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 23, score_them: 10, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 64.0, direction: ""))
        let st223 = Stat.createStat(stat: Stat(id: 223, match: m1.id, set: set3.id, player: 0, action: 16, rotation: r9, rotationTurns: 0, rotationCount: 3, score_us: 24, score_them: 10, to: 1, stage: 2, server: Player(), player_in: nil, detail: "Out", setter: p7, order: 65.0, direction: ""))
        let st224 = Stat.createStat(stat: Stat(id: 224, match: m1.id, set: set3.id, player: 1, action: 15, rotation: r9, rotationTurns: 1, rotationCount: 4, score_us: 24, score_them: 11, to: 2, stage: 0, server: p1, player_in: nil, detail: "Net", setter: p7, order: 66.0, direction: ""))
        let st225 = Stat.createStat(stat: Stat(id: 225, match: m1.id, set: set3.id, player: 9, action: 2, rotation: r9, rotationTurns: 1, rotationCount: 4, score_us: 24, score_them: 11, to: 0, stage: 1, server: Player(), player_in: nil, detail: "", setter: p7, order: 67.0, direction: ""))
        let st226 = Stat.createStat(stat: Stat(id: 226, match: m1.id, set: set3.id, player: 2, action: 6, rotation: r9, rotationTurns: 1, rotationCount: 4, score_us: 24, score_them: 11, to: 0, stage: 2, server: Player(), player_in: nil, detail: "", setter: p7, order: 68.0, direction: ""))
        let st227 = Stat.createStat(stat: Stat(id: 227, match: m1.id, set: set3.id, player: 0, action: 16, rotation: r9, rotationTurns: 1, rotationCount: 4, score_us: 25, score_them: 11, to: 1, stage: 2, server: Player(), player_in: nil, detail: "Out", setter: p7, order: 69.0, direction: ""))
    }
    
}
