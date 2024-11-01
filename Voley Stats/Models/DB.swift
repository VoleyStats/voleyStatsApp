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
                    let uv = self.db?.userVersion as! Int32
//                    print(uv)
                    if uv < version && uv > 0{
                        self.migrate(userVersion: uv)
                    }else if uv == 0{
                        self.migrate(userVersion: uv)
                    }
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
//        csvString = csvString.appending(":\n id,name,description,area,type\n")
//        for exercise in Exercise.all(){
//            if (exercise.id > 2){
//                csvString = csvString.appending("\(exercise.id),\(exercise.name),\"\(exercise.description)\",\(exercise.area),\(exercise.type)\n")
//            }
//        }
//        csvString = csvString.appending(":\n id,player,exercise,area,comment,date\n")
//        for improve in Improve.all(){
//            
//            csvString = csvString.appending("\(improve.id),\(improve.player.id),\(improve.exercise.id),\(improve.area),\"\(improve.comment)\",\(improve.getDateString())\n")
//            
//        }
//        csvString = csvString.appending(":\n id,player,team_related,team_name,from,to,difficulty,action,rotation,date,comment\n")
//        for scout in Scout.all(){
//            csvString = csvString.appending("\(scout.id),\(scout.player),\(scout.teamRelated.id),\(scout.teamName),\(scout.from),\(scout.to),\(scout.difficulty),\(scout.action),\"\(scout.rotation.description)\",\(scout.getDateString()),\"\(scout.comment)\"\n")
//        }
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
//        csvString = csvString.appending(":id,name,description,area,type;")
//        for exercise in Exercise.all(){
//            if (exercise.id > 2){
//                csvString = csvString.appending("\(exercise.id),\(exercise.name),\"\(exercise.description)\",\(exercise.area),\(exercise.type);")
//            }
//        }
//        csvString = csvString.appending(":id,player,exercise,area,comment,date;")
//        for improve in Improve.all(){
//            
//            csvString = csvString.appending("\(improve.id),\(improve.player.id),\(improve.exercise.id),\(improve.area),\"\(improve.comment)\",\(improve.getDateString());")
//            
//        }
//        csvString = csvString.appending(":id,player,team_related,team_name,from,to,difficulty,action,rotation,date,comment;")
//        for scout in Scout.all(){
//            csvString = csvString.appending("\(scout.id),\(scout.player),\(scout.teamRelated.id),\(scout.teamName),\(scout.from),\(scout.to),\(scout.difficulty),\(scout.action),\"\(scout.rotation.description)\",\(scout.getDateString()),\"\(scout.comment)\";")
//        }
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
    
}
