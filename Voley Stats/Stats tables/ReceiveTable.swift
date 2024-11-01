import SwiftUI
struct ReceiveTable: View {
    let labels: [String] = ["player".trad(),"total", "++", "+", "-", "err", "mark".trad()]
    let actions: [Int]
    let players: [Player]
    let stats: [Stat]
    let historical: Bool
    var body: some View {
        VStack {
            HStack {
                ForEach(labels, id: \.self){label in
                    Text(label).bold().frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding(3)
            ForEach(players, id:\.id){player in
                let stat = stats.filter{s in return s.player == player.id && actions.contains(s.action)}
                let total = stat.count
                if total != 0 {
                    let pts = getTotals(stat: stat)
                    HStack {
                        Text("\(player.name)").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.3)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.2)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.1)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.0)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(String(format: "%.2f", pts.4))").frame(maxWidth: .infinity, alignment: .leading)
                        //                    Text("\((kills/stat.count)*100)")
                    }.foregroundColor(.white).padding(3)
                }
            }
            let stat = stats.filter{s in return s.player != 0 && actions.contains(s.action)}
            let total = stat.count
            if total != 0 {
                let pts = getTotals(stat: stat)
                HStack {
                    Text("total".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(pts.3)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(pts.2)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(pts.1)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(pts.0)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(String(format: "%.2f", pts.4))").frame(maxWidth: .infinity, alignment: .leading)
                    //                    Text("\((kills/stat.count)*100)")
                }.foregroundColor(.white).padding(3)
            }
        }
    }
    
    func getTotals(stat: [Stat])->(Int, Int, Int, Int, Float){
        let op = stat.filter{s in return s.action==1}.count
        let s1 = stat.filter{s in return s.action==2}.count
        let s2 = stat.filter{s in return s.action==3}.count
        let s3 = stat.filter{s in return s.action==4}.count
        let errors = stat.filter{s in return s.action==22}.count
        let total = stat.count
        let mk = total > 0 ? Float(op/2 + s1 + 2*s2 + 3*s3)/Float(total) : 0
        return (errors, s1, s2, s3, mk)
    }
}
