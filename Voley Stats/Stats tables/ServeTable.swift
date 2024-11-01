import SwiftUI

struct ServeTable: View {
    let labels: [String] = ["total", "aces", "++", "+", "-", "err", "mark".trad(), "P-G"]
    let actions: [Int]
    let players: [Player]
    let stats: [Stat]
    let historical: Bool
    @State var isChart: Bool = true
    var body: some View {
        VStack{
//            Toggle(isOn: $isChart, label: {
//                Text("See chart")
//            })
            if isChart {
                ChartView()
            }
        }
        
    }
    @ViewBuilder
    func ChartView() -> some View {
        VStack {
            HStack {
                ForEach(["player".trad()]+labels, id: \.self){label in
                    Text(label).bold().frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding(3)
            ForEach(players, id:\.id){player in
                let stat = stats.filter{s in return s.server == player && s.stage != Stages.K1.rawValue && actionsByType["serve"]!.contains(s.action)}
                let total = stats.filter{s in return s.server == player && s.stage != Stages.K1.rawValue && s.to != 0}.count
                let won = getWon(stat:stats, player:player)
                let pts = getTotals(stat: stat)
                if total != 0 {
                    HStack{
                        Text("\(player.name)").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.3)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.2)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.1)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.0)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(getErrors(stat:stat))").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(String(format: "%.2f", pts.4))").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(won)").frame(maxWidth: .infinity, alignment: .leading)
//                        Text("\(total == 0 ? 0 : (Float(won)/Float(total))*100)").frame(maxWidth: .infinity, alignment: .leading)
                    }.foregroundColor(.white).padding(3)
                }
            }
            let stat = stats.filter{s in return s.server.id != 0 && s.stage != Stages.K1.rawValue && actionsByType["serve"]!.contains(s.action)}
            let total = stats.filter{s in return s.server.id != 0 && s.stage != Stages.K1.rawValue && s.to != 0}.count
            let won = getWon(stat:stats)
            let pts = getTotals(stat: stat)
            if total != 0 {
                HStack{
                    Text("total".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(pts.3)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(pts.2)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(pts.1)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(pts.0)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(getErrors(stat:stat))").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(String(format: "%.2f", pts.4))").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(won)").frame(maxWidth: .infinity, alignment: .leading)
//                        Text("\(total == 0 ? 0 : (Float(won)/Float(total))*100)").frame(maxWidth: .infinity, alignment: .leading)
                }.foregroundColor(.white).padding(3)
            }
            
        }
    }
    func getAces(stat: [Stat]) -> Int{
        return stat.filter{s in return s.action==8}.count
    }
    func getErrors(stat: [Stat]) -> Int{
        return stat.filter{s in return [15, 32].contains(s.action)}.count
    }
    func getWon(stat: [Stat], player: Player? = nil) -> Int{
        if player != nil{
            return stats.filter{s in return s.server == player! && Action.find(id: s.action)?.type ?? 0 == 1}.count
        } else {
            return stats.filter{s in return s.server.id != 0 && Action.find(id: s.action)?.type ?? 0 == 1}.count
        }
    }
    func getTotals(stat: [Stat])->(Int, Int, Int, Int, Float){
        let s2 = stat.filter{s in return s.action==39}.count
        let s1 = stat.filter{s in return s.action==40}.count
        let op = stat.filter{s in return s.action==41}.count
        let s3 = stat.filter{s in return s.action==8}.count
        let total = stat.count
        let mk = total > 0 ? Float(op/2 + s1 + 2*s2 + 3*s3)/Float(total) : 0
        return (op, s1, s2, s3, mk)
    }
}
