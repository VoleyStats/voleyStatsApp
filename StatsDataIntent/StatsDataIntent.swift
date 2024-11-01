//
//  StatsDataIntent.swift
//  StatsDataIntent
//
//  Created by Pau Hermosilla on 4/7/24.
//

import AppIntents

struct StatsDataIntent: AppIntent {
    static var title: LocalizedStringResource = "Get area stats"
    static var description: IntentDescription = IntentDescription("Obtain a JSON string with an array of labels and an array of labeled series of values.")
    
    @Parameter(title:"Team", description: "Wich team are the stats from")
    var team: TeamEntity
    @Parameter(title: "Area", description: "Choose the area from wich you want to retrive the stats")
    var area:StatsActionAreas
    
    
    func perform() async throws -> some ReturnsValue<String> {
        let area = ActionAreas(rawValue: Int(area.rawValue)!)!
        let dbTeam = Team.find(id: team.dbID)!
        var result = [
            "labels":[],
            "series":[]
        ]
        actionsToStat[area]!.forEach{serie in
            let stats = dbTeam.historicalStats(startDate: Calendar.current.date(byAdding: .month, value: -5, to: .now) ?? Date(), endDate: Calendar.current.date(byAdding: .month, value: -4, to: .now) ?? .now, actions: serie.value)
            result["series"]!.append([
                "label":serie.key,
                "values": stats.map{$0.1}
            ])
            result["labels"]! = stats.map{$0.0}
        }
        let jsonData = try JSONSerialization.data(withJSONObject: result, options: [])
        let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
        return .result(value:jsonString)
    }
}

struct GetTeamsIntent: AppIntent {
    static var title: LocalizedStringResource = "Get all teams"
    func perform() async throws -> some IntentResult & ReturnsValue<[TeamEntity]> {
        return .result(value: Team.all().map{TeamEntity(id: $0.id.description, dbID: $0.id, name: $0.name)})
    }
}

struct CreateMatchIntent: AppIntent {
    static var title: LocalizedStringResource = "Create new match"
//    static var description: IntentDescription = IntentDescription("")
    @Parameter(title:"Team", description: "Your team") var team: TeamEntity
    @Parameter(title: "Opponent", description: "Other team's name") var opponent:String
    @Parameter(title: "Location/Court", description: "Name of the match location & court number") var location:String
    @Parameter(title: "Home", description: "Set if your team is home or away") var home:Bool
    @Parameter(title: "League", description: "Set if the match belongs to the league or not") var league:Bool
    @Parameter(title: "Sets", description: "Maximum number of sets the teams can play") var n_sets:Int
    @Parameter(title: "Players", description: "Number of players that must be in the court") var n_players:Int
    @Parameter(title: "Date", description: "Date of the match") var date:Date
    func perform() async throws -> some IntentResult {
        Match.createMatch(match: Match(opponent: opponent, date: date, location: location, home: home, n_sets: n_sets, n_players: n_players, team: team.dbID, league: league, code: "", live: false, pass: true, tournament: nil, id: nil))
        return .result()
    }
}

struct GetMatchesIntent: AppIntent {
    static var title: LocalizedStringResource = "Get matches"
    static var description: IntentDescription = IntentDescription("Obtain all the matches of a specific team.")
    @Parameter(title:"Team", description: "") var team: TeamEntity
    func perform() async throws -> some IntentResult & ReturnsValue<[MatchEntity]> {
        let dbTeam = Team.find(id: team.dbID)!
        return .result(value: dbTeam.matches().map{MatchEntity(id: $0.id.description, dbID: $0.id, name: $0.opponent, date: $0.date, teamId: $0.team)})
    }
}

struct GetMatchReportIntent: AppIntent {
    static var title: LocalizedStringResource = "Get match report"
    static var description: IntentDescription = IntentDescription("Get a basic report of the stats of a match to save it in your Files app.")
//    @Parameter(title:"Team", description: "") var team: TeamEntity
    @Parameter(title:"Match", description: "") var match: MatchEntity
    func perform() async throws -> some IntentResult & ReturnsValue<URL> {
        let dbTeam = Team.find(id: match.teamId)!
        let dbMatch = Match.find(id: match.dbID)!
        let report = Report(team: dbTeam, match: dbMatch).generate()
        return .result(value: report)
    }
}

struct GetLiveLinkIntent: AppIntent {
    static var title: LocalizedStringResource = "Get live stats link"
    static var description: IntentDescription = IntentDescription("Get the link to a match live stats. If the match is not set to be live, you can turn it on also here.")

    @Parameter(title:"Match", description: "") var match: MatchEntity
    @Parameter(title:"Turn live", description: "Turn on match live stats if are turned off") var turnLive:Bool
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let dbMatch = Match.find(id: match.dbID)!
        if !dbMatch.live && turnLive{
            dbMatch.shareLive()
        }
        return .result(value: "https://voleystats-live.vercel.app/\(dbMatch.code)")
    }
}


