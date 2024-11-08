//
//  Report.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 26/2/24.
//

import Foundation
import SwiftUI

enum ReportSections: String, CaseIterable{
    case pointLog = "point.log"
    case attackDetail = "attack.detail"
    case serveDetail = "serve.detail"
    case receiveDetail = "receive.detail"
    case matchCompare = "match.compare"
    case errorTree = "error.tree"
    case hiddenCount = "hidden.count"
    case setDetail = "sets.detail"
    case playerMeasures = "player.measures"
    case feedback = "feedback"
    case areaTotals = "totals.by.area"
}

class Report: PDF{
    var sections:[ReportSections]=[]
    
    init(a: String = ""){
        super.init()
        self.testReport()
    }
    
    init(team: Team, match: Match, sections: [ReportSections]=[]) {
        super.init()
        self.sections = sections
        self.matchReport(team: team, match: match)
    }
    init(team: Team, matches: [Match], sections: [ReportSections]=[]) {
        super.init()
        self.sections = sections
        self.multiMatchReport(team: team, matches: matches)
    }
    
    init(player: Player, data:Dictionary<String,Dictionary<String,Float>>, startDate: Date, endDate: Date, feedback: String, sections: [ReportSections]=[]) {
        super.init()
        self.sections = sections
        self.playerReport(player: player, data: data, startDate: startDate, endDate: endDate, feedBack: feedback)
    }
    
    func sections(sections: [ReportSections]){
        self.sections = sections
    }
    
