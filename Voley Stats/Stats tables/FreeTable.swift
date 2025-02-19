import SwiftUI
struct FreeTable: View {
    let labels: [String] = ["player".trad(),"total", "++", "+", "-", "err", "%"]
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
                let s1 = stat.filter{s in return s.action==35}.count
                let s2 = stat.filter{s in return s.action==36}.count
                let s3 = stat.filter{s in return s.action==37}.count
                let errors = stat.filter{s in return s.action==25}.count
                let total = stat.count
                if total != 0 {
                    HStack {
                        Text("\(player.name)").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(s3)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(s2)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(s1)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total == 0 ? "0" : String(format: "%.2f", Float(s1 + 2*s2 + 3*s3)/Float(total)))").frame(maxWidth: .infinity, alignment: .leading)
                        //                    Text("\((kills/stat.count)*100)")
                    }.foregroundColor(.white).padding(3)
                }
            }
            let stat = stats.filter{s in return s.player != 0 && actions.contains(s.action)}
            let s1 = stat.filter{s in return s.action==35}.count
            let s2 = stat.filter{s in return s.action==36}.count
            let s3 = stat.filter{s in return s.action==37}.count
            let errors = stat.filter{s in return s.action==25}.count
            let total = stat.count
            if total != 0 {
                HStack {
                    Text("total".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(s3)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(s2)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(s1)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(total == 0 ? "0" : String(format: "%.2f", Float(s1 + 2*s2 + 3*s3)/Float(total)))").frame(maxWidth: .infinity, alignment: .leading)
                    //                    Text("\((kills/stat.count)*100)")
                }.foregroundColor(.white).padding(3)
            }

        }
    }
}
