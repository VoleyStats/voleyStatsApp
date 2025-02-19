import SQLite
import SwiftUI

class Tournament: Model {
    typealias Expression = SQLite.Expression
//    var id:Int;
    var name:String
    var team:Team
    var location:String
    var startDate:Date
    var endDate:Date
    var pass: Bool
//    static func ==(lhs: Tournament, rhs: Tournament) -> Bool {
//        return lhs.id == rhs.id
//    }
    init(name:String, team:Team, location:String, startDate: Date, endDate:Date, pass:Bool){
        self.name=name
        self.team=team
        self.location=location
        self.startDate=startDate
        self.endDate=endDate
        self.pass = pass
        super.init(id: 0)
    }
    
    init(id:Int, name:String, team:Team, location:String, startDate: Date, endDate:Date, pass:Bool){
        self.name=name
        self.team=team
        self.location=location
        self.startDate=startDate
        self.endDate=endDate
        self.pass = pass
        super.init(id: id)
    }
    
    override var description : String {
        return self.name
    }
    
    var description : String {
        return self.name
    }
    
    static func create(tournament: Tournament)->Tournament?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if tournament.id != 0{
                try database.run(Table("tournament").insert(
                    Expression<String>("name") <- tournament.name,
                    Expression<Int>("team") <- tournament.team.id,
                    Expression<Int>("id") <- tournament.id,
                    Expression<String>("location") <- tournament.location,
                    Expression<Date>("date_start") <- tournament.startDate,
                    Expression<Date>("date_end") <- tournament.endDate,
                    Expression<Bool>("pass") <- tournament.pass
                ))
            }else{
                let id = try database.run(Table("tournament").insert(
                    Expression<String>("name") <- tournament.name,
                    Expression<Int>("team") <- tournament.team.id,
                    Expression<String>("location") <- tournament.location,
                    Expression<Date>("date_start") <- tournament.startDate,
                    Expression<Date>("date_end") <- tournament.endDate,
                    Expression<Bool>("pass") <- tournament.pass
                ))
                tournament.id = Int(id)
            }
//            DB.saveToFirestore(collection: "tournaments", object: tournament)
            return tournament
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
            let update = Table("tournament").filter(self.id == Expression<Int>("id")).update([
                Expression<String>("name") <- self.name,
                Expression<Int>("team") <- self.team.id,
                Expression<String>("location") <- self.location,
                Expression<Date>("date_start") <- self.startDate,
                Expression<Date>("date_end") <- self.endDate,
                Expression<Bool>("pass") <- self.pass
            ])
            if try database.run(update) > 0 {
//                DB.saveToFirestore(collection: "tournaments", object: self)
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
            self.matches().forEach({$0.delete()})
            let delete = Table("tournament").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
//            DB.deleteOnFirestore(collection: "tournaments", object: self)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    static func all() -> [Tournament]{
        var tournaments: [Tournament] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for tournament in try database.prepare(Table("tournament")) {
                tournaments.append(Tournament(
                    id: tournament[Expression<Int>("id")],
                    name: tournament[Expression<String>("name")],
                    team: Team.find(id: tournament[Expression<Int>("team")])!,
                    location: tournament[Expression<String>("location")],
                    startDate: tournament[Expression<Date>("date_start")],
                    endDate: tournament[Expression<Date>("date_end")],
                    pass: tournament[Expression<Bool>("pass")]
                ))
            }
            return tournaments
        } catch {
            print(error)
            return []
        }
    }
    static func find(id: Int) -> Tournament?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let tournament = try database.pluck(Table("tournament").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Tournament(
                id: tournament[Expression<Int>("id")],
                name: tournament[Expression<String>("name")],
                team: Team.find(id: tournament[Expression<Int>("team")])!,
                location: tournament[Expression<String>("location")],
                startDate: tournament[Expression<Date>("date_start")],
                endDate: tournament[Expression<Date>("date_end")],
                pass: tournament[Expression<Bool>("pass")])
        } catch {
            print(error)
            return nil
        }
    }
    
    func addPass(){
        self.pass = true
        if self.update(){
            self.matches().forEach{match in
                match.pass = true
                match.update()
            }
        }
    }
    
    func getStartDateString()->String{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: self.startDate)
    }
    func getEndDateString()->String{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: self.endDate)
    }
    func matches(interval: Int? = nil) -> [Match]{
        var matches: [Match] = []
        do {
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd HH:mm"
            
            var query = Table("match").filter(Expression<Int>("tournament")==self.id)
            if interval != nil {
                let ini = Calendar.current.date(byAdding: .month, value: -interval!, to: Date()) ?? Date()
                query = query.filter(ini...Date() ~= Expression<Date>("date"))
            }
            
            for match in try database.prepare(query) {
                matches.append(Match(
                    opponent: match[Expression<String>("opponent")],
                    date: match[Expression<Date>("date")],
                    location: match[Expression<String>("location")],
                    home: match[Expression<Bool>("home")],
                    n_sets: match[Expression<Int>("n_sets")],
                    n_players: match[Expression<Int>("n_players")],
                    team: match[Expression<Int>("team")],
                    league: match[Expression<Bool>("league")],
                    code: match[Expression<String>("code")],
                    live: match[Expression<Bool>("live")],
                    pass: match[Expression<Bool>("pass")],
                    tournament: Tournament.find(id: match[Expression<Int>("tournament")]),
                    id: match[Expression<Int>("id")]))
            }
            return matches.sorted{ a, b in a.date > b.date}
        }catch{
            print(error)
            return []
        }
    }
    static func truncate(){
        do{
            guard let database = DB.shared.db else {
                return
            }
            try database.run(Table("tournament").delete())
        }catch{
            print("error truncating tournament")
            return
        }
    }
    
    override func toJSON()->Dictionary<String,Any>{
        return [
            "id":self.id,
            "name":self.name,
            "team":self.team.id,
            "location":self.location,
            "startDate":self.startDate.timeIntervalSince1970,
            "endDate":self.endDate.timeIntervalSince1970,
            
        ]
    }
}


