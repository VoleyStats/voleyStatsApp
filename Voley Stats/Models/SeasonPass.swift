//
//  SeasonPass.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 2/11/24.
//
import Foundation
import SQLite

class SeasonPass{
    typealias Expression = SQLite.Expression
    var id: Int = 0
    var active: Bool
    var endDate: Date
    init(){
        do {
            guard let database = DB.shared.db else {
                self.active = false
                self.endDate = .distantPast
                return
            }
            guard let seasonPass = try database.pluck(Table("season_pass")) else {
                self.active = false
                self.endDate = .distantPast
                return
            }
            self.active = seasonPass[Expression<Bool>("pass")]
            self.endDate = seasonPass[Expression<Date>("date_end")]
            self.id = seasonPass[Expression<Int>("id")]
        }catch{
            self.active = false
            self.endDate = .distantPast
        }
    }
    
    func add(date: Date) -> Bool{
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            self.active = true
            self.endDate = date.addingTimeInterval(60 * 60 * 24 * 365)
            let update = Table("season_pass").filter(self.id == Expression<Int>("id")).update([
                Expression<Bool>("pass") <- self.active,
                Expression<Date>("date_end") <- self.endDate
            ])
            if try database.run(update) > 0 {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func reset() -> Bool{
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            self.active = false
            self.endDate = .distantPast
            let update = Table("season_pass").filter(self.id == Expression<Int>("id")).update([
                Expression<Bool>("pass") <- self.active,
                Expression<Date>("date_end") <- self.endDate
            ])
            if try database.run(update) > 0 {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
}