    func matchReport(team: Team, match: Match, showSections: Bool = true) -> Report{
        //215, 217, 216
        if  showSections{
            self.title = "\(team.name)-\(match.opponent)"
        }
        var x = 27
        var y = header(info: "match.report".trad())
        let result = match.result()
        addText(x: x, y: y+10, text: "\(result.0)", font: self.fonts["title"]!, color:Colors.blue, width: 25, alignment: .left)
        addText(x: x+25, y: y+10, text: team.name.uppercased(), font: self.fonts["title"]!, color:UIColor.black, width: Int(self.pageWidth/2), alignment: .left)
        
        y+=40
        addText(x: x, y: y+10, text: "\(result.1)", font: self.fonts["title"]!, color:Colors.blue, width: 25, alignment: .left)
        addText(x: x+25, y: y+10, text: match.opponent.uppercased(), font: self.fonts["title"]!, color:UIColor.black, width: Int(self.pageWidth/2), alignment: .left)
        
        y-=40
        y += 10
        x=Int(self.pageWidth)-215
        //summary section
        let w = 195//("result".trad().count + 3)*11
        addShape(x: x, y: y, width: 30, height: 17+(match.n_sets)*17, shape: "rect", color: UIColor.black, fill: false, radius: 1)
        addText(x: x, y: y, text: "Set", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 30, alignment: .center)
        x+=30
        addShape(x: x, y: y, width: 110, height: 17+(match.n_sets)*17, shape: "rect", color: UIColor.black, fill: false, radius: 1)
        addText(x: x, y: y, text: "partial.scores".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 110, alignment: .center)
        x+=110
        addShape(x: x, y: y, width: 60, height: 17+(match.n_sets)*17, shape: "rect", color: UIColor.black, fill: false, radius: 1)
        addText(x: x, y: y, text: "result".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 60, alignment: .center)
        y+=20
        match.sets().forEach{set in
            x=Int(self.pageWidth)-215
            let s = set.stats()
            let eight = s.filter{s in return s.score_us == 8 || s.score_them == 8}.first
            let sixteen = s.filter{s in return s.score_us == 16 || s.score_them == 16}.first
            let twentyone = s.filter{s in return s.score_us == 21 || s.score_them == 21}.first
            addText(x: x, y: y, text: "\(set.number)", font: self.fonts["body"]!, color:UIColor.black, width: 30, alignment: .center)
            x+=30
            addText(x: x, y: y, text: eight != nil ? "\(eight!.score_us)-\(eight!.score_them)" : ".", font: self.fonts["body"]!, color:UIColor.black, width: 30, alignment: .center)
            x+=30
            addText(x: x, y: y, text: sixteen != nil ? "\(sixteen!.score_us)-\(sixteen!.score_them)" : ".", font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=40
            addText(x: x, y: y, text: twentyone != nil ? "\(twentyone!.score_us)-\(twentyone!.score_them)" : ".", font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=40
            addText(x: x, y: y, text: "\(set.score_us)-\(set.score_them)", font: self.fonts["body"]!, color:UIColor.black, width: 60, alignment: .center)
            y+=15
        }
        y+=20
        //players section
        
        x=220
//
        addText(x: x, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addText(x: x, y: y, text: "serve".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addText(x: x, y: y, text: "receive".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addText(x: x, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        y+=20
        var yPlay = y
        x=15
        addText(x: x+5, y: y, text: "player".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 160, alignment: .left)
        
        x+=160
        //PS%
        addText(x: x, y: y, text: "gp".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        
        x+=45
        //ATTACK
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        //SERVE
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        //RECEIVE
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
        x+=20
        addText(x: x, y: y, text: "mark".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        x+=45
        
        //BLOCK
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        
        y+=22
        x=15
        var stats = match.stats()
//        if !self.sections.contains(.digCount){
//            stats = stats.filter{s in return !actionsByType["dig"]!.contains(s.action)}
//        }
        var players = 2
        team.players().forEach{player in
            let ps = stats.filter{s in return s.player == player.id}
            let serves = stats.filter{s in return s.server == player && s.stage != 1 && s.to != 0}
            if ps.count > 0 || serves.count > 0{
                players += 1
                addText(x: x+5, y: y, text: "\(player.number)", font: self.fonts["body"]!, color:UIColor.black, width: 20, alignment: .left)
                addText(x: x+25, y: y, text: "\(player.name)", font: self.fonts["body"]!, color:UIColor.black, width: 140, alignment: .left)
                x+=160
                //G-P
                var gp = 0
//                if self.sections.contains(.hiddenCount){
//                    gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
//                }else{
//                    let g = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
//                    let p = ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
//                    print(g, p)
//                    gp = g.count - p.count
//                }
                //POINT SCORING EFFICIENCY
                let t = ps.filter{actionsByType["attack"]!.contains($0.action) || actionsByType["block"]!.contains($0.action) || actionsByType["serve"]!.contains($0.action) || actionsByType["downhit"]!.contains($0.action) || $0.action == 24 || $0.action == 25}
                gp = t.filter{[8, 9, 10, 11, 12, 13].contains($0.action)}.count -  t.filter{[15, 16, 17, 18, 19, 24, 25].contains($0.action)}.count
                
                addText(x: x, y: y, text: gp == 0 ? "." : "\(String(format: "%.2f", Float(gp) / Float(t.count)))", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
                x+=45
                
                // attack
                let atk = ps.filter{s in return actionsByType["attack"]!.contains(s.action)}
                addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
                x+=40
                // kills
                let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
                addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                // Attack errors
                let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
                addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                
                //serves
                addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
                x+=40
                // aces
                let aces = serves.filter{s in return s.action==8}.count
                addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                // serve errors
                let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
                addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                
                // receive
                let rcv = ps.filter{s in return actionsByType["receive"]!.contains(s.action)}
                addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                // receive error
                let Rerr = rcv.filter{s in return s.action==22}.count
                addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
                x+=20
                // receive mark
                let op = rcv.filter{s in return s.action==1}.count
                let s1 = rcv.filter{s in return s.action==2}.count
                let s2 = rcv.filter{s in return s.action==3}.count
                let s3 = rcv.filter{s in return s.action==4}.count
                let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
                addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
                x+=45
                
                // blocks
                let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
                let blkPts = ps.filter{s in return s.action==13}.count
                let bErr = ps.filter{s in return s.action==20}.count
                addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
                x+=40
                addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x = 15
                y+=20
            }
        }
        y+=10
        let h = players > 10 ? (players * 18)+10 : (players * 18)
        x=250
//        addShape(x: x-75, y: yPlay, width: 50, height: h, shape: "rect", color: UIColor.black, fill: false)
//        addShape(x: x-75, y: yPlay, width: 145, height: h, shape: "rect", color: UIColor.black, fill: false)
//        x+=100
//        addShape(x: x-30, y: yPlay, width: 105, height: h, shape: "rect", color: UIColor.black, fill: false)
//        x+=100
//        addShape(x: x-25, y: yPlay, width: 85, height: h, shape: "rect", color: UIColor.black, fill: false)
//        x+=60
//        addShape(x: x, y: yPlay, width: 75, height: h, shape: "rect", color: UIColor.black, fill: false)
//        yPlay+=22
        x=15
        addShape(x: x, y: yPlay, width: 160, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=160
        addShape(x: x, y: yPlay, width: 45, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=45
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
//        addShape(x: x-10, y: yPlay-5, width: 568, height: h-17, shape: "rect", color: UIColor.black, fill: false)
        x=65
        var receiveDetail:[BarElement]=[]
        var serveDetail:[BarElement]=[]
        var attackDetail:[BarElement]=[]
        match.sets().forEach{set in
            players += 1
            let ps = stats.filter{s in return s.set == set.id && s.player != 0}
            let serves = stats.filter{s in return s.set == set.id && s.server.id != 0 && s.stage != 1 && s.to != 0}
            addText(x: x, y: y, text: "\("totals".trad()) set \(set.number)", font: self.fonts["bodyBold"]!, color:UIColor.black)
            x+=110
            var gp = 0
//            if self.sections.contains(.hiddenCount){
//                gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
//            }else{
//                gp = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count - ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count
//            }
            //POINT SCORING EFFICIENCY
            let t = ps.filter{actionsByType["attack"]!.contains($0.action) || actionsByType["block"]!.contains($0.action) || actionsByType["serve"]!.contains($0.action) || actionsByType["downhit"]!.contains($0.action) || $0.action == 24 || $0.action == 25}
            gp = t.filter{[8, 9, 10, 11, 12, 13].contains($0.action)}.count -  t.filter{[15, 16, 17, 18, 19, 24, 25].contains($0.action)}.count
            
            addText(x: x, y: y, text: gp == 0 ? "." : "\(String(format: "%.2f", Float(gp) / Float(t.count)))", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
            x+=45
            
            // attack
            let atk = ps.filter{s in return actionsByType["attack"]!.contains(s.action)}
            addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=40
            // kills
            let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}
            addText(x: x, y: y, text: kills.count == 0 ? "." : "\(kills.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
            x+=25
            // Attack errors
            let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}
            addText(x: x, y: y, text: Aerr.count == 0 ? "." : "\(Aerr.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
            x+=25
            
            //serves
            addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=40
            // aces
            let aces = serves.filter{s in return s.action==8}.count
            addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
            x+=25
            // serve errors
            let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
            addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
            x+=25
            
            // receive
            let rcv = ps.filter{s in return actionsByType["receive"]!.contains(s.action)}
            addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
            x+=25
            // receive error
            let Rerr = rcv.filter{s in return s.action==22}.count
            addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
            x+=20
            // receive mark
            let op = rcv.filter{s in return s.action==1}.count
            let s1 = rcv.filter{s in return s.action==2}.count
            let s2 = rcv.filter{s in return s.action==3}.count
            let s3 = rcv.filter{s in return s.action==4}.count
            let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
            addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
            x+=45
            
            // blocks
            let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
            let blkPts = ps.filter{s in return s.action==13}.count
            let bErr = ps.filter{s in return s.action==20}.count
            addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=40
            addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
            x+=25
            addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
            y+=20
            x=65
            
            if !ps.isEmpty {
                receiveDetail.append(BarElement(value: rcv.count, color: Colors.gray, group: "Set \(set.number)", label: "total".trad()))
                receiveDetail.append(BarElement(value: s3, color: Colors.green, group: "Set \(set.number)", label: "#"))
                receiveDetail.append(BarElement(value: s2, color: Colors.yellow, group: "Set \(set.number)", label: "+"))
                receiveDetail.append(BarElement(value: s1, color: Colors.orange, group: "Set \(set.number)", label: "-"))
                receiveDetail.append(BarElement(value: Rerr, color: Colors.red, group: "Set \(set.number)", label: "error".trad()))
                
                attackDetail.append(BarElement(value: atk.count, color: Colors.gray, group: "Set \(set.number)", label: "total".trad()))
                attackDetail.append(BarElement(value: kills.filter{$0.action==9}.count, color: Colors.green, group: "Set \(set.number)", label: "kills".trad()))
                attackDetail.append(BarElement(value: kills.filter{$0.action==10}.count, color: Colors.green2, group: "Set \(set.number)", label: "tip".trad()))
                attackDetail.append(BarElement(value: kills.filter{$0.action==11}.count, color: Colors.green3, group: "Set \(set.number)", label: "blockout".trad()))
                attackDetail.append(BarElement(value: Aerr.filter{$0.detail == "Blocked"}.count, color: Colors.yellow, group: "Set \(set.number)", label: "blocked".trad()))
                attackDetail.append(BarElement(value: Aerr.filter{$0.detail == "Out"}.count, color: Colors.orange, group: "Set \(set.number)", label: "out".trad()))
                attackDetail.append(BarElement(value: Aerr.filter{$0.detail == "Net"}.count, color: Colors.red, group: "Set \(set.number)", label: "net".trad()))
                
                serveDetail.append(BarElement(value: serves.count, color: Colors.gray, group: "Set \(set.number)", label: "total".trad()))
                serveDetail.append(BarElement(value: aces, color: Colors.green, group: "Set \(set.number)", label: "ace".trad()))
                serveDetail.append(BarElement(value: serves.filter{s in return s.action==39 && s.server.id != 0}.count, color: Colors.yellow, group: "Set \(set.number)", label: "+".trad()))
                serveDetail.append(BarElement(value: serves.filter{s in return [40,41].contains(s.action) && s.server.id != 0}.count, color: Colors.orange, group: "Set \(set.number)", label: "-".trad()))
                serveDetail.append(BarElement(value: Serr, color: Colors.red, group: "Set \(set.number)", label: "error".trad()))
            
            }
        }
        addText(x: x, y: y, text: "\("match".trad()) \("totals".trad())", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=110
        let ps = stats.filter{s in return s.player != 0}
        let serves = stats.filter{s in return s.server.id != 0 && s.stage != 1 && s.to != 0}
        var gp = 0
//        if self.sections.contains(.hiddenCount){
//            gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
//        }else{
//            gp = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count - ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count
//        }
        //POINT SCORING EFFICIENCY
        let t = ps.filter{actionsByType["attack"]!.contains($0.action) || actionsByType["block"]!.contains($0.action) || actionsByType["serve"]!.contains($0.action) || actionsByType["downhit"]!.contains($0.action) || $0.action == 24 || $0.action == 25}
        gp = t.filter{[8, 9, 10, 11, 12, 13].contains($0.action)}.count -  t.filter{[15, 16, 17, 18, 19, 24, 25].contains($0.action)}.count
        
        addText(x: x, y: y, text: gp == 0 ? "." : "\(String(format: "%.2f", Float(gp) / Float(t.count)))", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        x+=45
        
        // attack
        let atk = ps.filter{s in return actionsByType["attack"]!.contains(s.action)}
        addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        // kills
        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
        addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        // Attack errors
        let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}
        addText(x: x, y: y, text: Aerr.count == 0 ? "." : "\(Aerr.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        //serves
        addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        // aces
        let aces = serves.filter{s in return s.action==8}.count
        addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        // serve errors
        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
        addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        // receive
        let rcv = ps.filter{s in return actionsByType["receive"]!.contains(s.action)}
        addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        // receive error
        let Rerr = rcv.filter{s in return s.action==22}.count
        addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
        x+=20
        // receive mark
        let op = rcv.filter{s in return s.action==1}.count
        let s1 = rcv.filter{s in return s.action==2}.count
        let s2 = rcv.filter{s in return s.action==3}.count
        let s3 = rcv.filter{s in return s.action==4}.count
        let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
        addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        x+=45
        
        // blocks
        let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
        let blkPts = ps.filter{s in return s.action==13}.count
        let bErr = ps.filter{s in return s.action==20}.count
        addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x=27
        y+=45
        if showSections{
            if self.sections.contains(ReportSections.errorTree){
                let (errx, erry) = self.errorTree(match: match, startX: x, startY: y)
                if self.sections.contains(ReportSections.matchCompare){
                    x = errx + 40
                } else {
                    y = erry + 40
                }
            }
            if self.sections.contains(ReportSections.matchCompare){
                (_, y) = self.matchCompare(match: match, startX: x, startY: y)
                y += 40
            }
            
            if self.sections.contains(ReportSections.receiveDetail){
                if y + 250 > Int(self.pageHeight){
                    self.newPage()
                    
                    y = self.header(info: "match.report".trad()) + 5
                }
                x=50
                (_,y) = self.barChart(startX: x, startY: y, width: Int(self.pageWidth)-100, height: 250, title: "receive.detail".trad(), data: receiveDetail)
                y+=40
            }
            if self.sections.contains(ReportSections.serveDetail){
                if y + 250 > Int(self.pageHeight){
                    self.newPage()
                    
                    y = self.header(info: "match.report".trad()) + 5
                }
                x=50
                (_,y) = self.barChart(startX: x, startY: y, width: Int(self.pageWidth)-100, height: 250, title: "serve.detail".trad(), data: serveDetail)
                y+=40
            }
            if self.sections.contains(ReportSections.attackDetail){
                if y + 250 > Int(self.pageHeight){
                    self.newPage()
                    
                    y = self.header(info: "match.report".trad()) + 5
                }
                x=50
                (_,y) = self.barChart(startX: x, startY: y, width: Int(self.pageWidth)-100, height: 250, title: "attack.detail".trad(), data: attackDetail)
                y+=40
            }
            
            if self.sections.contains(.setDetail){
                match.sets().forEach{set in
                    if set.first_serve != 0{
                        self.newPage()
                        self.setReport(team: team, set: set)
                        if self.sections.contains(ReportSections.pointLog){
                            self.pointLog(set: set)
//                            y = 20000
                            //            self.newPage()
                            //            x=17
                            //            y = self.header(info: "match.report".trad()) + 5
                        }
                    }
                }
                //            self.newPage()
                //            x=17
                //            y = self.header(info: "match.report".trad()) + 5
                y = 20000
            }
            
            if self.sections.contains(ReportSections.pointLog) && !self.sections.contains(ReportSections.setDetail) {
                match.sets().forEach{set in
                    self.pointLog(set: set, single: true)
                }
                
                y = 20000
                //            self.newPage()
                //            x=17
                //            y = self.header(info: "match.report".trad()) + 5
            }
            
            

        }
        return self
    }
    
    func multiMatchReport(team: Team, matches: [Match]) -> Report{
        //215, 217, 216
        
        self.title = "\(team.name)_multimatch_\(Date().timeIntervalSince1970)"
        
        var x = 27
        var y = header(info: "multi.match.report".trad())
        addText(x: x, y: y+10, text: " \("report".trad()): \(team.name)".uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        y+=45
        let opps = matches.map{$0.opponent}.joined(separator: " - ")
        if (opps.count * 7) < Int(self.pageWidth - 50){
            addText(x: x, y: y, text: opps, font: self.fonts["body"]!, color:UIColor.black)
        }
        y+=30
        x=220
//
        addText(x: x, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addText(x: x, y: y, text: "serve".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addText(x: x, y: y, text: "receive".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addText(x: x, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        y+=20
        var yPlay = y
        x=15
        addText(x: x+5, y: y, text: "player".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 160, alignment: .left)
        
        x+=160
        //PS%
        addText(x: x, y: y, text: "gp".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        
        x+=45
        //ATTACK
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        //SERVE
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        //RECEIVE
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
        x+=20
        addText(x: x, y: y, text: "mark".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        x+=45
        
        //BLOCK
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        
        y+=22
        x=15
        let stats = matches.flatMap{$0.stats()}
        var players = 2
        team.players().forEach{player in
            let ps = stats.filter{s in return s.player == player.id}
            let serves = stats.filter{s in return s.server == player && s.stage != 1 && s.to != 0}
            if ps.count > 0 || serves.count > 0{
                players += 1
                addText(x: x+5, y: y, text: "\(player.number)", font: self.fonts["body"]!, color:UIColor.black, width: 20, alignment: .left)
                addText(x: x+25, y: y, text: "\(player.name)", font: self.fonts["body"]!, color:UIColor.black, width: 140, alignment: .left)
                x+=160
                //G-P
                var gp = 0
//                if self.sections.contains(.hiddenCount){
//                    gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
//                }else{
//                    let g = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
//                    let p = ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
//                    print(g, p)
//                    gp = g.count - p.count
//                }
                //POINT SCORING EFFICIENCY
                let t = ps.filter{actionsByType["attack"]!.contains($0.action) || actionsByType["block"]!.contains($0.action) || actionsByType["serve"]!.contains($0.action) || actionsByType["downhit"]!.contains($0.action) || $0.action == 24 || $0.action == 25}
                gp = t.filter{[8, 9, 10, 11, 12, 13].contains($0.action)}.count -  t.filter{[15, 16, 17, 18, 19, 24, 25].contains($0.action)}.count
                
                addText(x: x, y: y, text: gp == 0 ? "." : "\(String(format: "%.2f", Float(gp) / Float(t.count)))", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
                x+=45
                
                // attack
                let atk = ps.filter{s in return actionsByType["attack"]!.contains(s.action)}
                addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
                x+=40
                // kills
                let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
                addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                // Attack errors
                let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
                addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                
                //serves
                addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
                x+=40
                // aces
                let aces = serves.filter{s in return s.action==8}.count
                addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                // serve errors
                let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
                addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                
                // receive
                let rcv = ps.filter{s in return actionsByType["receive"]!.contains(s.action)}
                addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                // receive error
                let Rerr = rcv.filter{s in return s.action==22}.count
                addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
                x+=20
                // receive mark
                let op = rcv.filter{s in return s.action==1}.count
                let s1 = rcv.filter{s in return s.action==2}.count
                let s2 = rcv.filter{s in return s.action==3}.count
                let s3 = rcv.filter{s in return s.action==4}.count
                let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
                addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
                x+=45
                
                // blocks
                let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
                let blkPts = ps.filter{s in return s.action==13}.count
                let bErr = ps.filter{s in return s.action==20}.count
                addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
                x+=40
                addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x = 15
                y+=20
            }
        }
        y+=10
        let h = players > 10 ? (players * 18)+10 : (players * 18)
        x=250
//        addShape(x: x-75, y: yPlay, width: 50, height: h, shape: "rect", color: UIColor.black, fill: false)
//        addShape(x: x-75, y: yPlay, width: 145, height: h, shape: "rect", color: UIColor.black, fill: false)
//        x+=100
//        addShape(x: x-30, y: yPlay, width: 105, height: h, shape: "rect", color: UIColor.black, fill: false)
//        x+=100
//        addShape(x: x-25, y: yPlay, width: 85, height: h, shape: "rect", color: UIColor.black, fill: false)
//        x+=60
//        addShape(x: x, y: yPlay, width: 75, height: h, shape: "rect", color: UIColor.black, fill: false)
//        yPlay+=22
        x=15
        addShape(x: x, y: yPlay, width: 160, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=160
        addShape(x: x, y: yPlay, width: 45, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=45
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
//        addShape(x: x-10, y: yPlay-5, width: 568, height: h-17, shape: "rect", color: UIColor.black, fill: false)
        x=65
        addText(x: x, y: y, text: "\("totals".trad())", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=110
        let ps = stats.filter{s in return s.player != 0}
        let serves = stats.filter{s in return s.server.id != 0 && s.stage != 1 && s.to != 0}
        var gp = 0
//        if self.sections.contains(.hiddenCount){
//            gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
//        }else{
//            gp = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count - ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count
//        }
        //POINT SCORING EFFICIENCY
        let t = ps.filter{actionsByType["attack"]!.contains($0.action) || actionsByType["block"]!.contains($0.action) || actionsByType["serve"]!.contains($0.action) || actionsByType["downhit"]!.contains($0.action) || $0.action == 24 || $0.action == 25}
        gp = t.filter{[8, 9, 10, 11, 12, 13].contains($0.action)}.count -  t.filter{[15, 16, 17, 18, 19, 24, 25].contains($0.action)}.count
        
        addText(x: x, y: y, text: gp == 0 ? "." : "\(String(format: "%.2f", Float(gp) / Float(t.count)))", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        x+=45
        
        // attack
        let atk = ps.filter{s in return actionsByType["attack"]!.contains(s.action)}
        addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        // kills
        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
        addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        // Attack errors
        let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}
        addText(x: x, y: y, text: Aerr.count == 0 ? "." : "\(Aerr.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        //serves
        addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        // aces
        let aces = serves.filter{s in return s.action==8}.count
        addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        // serve errors
        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
        addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        // receive
        let rcv = ps.filter{s in return actionsByType["receive"]!.contains(s.action)}
        addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        // receive error
        let Rerr = rcv.filter{s in return s.action==22}.count
        addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
        x+=20
        // receive mark
        let op = rcv.filter{s in return s.action==1}.count
        let s1 = rcv.filter{s in return s.action==2}.count
        let s2 = rcv.filter{s in return s.action==3}.count
        let s3 = rcv.filter{s in return s.action==4}.count
        let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
        addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        x+=45
        
        // blocks
        let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
        let blkPts = ps.filter{s in return s.action==13}.count
        let bErr = ps.filter{s in return s.action==20}.count
        addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        //stats section
        x=27
        y+=45
        if self.sections.contains(.setDetail){
            matches.forEach{match in
                self.newPage()
                self.matchReport(team: team, match: match, showSections: false)
            }
            y = 20000;
        }
        
//        if self.sections.contains(ReportSections.receiveDetail){
//            if y + 250 > Int(self.pageHeight){
//                self.newPage()
//                
//                y = self.header(info: "match.report".trad()) + 5
//            }
//            x=50
//            (_,y) = self.barChart(startX: x, startY: y, width: Int(self.pageWidth)-100, height: 250, title: "receive.detail".trad(), data: receiveDetail)
//            y+=40
//        }
//        if self.sections.contains(ReportSections.serveDetail){
//            if y + 250 > Int(self.pageHeight){
//                self.newPage()
//                
//                y = self.header(info: "match.report".trad()) + 5
//            }
//            x=50
//            (_,y) = self.barChart(startX: x, startY: y, width: Int(self.pageWidth)-100, height: 250, title: "serve.detail".trad(), data: serveDetail)
//            y+=40
//        }
//        if self.sections.contains(ReportSections.attackDetail){
//            if y + 250 > Int(self.pageHeight){
//                self.newPage()
//                
//                y = self.header(info: "match.report".trad()) + 5
//            }
//            x=50
//            (_,y) = self.barChart(startX: x, startY: y, width: Int(self.pageWidth)-100, height: 250, title: "attack.detail".trad(), data: attackDetail)
//            y+=40
//        }
        return self
    }
    
    func setReport(team:Team, set: Set) -> Report{
        //215, 217, 216
        var x = 27
        var y = header(info: "match.report".trad())
        addText(x: x, y: y+10, text: "Set \(set.number)", font: PDFonts.title2, color:UIColor.black)
        y+=40
        //players section
        
        x=220
//
        addText(x: x, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addText(x: x, y: y, text: "serve".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addText(x: x, y: y, text: "receive".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addText(x: x, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 90, alignment: .center)
        addShape(x: x, y: y, width: 90, height: 20, shape: "rect", color: .black, fill: false, radius: 1)
        y+=20
        var yPlay = y
        x=15
        addText(x: x+5, y: y, text: "player".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 160, alignment: .left)
        
        x+=160
        //PS%
        addText(x: x, y: y, text: "gp".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        
        x+=45
        //ATTACK
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        //SERVE
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        //RECEIVE
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
        x+=20
        addText(x: x, y: y, text: "mark".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        x+=45
        
        //BLOCK
        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        
        y+=22
        x=15
        var stats = set.stats()
//        if !self.sections.contains(.digCount){
//            stats = stats.filter{s in return !actionsByType["dig"]!.contains(s.action)}
//        }
        var players = 2
        team.players().forEach{player in
            let ps = stats.filter{s in return s.player == player.id}
            let serves = stats.filter{s in return s.server == player && s.stage != 1 && s.to != 0}
            if ps.count > 0 || serves.count > 0{
                players += 1
                addText(x: x+5, y: y, text: "\(player.number)", font: self.fonts["body"]!, color:UIColor.black, width: 20, alignment: .left)
                addText(x: x+25, y: y, text: "\(player.name)", font: self.fonts["body"]!, color:UIColor.black, width: 140, alignment: .left)
                x+=160
                //G-P
                var gp = 0
//                if self.sections.contains(.hiddenCount){
//                    gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
//                }else{
//                    let g = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
//                    let p = ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
//                    print(g, p)
//                    gp = g.count - p.count
//                }
                //POINT SCORING EFFICIENCY
                let t = ps.filter{actionsByType["attack"]!.contains($0.action) || actionsByType["block"]!.contains($0.action) || actionsByType["serve"]!.contains($0.action) || actionsByType["downhit"]!.contains($0.action) || $0.action == 24 || $0.action == 25}
                gp = t.filter{[8, 9, 10, 11, 12, 13].contains($0.action)}.count -  t.filter{[15, 16, 17, 18, 19, 24, 25].contains($0.action)}.count
                
                addText(x: x, y: y, text: gp == 0 ? "." : "\(String(format: "%.2f", Float(gp) / Float(t.count)))", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
                x+=45
                
                // attack
                let atk = ps.filter{s in return actionsByType["attack"]!.contains(s.action)}
                addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
                x+=40
                // kills
                let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
                addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                // Attack errors
                let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
                addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                
                //serves
                addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
                x+=40
                // aces
                let aces = serves.filter{s in return s.action==8}.count
                addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                // serve errors
                let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
                addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                
                // receive
                let rcv = ps.filter{s in return actionsByType["receive"]!.contains(s.action)}
                addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                // receive error
                let Rerr = rcv.filter{s in return s.action==22}.count
                addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
                x+=20
                // receive mark
                let op = rcv.filter{s in return s.action==1}.count
                let s1 = rcv.filter{s in return s.action==2}.count
                let s2 = rcv.filter{s in return s.action==3}.count
                let s3 = rcv.filter{s in return s.action==4}.count
                let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
                addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
                x+=45
                
                // blocks
                let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
                let blkPts = ps.filter{s in return s.action==13}.count
                let bErr = ps.filter{s in return s.action==20}.count
                addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
                x+=40
                addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x+=25
                addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
                x = 15
                y+=20
            }
        }
        y+=10
        let h = players > 10 ? (players * 18)+10 : (players * 18)
//        x=250
        x=15
        addShape(x: x, y: yPlay, width: 160, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=160
        addShape(x: x, y: yPlay, width: 45, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=45
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x+=90
        addShape(x: x, y: yPlay, width: 90, height: h, shape: "rect", color: .black, fill: false, radius: 1)
        x=65
        addText(x: x, y: y, text: "\("totals".trad())", font: self.fonts["bodyBold"]!, color:UIColor.black)
        x+=110
        let ps = stats.filter{s in return s.player != 0}
        let serves = stats.filter{s in return s.server.id != 0 && s.stage != 1 && s.to != 0}
        var gp = 0
//        if self.sections.contains(.hiddenCount){
//            gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
//        }else{
//            gp = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count - ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count
//        }
        //POINT SCORING EFFICIENCY
        let t = ps.filter{actionsByType["attack"]!.contains($0.action) || actionsByType["block"]!.contains($0.action) || actionsByType["serve"]!.contains($0.action) || actionsByType["downhit"]!.contains($0.action) || $0.action == 24 || $0.action == 25}
        gp = t.filter{[8, 9, 10, 11, 12, 13].contains($0.action)}.count -  t.filter{[15, 16, 17, 18, 19, 24, 25].contains($0.action)}.count
        
        addText(x: x, y: y, text: gp == 0 ? "." : "\(String(format: "%.2f", Float(gp) / Float(t.count)))", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        x+=45
        
        // attack
        let atk = ps.filter{s in return actionsByType["attack"]!.contains(s.action)}
        addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        // kills
        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
        addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        // Attack errors
        let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}
        addText(x: x, y: y, text: Aerr.count == 0 ? "." : "\(Aerr.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        //serves
        addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        // aces
        let aces = serves.filter{s in return s.action==8}.count
        addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        // serve errors
        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
        addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        
        // receive
        let rcv = ps.filter{s in return actionsByType["receive"]!.contains(s.action)}
        addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        // receive error
        let Rerr = rcv.filter{s in return s.action==22}.count
        addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 20, alignment: .center)
        x+=20
        // receive mark
        let op = rcv.filter{s in return s.action==1}.count
        let s1 = rcv.filter{s in return s.action==2}.count
        let s2 = rcv.filter{s in return s.action==3}.count
        let s3 = rcv.filter{s in return s.action==4}.count
        let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
        addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black, width: 45, alignment: .center)
        x+=45
        
        // blocks
        let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
        let blkPts = ps.filter{s in return s.action==13}.count
        let bErr = ps.filter{s in return s.action==20}.count
        addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 40, alignment: .center)
        x+=40
        addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)
        x+=25
        addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black, width: 25, alignment: .center)

        return self
    }
    
    func playerReport(player:Player, data: Dictionary<String,Dictionary<String,Float>>, startDate: Date, endDate: Date, feedBack: String, reportInfo:Bool=true) -> PDF{
        self.title = "\(player.name)_report_\(Date().timeIntervalSince1970)"
//        let stats = player.stats()
        let measures = player.actualMeasures()
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        var x = 27
        var y = header(info: "player.report".trad())
        addText(x: x, y: y+10, text: player.name.uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        
        y+=55
        var width = Int(self.pageWidth)-40
        if reportInfo{
            addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: self.colors["gray"]!.withAlphaComponent(0.3), fill: true)
            y+=15
            x+=15
            addShape(x: x, y: y, width: 10, height: 10, shape: "rect", color: Colors.blue, fill: true)
            y += 15
            addShape(x: x+4, y: y, width: 1, height: 45, shape: "rect", color: UIColor.black, fill: true)
            y+=50
            addShape(x: x, y: y, width: 10, height: 10, shape: "rect", color: Colors.blue, fill: true)
            //        y+=10
            //        addText(x: x, y: y, text: "date.range".trad().uppercased(), font: self.fonts["body"]!, color:UIColor.black, width: 120, alignment: .center)
            //        y += 20
            y-=65
            x += 10
            addText(x: x, y: y, text: "\(df.string(from: startDate))", font: PDFonts.bodyBold, color:UIColor.black, width: 120, alignment: .center)
            y += 55
            addText(x: x, y: y, text: "\(df.string(from: endDate))", font: PDFonts.bodyBold, color:UIColor.black, width: 120, alignment: .center)
            
            y -= 60
            x += 120
            addShape(x: x, y: y, width: 140, height: 80, shape: "rect", color: self.colors["gray"]!, fill: true)
            y+=10
            addText(x: x, y: y, text: "position".trad().uppercased(), font: self.fonts["body"]!, color:UIColor.black, width: 140, alignment: .center)
            y += 25
            addText(x: x, y: y, text: "\(player.position.rawValue.trad())", font: self.fonts["heading"]!, color:Colors.blue, width: 140, alignment: .center)
            x += 150
            y -= 35
            //        let matchCount = Swift.Set(stats.map({$0.match})).count
            //        let setCount = Swift.Set(stats.map({$0.set})).count
            addShape(x: x, y: y, width: 120, height: 80, shape: "rect", color: self.colors["gray"]!, fill: true)
            y+=10
            addText(x: x, y: y, text: "match.played".trad().uppercased(), font: self.fonts["body"]!, color:UIColor.black, width: 120, alignment: .center)
            y += 25
            addText(x: x, y: y, text: "\(String(format: "%.0f", data["general"]!["matches"]!))", font: self.fonts["heading"]!, color:Colors.blue, width: 120, alignment: .center)
            y-=35
            x+=130
            addShape(x: x, y: y, width: 120, height: 80, shape: "rect", color: self.colors["gray"]!, fill: true)
            y+=10
            addText(x: x, y: y, text: "set.played".trad().uppercased(), font: self.fonts["body"]!, color:UIColor.black, width: 120, alignment: .center)
            y += 25
            addText(x: x, y: y, text: "\(String(format: "%.0f", data["general"]!["sets"]!))", font: self.fonts["heading"]!, color:Colors.blue, width: 120, alignment: .center)
            y+=90
            x=27
        }
        //serve data
        
//        let serves = stats.filter{s in return s.server == player.id && s.stage == 0}
//        let serveTot = serves.filter{ s in s.to != 0}.count
//        let aces = serves.filter{s in return s.action==8}.count
//        let serve1 = serves.filter{s in return s.action==39}.count
//        let serve2 = serves.filter{s in return s.action==40}.count
//        let serve3 = serves.filter{s in return s.action==41}.count
//        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
//        let serveMark = serveTot == 0 ? 0.00 : Float(serve1/2 + serve2 + 2*serve3 + 3*aces)/Float(serveTot)
        if self.sections.contains(.areaTotals){
            var bg = data["serve"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["serve"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
            width = Int(self.pageWidth/2)-25
            addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
            y+=5
            addText(x: x+15, y: y, text: "serve".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width)
            addText(x: x-15, y: y, text: "\(String(format: "%.2f", data["serve"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
            y+=35
            x+=15
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["serve"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "ace.short".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["serve"]!["ace"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "++".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["serve"]!["++"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "-".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["serve"]!["-"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["serve"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            
            y-=40
            x=Int(self.pageWidth/2)+10
            width = Int(self.pageWidth/2)-25
            //        let rcv = stats.filter{s in return [1, 2, 3, 4, 22].contains(s.action) && s.player == player.id}
            //        let Rerr = rcv.filter{s in return s.action==22}.count
            //        let op = rcv.filter{s in return s.action==1}.count
            //        let s1 = rcv.filter{s in return s.action==2}.count
            //        let s2 = rcv.filter{s in return s.action==3}.count
            //        let s3 = rcv.filter{s in return s.action==4}.count
            //        let mark = rcv.count == 0 ? 0.00 : Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count)
            bg = data["receive"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["receive"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
            addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
            
            y+=10
            addText(x: x+15, y: y, text: "receive".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .left)
            addText(x: x-15, y: y, text: "\(String(format: "%.2f", data["receive"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
            y+=30
            x+=15
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["receive"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "++".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["receive"]!["++"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "+".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["receive"]!["+"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "-".trad(), font: self.fonts["body"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["receive"]!["-"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["receive"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            
            x=27
            y+=80
            width = 220
            //        let atk = stats.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action) && s.player == player.id}
            //        let Aerr = atk.filter{s in return [16, 17, 18, 19].contains(s.action) && s.detail.lowercased() != "block"}.count
            //        let blocked = atk.filter{s in return [16, 17, 18, 19].contains(s.action) && s.detail.lowercased() == "block"}.count
            //        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
            //        let atkMark = atk.count > 0 ? Float(kills*3)/Float(atk.count) : 0.00
            bg = data["attack"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["attack"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
            addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
            
            y+=10
            addText(x: x+15, y: y, text: "attack".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .left)
            addText(x: x-15, y: y, text: "\(String(format: "%.2f", data["attack"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
            y+=30
            x+=15
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["attack"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "kills".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["attack"]!["kill"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "block".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["attack"]!["block"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["attack"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            
            y-=40
            x=255
            width = 170
            //        let blocks = stats.filter{s in return [7, 13, 20, 31].contains(s.action) && s.player == player.id}
            //        let blocksEarn = blocks.filter{s in return s.action==13}.count
            //        let blockErr = blocks.filter{s in return [20, 31].contains(s.action)}.count
            //        let blockMark = blocks.count > 0 ? Float(blocksEarn*3)/Float(blocks.count) : 0.00
            bg = data["block"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["block"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
            addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
            
            y+=10
            addText(x: x+15, y: y, text: "block".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .left)
            addText(x: x-15, y: y, text: "\(String(format: "%.2f",data["block"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
            y+=30
            x+=15
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["block"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "points".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["block"]!["points"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=50
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["block"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            
            y-=40
            x=430
            width = 150
            
            //        let dig = stats.filter{s in return [23, 5, 21].contains(s.action) && s.player == player.id}
            //        let digErr = dig.filter{s in return [23, 21].contains(s.action)}.count
            //        let digMark = dig.count > 0 ? (Float(dig.count-digErr)*3)/Float(dig.count) : 0.00
            bg = data["dig"]!["mark"]! <= 1.2 ? self.colors["red"]! : data["dig"]!["mark"]! >= 2.1 ? self.colors["green"]! : self.colors["gray"]!
            addShape(x: x, y: y, width: width, height: 100, shape: "rect", color: bg.withAlphaComponent(0.3), fill: true)
            
            y+=10
            addText(x: x+10, y: y, text: "dig".trad().uppercased(), font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .left)
            addText(x: x-10, y: y, text: "\(String(format: "%.2f",data["dig"]!["mark"]!))/3", font: self.fonts["headingBold"]!, color:UIColor.black, width: width, alignment: .right)
            y+=30
            x+=15
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "total".trad().capitalized, font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["dig"]!["total"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            x+=70
            addShape(x: x, y: y, width: 40, height: 40, shape: "rect", color: self.colors["gray"]!, fill: true)
            addText(x: x, y: y+5, text: "error".trad(), font: self.fonts["caption"]!, color:UIColor.black, width: 40, alignment: .center)
            addText(x: x, y: y+20, text: "\(Int(data["dig"]!["error"]!))", font: self.fonts["headingBold"]!, color:UIColor.black, width: 40, alignment: .center)
            
            y+=80
            x=27
        }
        if self.sections.contains(.playerMeasures){
            addShape(x: x, y: y, width: 100, height: 100, shape: "rect", color: self.colors["gray"]!, fill: true)
            y+=5
            addText(x: x, y: y, text: "height".trad(), font: PDFonts.body, color:UIColor.black, width: 100, alignment: .center)
            y += 15
            addShape(x: x+10, y: y, width: 80, height: 1, shape: "rect", color: Colors.black, fill: true)
            y+=5
            addImage(x: x+25, y: y, width: 50, height: 50, image: UIImage(named: "height")!)
            y+=55
            addText(x: x, y: y, text: measures != nil ? "\(measures!.height) cm" : "- cm", font: PDFonts.body, color:UIColor.black, width: 100, alignment: .center)
            x+=120
            y-=80
            addShape(x: x, y: y, width: 100, height: 150, shape: "rect", color: self.colors["gray"]!, fill: true)
            y+=5
            addText(x: x, y: y, text: "jump".trad(), font: PDFonts.body, color:UIColor.black, width: 100, alignment: .center)
            y += 15
            addShape(x: x+10, y: y, width: 80, height: 1, shape: "rect", color: Colors.black, fill: true)
            //        y+=10
            addImage(x: x-7, y: y, width: 100, height: 100, image: UIImage(named: "attackJump")!)
            y+=105
            addText(x: x, y: y, text: measures != nil ? "\(measures!.attackReach - measures!.oneHandReach) cm" : "- cm", font: PDFonts.body, color:UIColor.black, width: 100, alignment: .center)
            x=27
            y -= 5
            //        y += 120
            addShape(x: x, y: y, width: 100, height: 150, shape: "rect", color: self.colors["gray"]!, fill: true)
            y+=5
            addText(x: x, y: y, text: "block".trad().capitalized, font: PDFonts.body, color:UIColor.black, width: 100, alignment: .center)
            y += 15
            addShape(x: x+10, y: y, width: 80, height: 1, shape: "rect", color: Colors.black, fill: true)
            //        y+=10
            addImage(x: x-7, y: y, width: 100, height: 100, image: UIImage(named: "blockJump")!)
            y+=105
            addText(x: x, y: y, text: measures != nil ? "\(measures!.blockReach - measures!.twoHandReach) cm" : "- cm", font: PDFonts.body, color:UIColor.black, width: 100, alignment: .center)
            x+=120
            y-=75
            //        y+=50
            addShape(x: x, y: y, width: 100, height: 100, shape: "rect", color: self.colors["gray"]!, fill: true)
            y+=5
            addText(x: x, y: y, text: "breadth".trad(), font: PDFonts.body, color:UIColor.black, width: 100, alignment: .center)
            y += 15
            addShape(x: x+10, y: y, width: 80, height: 1, shape: "rect", color: Colors.black, fill: true)
            y+=5
            addImage(x: x+25, y: y, width: 50, height: 50, image: UIImage(named: "breadth")!)
            y+=55
            addText(x: x, y: y, text: measures != nil ? "\(measures!.breadth) cm" : "- cm", font: PDFonts.body, color:UIColor.black, width: 100, alignment: .center)
            
            x = Int(self.pageWidth/2)
            y-=170
        }
        if self.sections.contains(.feedback){
            addText(x: x, y: y, text: "comments".trad().uppercased(), font: self.fonts["title3"]!, color:UIColor.black)
            y+=35
            addText(x: x, y: y, text: feedBack, font: self.fonts["body"]!, color:UIColor.black, width: Int(self.pageWidth)-50)
        }
        return self
    }
    
    func testReport() -> Report {
        directionsGraph(x: 27, y: 27, width: 200, stats: [("2#9B", 3), ("2#6B", 1), ("4#1C", 5)], isServe: false)
        addHeatmapCourt(ix: 250, iy: 27, width: 200, colorScale: true, stats: [("2#9B", 2.55), ("2#6B", 0.25), ("4#1C", 1.25)])
        return self
    }
    
//    func setReport(team:Team, set: Set) -> Report{
//        //215, 217, 216
//        var x = 27
//        var y = header(info: "match.report".trad())
//        addText(x: x, y: y+10, text: "Set \(set.number)", font: PDFonts.title2, color:UIColor.black)
//        y+=40
//        //players section
//        var yPlay = y
//        x=250
//        addText(x: x+12, y: y, text: "serve".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=100
//        addText(x: x+5, y: y, text: "receive".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=85
//        addText(x: x+10, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=80
//        addText(x: x+15, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
//        y+=22
//        x=27
//        addText(x: x, y: y, text: "player".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=160
//        addText(x: x, y: y, text: "gp".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=45
//        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=30
//        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=30
//        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=40
//        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=25
//        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=30
//        addText(x: x, y: y, text: "mark".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=45
//        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=25
//        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=30
//        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=35
//        addText(x: x, y: y, text: "#", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=20
//        addText(x: x, y: y, text: "err".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=20
//        addText(x: x, y: y, text: "pts".trad(), font: self.fonts["bodyBold"]!, color:UIColor.black)
//        y+=22
//        x=27
//        var stats = set.stats()
////        if !self.sections.contains(.digCount){
////            stats = stats.filter{s in return !actionsByType["dig"]!.contains(s.action)}
////        }
//        var players = 2
//        team.players().forEach{player in
//            let ps = stats.filter{s in return s.player == player.id}
//            let serves = stats.filter{s in return s.server == player.id && s.stage == 0 && s.to != 0}
//            if ps.count > 0 || serves.count > 0{
//                players += 1
//                addText(x: x, y: y, text: "\(player.number)", font: self.fonts["body"]!, color:UIColor.black)
//                addText(x: x+20, y: y, text: "\(player.name)", font: self.fonts["body"]!, color:UIColor.black)
//                x+=160
//                //G-P
//                var gp = 0
//                if self.sections.contains(.hiddenCount){
//                    gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
//                }else{
//                    let g = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
//                    let p = ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}
//                    print(g, p)
//                    gp = g.count - p.count
//                }
//                addText(x: x, y: y, text: gp == 0 ? "." : "\(gp)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=45
//                //serves
//                
//                addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                // serve errors
//                x+=30
//                let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
//                addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                // aces
//                x+=30
//                let aces = serves.filter{s in return s.action==8}.count
//                addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=40
//                // receive
//                let rcv = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
//                addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=25
//                // receive error
//                let Rerr = rcv.filter{s in return s.action==22}.count
//                addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=30
//                // receive mark
//                let op = rcv.filter{s in return s.action==1}.count
//                let s1 = rcv.filter{s in return s.action==2}.count
//                let s2 = rcv.filter{s in return s.action==3}.count
//                let s3 = rcv.filter{s in return s.action==4}.count
//                let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
//                addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=45
//                // attack
//                let atk = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
//                addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=25
//                // Attack errors
//                let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
//                addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=30
//                // kills
//                let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
//                addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=35
//                // blocks
//                let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
//                let blkPts = ps.filter{s in return s.action==13}.count
//                let bErr = ps.filter{s in return s.action==20}.count
//                addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=20
//                addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x+=20
//                addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//                x = 27
//                y+=20
//            }
//        }
//        y+=10
//        let h = (players * 20) + 5
//        x=250
//        addShape(x: x-75, y: yPlay, width: 50, height: h, shape: "rect", color: UIColor.black, fill: false)
//        addShape(x: x-75, y: yPlay, width: 145, height: h, shape: "rect", color: UIColor.black, fill: false)
//        x+=100
//        addShape(x: x-30, y: yPlay, width: 105, height: h, shape: "rect", color: UIColor.black, fill: false)
//        x+=100
//        addShape(x: x-25, y: yPlay, width: 85, height: h, shape: "rect", color: UIColor.black, fill: false)
//        x+=60
//        addShape(x: x, y: yPlay, width: 75, height: h, shape: "rect", color: UIColor.black, fill: false)
//        yPlay+=22
//        x=27
//        addShape(x: x-10, y: yPlay-5, width: 568, height: h-17, shape: "rect", color: UIColor.black, fill: false)
//        x+=50
//        
//        addText(x: x, y: y, text: "\("totals".trad())", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=110
//        let ps = stats.filter{s in return s.player != 0}
//        var gp = 0
//        if self.sections.contains(.hiddenCount){
//            gp = ps.filter{$0.to == 1}.count - ps.filter{$0.to == 2}.count
//        }else{
//            gp = ps.filter{$0.to == 1 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count - ps.filter{$0.to == 2 && !actionsByType["dig"]!.contains($0.action) && !actionsByType["set"]!.contains($0.action)}.count
//        }
//        addText(x: x, y: y, text: gp == 0 ? "." : "\(gp)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=45
//        
//        //serves
//        let serves = stats.filter{s in return s.stage == 0 && s.to != 0}
//        addText(x: x, y: y, text: serves.count == 0 ? "." : "\(serves.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        // serve errors
//        x+=30
//        let Serr = serves.filter{s in return [15, 32].contains(s.action)}.count
//        addText(x: x, y: y, text: Serr == 0 ? "." : "\(Serr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        // aces
//        x+=30
//        let aces = serves.filter{s in return s.action==8}.count
//        addText(x: x, y: y, text: aces == 0 ? "." : "\(aces)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=40
//        // receive
//        let rcv = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
//        addText(x: x, y: y, text: rcv.count == 0 ? "." : "\(rcv.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=25
//        // receive error
//        let Rerr = rcv.filter{s in return s.action==22}.count
//        addText(x: x, y: y, text: Rerr == 0 ? "." : "\(Rerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=30
//        
//        // receive mark
//        let op = rcv.filter{s in return s.action==1}.count
//        let s1 = rcv.filter{s in return s.action==2}.count
//        let s2 = rcv.filter{s in return s.action==3}.count
//        let s3 = rcv.filter{s in return s.action==4}.count
//        let mark = rcv.count == 0 ? "." : String(format: "%.2f", Float(op/2 + s1 + 2*s2 + 3*s3)/Float(rcv.count))
//        addText(x: x, y: y, text: mark, font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=45
//        // attack
//        let atk = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
//        addText(x: x, y: y, text: atk.count == 0 ? "." : "\(atk.count)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=25
//        // Attack errors
//        let Aerr = atk.filter{s in return [16, 17, 18].contains(s.action)}.count
//        addText(x: x, y: y, text: Aerr == 0 ? "." : "\(Aerr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=30
//        // kills
//        let kills = atk.filter{s in return [9, 10, 11].contains(s.action)}.count
//        addText(x: x, y: y, text: kills == 0 ? "." : "\(kills)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=35
//        // blocks
//        let blocks = ps.filter{s in return actionsByType["block"]!.contains(s.action)}.count
//        let blkPts = ps.filter{s in return s.action==13}.count
//        let bErr = ps.filter{s in return s.action==20}.count
//        addText(x: x, y: y, text: blocks == 0 ? "." : "\(blocks)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=20
//        addText(x: x, y: y, text: bErr == 0 ? "." : "\(bErr)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//        x+=20
//        addText(x: x, y: y, text: blkPts == 0 ? "." : "\(blkPts)", font: self.fonts["bodyBold"]!, color:UIColor.black)
//
//        return self
//    }
}
