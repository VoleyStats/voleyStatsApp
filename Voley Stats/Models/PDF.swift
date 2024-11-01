import PDFKit

struct Colors{
    static let green = UIColor(red: 0.33, green: 0.78, blue: 0.36, alpha: 1)
    static let green2 = UIColor(red: 0.33, green: 0.8, blue: 0.36, alpha: 1)
    static let green3 = UIColor(red: 0.25, green: 0.78, blue: 0.4, alpha: 1)
    static let orange = UIColor(red: 0.84, green: 0.57, blue: 0.23, alpha: 1)
    static let pink = UIColor(red: 0.77, green: 0.45, blue: 0.83, alpha: 1)
    static let yellow = UIColor(red: 0.97, green: 0.79, blue: 0.29, alpha: 1)
    static let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let gray = UIColor(red: 0.84, green: 0.85, blue: 0.85, alpha: 1)
    static let gold = UIColor(red: 0.73, green: 0.58, blue: 0.09, alpha: 1)
    static let blue = UIColor(red: 0.29, green: 0.62, blue: 0.93, alpha: 1)
    static let red = UIColor(red: 0.69, green: 0.1, blue: 0.1, alpha: 1)
}

struct PDFonts{
    static let title = UIFont(name: "Futura-bold", size:  26.0) ?? UIFont.boldSystemFont(ofSize: 26)
    static let body = UIFont.systemFont(ofSize: 12)
    static let bodyBold = UIFont.boldSystemFont(ofSize: 12)
    static let headingBold = UIFont(name: "Futura-bold", size:  12) ?? UIFont.boldSystemFont(ofSize: 12)
    static let heading = UIFont(name: "Futura-medium", size:  18) ?? UIFont.boldSystemFont(ofSize: 12)
    static let caption = UIFont.systemFont(ofSize: 9)
    static let title2 = UIFont(name: "Futura-bold", size:  22) ?? UIFont.boldSystemFont(ofSize: 22)
    static let title3 = UIFont(name: "Futura-bold", size:  18) ?? UIFont.boldSystemFont(ofSize: 18)
}

class PDF {
    var pdf: UIGraphicsPDFRenderer
    var title: String = "Output"
    var elements: [PDFElement] = []
    let pageWidth = 595.2
    let pageHeight = 841.8
    let page:CGRect
    let fonts: Dictionary<String,UIFont> = [
        "title": UIFont(name: "Futura-bold", size:  26.0) ?? UIFont.boldSystemFont(ofSize: 26),
        "body":UIFont.systemFont(ofSize: 12),
        "bodyBold":UIFont.boldSystemFont(ofSize: 12),
        "headingBold":UIFont(name: "Futura-bold", size:  12) ?? UIFont.boldSystemFont(ofSize: 12),
        "heading":UIFont(name: "Futura-medium", size:  18) ?? UIFont.boldSystemFont(ofSize: 12),
        "caption":UIFont.systemFont(ofSize: 9),
        "title2": UIFont(name: "Futura-bold", size:  22) ?? UIFont.boldSystemFont(ofSize: 22),
        "title3": UIFont(name: "Futura-bold", size:  18) ?? UIFont.boldSystemFont(ofSize: 18),
    ]
    let colors: Dictionary<String,UIColor>=[
        "green": UIColor(red: 0.33, green: 0.78, blue: 0.36, alpha: 1),
        "orange": UIColor(red: 0.84, green: 0.57, blue: 0.23, alpha: 1),
        "pink": UIColor(red: 0.77, green: 0.45, blue: 0.83, alpha: 1),
        "yellow": UIColor(red: 0.97, green: 0.79, blue: 0.29, alpha: 1),
        "black": UIColor(red: 0, green: 0, blue: 0, alpha: 1),
        "white": UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        "gray": UIColor(red: 0.84, green: 0.85, blue: 0.85, alpha: 1),
        "gold": UIColor(red: 0.73, green: 0.58, blue: 0.09, alpha: 1),
        "blue": UIColor(red: 0.29, green: 0.62, blue: 0.93, alpha: 1),
        "red": UIColor(red: 0.69, green: 0.1, blue: 0.1, alpha: 1),
    ]
    init() {
        let pdfMetaData = [
            kCGPDFContextCreator: "Voley stats",
            kCGPDFContextAuthor: "Voley stats"
          ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        self.page=pageRect
          // 3
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        self.pdf = renderer
    }
    
    func header(info: String) -> Int{
        var y = 15
        addImage(x: 37, y: y, width: 100, height: 70, image: UIImage(named: "imagotipo")!)
        y += 10
        addText(x: Int(self.pageWidth)-(info.count*7+27), y: y, text: info, font: self.fonts["body"]!, color:UIColor.black)
        y+=25
        addShape(x: 27, y: y, width: Int(self.pageWidth-54), height: 1, shape: "rect", color: UIColor.black, fill: true)
        y+=5
        return y
    }
    
    func lastMonthReport(team: Team, startDate: Date, endDate: Date) -> PDF{
        self.title = "\(team.name)_report_\(Date().timeIntervalSince1970)"
        let stats = team.fullStats(startDate: startDate, endDate: endDate)
        var x = 27
        var y = header(info: "team.report".trad())
        
//        y+=10
        addText(x: x, y: y+10, text: "\(team.name) \("report".trad())".uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        y+=45
        
        
        addShape(x: x, y: y, width: Int(self.pageWidth-54), height: 100, shape: "rect", color: UIColor.gray.withAlphaComponent(0.2), fill: true)
        addImage(x: Int(self.pageWidth-47), y: y+6, width: 15, height: 15, image: UIImage(systemName: "info.circle")!)
        x+=10
        y+=20
        addText(x: x, y: y, text: "date.range".trad().uppercased(), font: self.fonts["heading"]!, color:UIColor.black)
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        y+=15
        addText(x: x, y: y, text: "\(df.string(from: date))", font: self.fonts["title2"]!, color:self.colors["blue"]!)
        y+=25
        addText(x: x, y: y, text: "\(df.string(from: Date()))", font: self.fonts["title2"]!, color:self.colors["blue"]!)
        y-=40
        x+=175
        addText(x: x, y: y, text: "number.matches".trad().uppercased(), font: self.fonts["heading"]!, color:UIColor.black)
        let matches = team.matches(startDate: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(), endDate: Date())
        y+=15
        addText(x: x+50, y: y, text: "\(matches.count)", font: self.fonts["title2"]!, color:self.colors["blue"]!)
        x+=175
        y-=15
        addText(x: x, y: y, text: "number.trainings".trad().uppercased(), font: self.fonts["heading"]!, color:UIColor.black)
//        let trainings = Improve.dates().filter{$0 >= date}
        y+=15
        addText(x: x+50, y: y, text: "\(0)", font: self.fonts["title2"]!, color:self.colors["blue"]!)
        x=27
        y+=75
        
        addText(x: x, y: y+10, text: "stats".trad().uppercased(), font: self.fonts["title"]!, color:UIColor.black)
        let graphLen = Int(self.pageWidth/2) - 37
        y+=45
        addText(x: x+10, y: y, text: "attack".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let atks = (stats["attack"]!["total"]!, stats["attack"]!["error"]!, stats["attack"]!["earned"]!)
        let atksLen = (atks.0 > 0 ? graphLen : 30, (atks.0 > 0 && atks.1 > 0) ? (graphLen*atks.1)/atks.0 : 30, (atks.0 > 0 && atks.2 > 0) ? (graphLen*atks.2)/atks.0 : 30)
        y+=25
        addShape(x: x, y: y, width: atksLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (atks.1 > 0){
            addText(x: x+atksLen.1-25, y: y+8, text: "\(atks.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: atksLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (atks.2 > 0){
            addText(x: x+atksLen.2-25, y: y+8, text: "\(atks.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: atksLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (atks.0 > 0){
            addText(x: x+atksLen.0-25, y: y+8, text: "\(atks.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        addText(x: x+10, y: y, text: "serve".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let srv = (stats["serve"]!["total"]!, stats["serve"]!["error"]!, stats["serve"]!["earned"]!)
        let srvLen = (srv.0 > 0 ? graphLen : 30, (srv.0 > 0 && srv.1 > 0) ? (graphLen*srv.1)/srv.0 : 30, (srv.0 > 0 && srv.2 > 0) ? (graphLen*srv.2)/srv.0 : 30)
        y+=25
        addShape(x: x, y: y, width:  srvLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (srv.1 > 0){
            addText(x: x+srvLen.1-25, y: y+8, text: "\(srv.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: srvLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (srv.2 > 0){
            addText(x: x+srvLen.2-25, y: y+8, text: "\(srv.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: srvLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (srv.0 > 0){
            addText(x: x+srvLen.0-25, y: y+8, text: "\(srv.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        addText(x: x+10, y: y, text: "set".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let set = (stats["set"]!["total"]!, stats["set"]!["error"]!, stats["set"]!["earned"]!)
        let setLen = (set.0 > 0 ? graphLen : 30, (set.0 > 0 && set.1 > 0) ? (graphLen*set.1)/set.0 : 30, (set.0 > 0 && set.2 > 0) ? (graphLen*set.2)/set.0 : 30)
        y+=25
        addShape(x: x, y: y, width: setLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (set.1 > 0){
            addText(x: x+setLen.1-25, y: y+8, text: "\(set.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: setLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (set.2 > 0){
            addText(x: x+setLen.2-25, y: y+8, text: "\(set.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: setLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (set.0 > 0){
            addText(x: x+setLen.0-25, y: y+8, text: "\(set.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y-=385
        x=Int(self.pageWidth/2)
        addText(x: x+10, y: y, text: "block".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let blk = (stats["block"]!["total"]!, stats["block"]!["error"]!, stats["block"]!["earned"]!)
        let blkLen = (blk.0 > 0 ? graphLen : 30, (blk.0 > 0 && blk.1 > 0) ? (graphLen*blk.1)/blk.0 : 30, (blk.0 > 0 && blk.2 > 0) ? (graphLen*blk.2)/blk.0 : 30)
        y+=25
        addShape(x: x, y: y, width: blkLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (blk.1 > 0){
            addText(x: x+blkLen.1-25, y: y+8, text: "\(blk.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: blkLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (blk.2 > 0){
            addText(x: x+blkLen.2-25, y: y+8, text: "\(blk.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: blkLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (blk.0 > 0){
            addText(x: x+blkLen.0-25, y: y+8, text: "\(blk.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        addText(x: x+10, y: y, text: "receive".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let rcv = (stats["receive"]!["total"]!, stats["receive"]!["error"]!, stats["receive"]!["earned"]!)
        let rcvLen = (rcv.0 > 0 ? graphLen : 30, (rcv.0 > 0 && rcv.1 > 0) ? (graphLen*rcv.1)/rcv.0 : 30, (rcv.0 > 0 && rcv.2 > 0) ? (graphLen*rcv.2)/rcv.0 : 30)
        y+=25
        addShape(x: x, y: y, width: rcvLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (rcv.1 > 0){
            addText(x: x+rcvLen.1-25, y: y+8, text: "\(rcv.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: rcvLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (rcv.2 > 0){
            addText(x: x+rcvLen.2-25, y: y+8, text: "\(rcv.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: rcvLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (rcv.0 > 0){
            addText(x: x+rcvLen.0-25, y: y+8, text: "\(rcv.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        addText(x: x+10, y: y, text: "dig".trad().capitalized, font: self.fonts["bodyBold"]!, color:UIColor.black)
        let dig = (stats["dig"]!["total"]!, stats["dig"]!["error"]!, stats["dig"]!["earned"]!)
        let digLen = (dig.0 > 0 ? graphLen : 30, (dig.0 > 0 && dig.1 > 0) ? (graphLen*dig.1)/dig.0 : 30, (dig.0 > 0 && dig.2 > 0) ? (graphLen*dig.2)/dig.0 : 30)
        y+=25
        addShape(x: x, y: y, width: digLen.1, height: 30, shape: "rect", color: self.colors["orange"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "multiply.circle")!)
        if (dig.1 > 0){
            addText(x: x+digLen.1-25, y: y+8, text: "\(dig.1)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: digLen.2, height: 30, shape: "rect", color: self.colors["green"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "checkmark.circle")!)
        if (dig.2 > 0){
            addText(x: x+digLen.2-25, y: y+8, text: "\(dig.2)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        addShape(x: x, y: y, width: digLen.0, height: 30, shape: "rect", color: self.colors["gray"]!, fill: true, radius: 15)
        addImage(x: x+2, y: y+4, width: 25, height: 25, image: UIImage(systemName: "minus.circle")!)
        if (dig.0 > 0){
            addText(x: x+digLen.0-25, y: y+8, text: "\(dig.0)", font: self.fonts["bodyBold"]!, color:UIColor.black)
        }
        y+=35
        y+=15
        return self
    }
    
    func errorTree(match: Match, startX: Int, startY: Int)->(Int, Int){
        let data = match.getErrorTree()
        var x = startX
        var y = startY
        self.addText(x: x, y: y, text: "error.tree".trad().uppercased(), font: PDFonts.bodyBold, color: Colors.black, width: 250, alignment: .center)
        y+=30
        self.addText(x: x, y: y, text: "us".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 125, alignment: .left)
        x += 125
        self.addText(x: x, y: y, text: "them".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 125, alignment: .right)
        y += 25
        data.sorted(by: {$0.key < $1.key}).forEach{area in
            x=startX
            self.addText(x: x, y: y, text: "\(area.value.0)", font: PDFonts.body, color: Colors.black, width: 50, alignment: .left)
            x+=50
            self.addText(x: x, y: y, text: "\(area.key.split(separator: ".")[1])".trad().capitalized, font: PDFonts.body, color: Colors.black, width: 150, alignment: .center)
            x+=150
            self.addText(x: x, y: y, text: "\(area.value.1)", font: PDFonts.body, color: Colors.black, width: 50, alignment: .right)
            x+=50
            y+=20
        }
        self.addShape(x: startX-10, y: startY-10, width: x-startX+20, height: y-startY+10, shape: "rect", color: Colors.black, fill: false)
        return (x, y)
    }
    
    func matchCompare(match: Match, startX: Int, startY: Int)->(Int, Int){
        var x = startX
        var y = startY
        let data = match.compareMatches()
        self.addText(x: x, y: y, text: "match.compare".trad().uppercased(), font: PDFonts.bodyBold, color: Colors.black, width: 250, alignment: .center)
        y+=30
        x+=30
        self.addText(x: x, y: y, text: "area".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 100, alignment: .left)
        x += 100
        self.addText(x: x, y: y, text: "actual".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 60, alignment: .center)
        x += 60
        self.addText(x: x, y: y, text: "previous".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 60, alignment: .center)
        y+=25
        data.sorted(by: {$0.key < $1.key}).forEach{area in
            x=startX
            if area.value.0 > area.value.1{
                self.addShape(x: x-1, y: y-1, width: 18, height: 18, shape: "rect", color: Colors.green, fill: true, radius: 9)
                self.addImage(x: x, y: y, width: 16, height: 16, image: UIImage(systemName: "arrow.up.circle")!)
                
            }else if area.value.0 < area.value.1{
                self.addShape(x: x-1, y: y-1, width: 18, height: 18, shape: "rect", color: Colors.red, fill: true, radius: 9)
                self.addImage(x: x, y: y, width: 16, height: 16, image: UIImage(systemName: "arrow.down.circle")!)
                
            }else{
                self.addShape(x: x-1, y: y-1, width: 18, height: 18, shape: "rect", color: Colors.gray, fill: true, radius: 9)
                self.addImage(x: x, y: y, width: 16, height: 16, image: UIImage(systemName: "equal.circle")!)
                
            }
            x+=30
            self.addText(x: x, y: y, text: "\(area.key.split(separator: "-")[1])".trad().capitalized, font: PDFonts.body, color: Colors.black, width: 100, alignment: .left)
            x+=100
            self.addText(x: x, y: y, text: "\(area.value.0.formatted(.number.precision(.fractionLength(2))))", font: PDFonts.body, color: Colors.black, width: 60, alignment: .center)
            x+=60
            self.addText(x: x, y: y, text: "\(area.value.1.formatted(.number.precision(.fractionLength(2))))", font: PDFonts.body, color: Colors.black, width: 60, alignment: .center)
            x+=60
            y+=25
        }
        self.addShape(x: startX-10, y: startY-10, width: x-startX+20, height: y-startY+10, shape: "rect", color: Colors.black, fill: false)
        return (x, y)
    }
    
    func pointLog(set: Set, single: Bool = false){
        var x = 17
        var y = 17
        var startY = 17
        var startX = 17
//        match.sets().filter{$0.first_serve != 0}.enumerated().forEach{(index, set) in
        let stats = set.stats().filter{$0.to != 0 && $0.action != 0}
//            if (index % 2 == 0) || double{
        if stats.count < 44{
            x=150
        }
        self.newPage()
//        startX = x
        y = self.header(info: "match.report".trad()) + 5
        startY = y
//            } else {
//                x = 17 + 285
//                startX = x
//                y = startY
//            }
//            double = false
        self.addText(x: startX, y: y, text: single ? "\("point.log".trad()) set \(set.number)" : "point.log".trad(), font: PDFonts.heading, color: Colors.black, width: Int(self.pageWidth), alignment: .center)
        y+=35
        startX = x
        x+=20
        self.addText(x: x, y: y, text: "player".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 50, alignment: .left)
        x+=50
        self.addText(x: x, y: y, text: "action".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 70, alignment: .left)
        x+=70
        self.addText(x: x, y: y, text: "them".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 55, alignment: .center)
        x+=55
        self.addText(x: x, y: y, text: "us".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 55, alignment: .center)
        x+=55
        y+=20
        stats.enumerated().forEach{i, stat in
            x = startX
            if i == 44{
                x = 17 + 285
                startX = x
                y = startY + 35
                x += 20
                self.addText(x: x, y: y, text: "player".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 50, alignment: .left)
                x+=50
                self.addText(x: x, y: y, text: "action".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 70, alignment: .left)
                x+=70
                self.addText(x: x, y: y, text: "them".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 55, alignment: .center)
                x+=55
                self.addText(x: x, y: y, text: "us".trad(), font: PDFonts.bodyBold, color: Colors.black, width: 55, alignment: .center)
                x = 17 + 285
                y+=20
            }
            self.addText(x: x, y: y, text: stat.to == 1 ? "+" : "-", font: PDFonts.bodyBold, color: Colors.black, width: 20, alignment: .center)
            x+=20
            self.addText(x: x, y: y, text: Player.find(id: stat.player)?.number.description ?? "them".trad(), font: PDFonts.body, color: Colors.black, width: 50, alignment: .left)
            x+=50
            self.addText(x: x, y: y, text: Action.find(id: stat.action)?.shortName() ?? "err: \(stat.action)", font: PDFonts.body, color: Colors.black, width: 70, alignment: .left)
            x+=70
            let pt = stat.score_us - stat.score_them
            let width = abs(pt)*55/25
            if pt < 0{
                x = x+55-width
            }else{
                x+=55
            }
            self.addShape(x: x, y: y, width: width, height: 12, shape: "rect", color: Colors.gray, fill: true, radius: 3)
            self.addText(x: startX+250, y: y, text: "\(stat.score_them)-\(stat.score_us)", font: PDFonts.caption, color: Colors.black)
            y += 15
        }
//            self.addShape(x: 195, y: startY+50, width: 1, height: y, shape: "rect", color: Colors.black, fill: false)
//        }
    }
    
    func barChart(startX: Int, startY: Int, width: Int, height: Int, title: String, data: [BarElement]) -> (Int, Int){
        var x = startX
        var y = startY
        let h = height - 150
        let w = (width / data.count) - 7
        let max = data.max(by: {$0.value < $1.value})?.value ?? 1
//        print(data.max(by: {$0.value < $1.value}), data)
        let grouped = Dictionary(grouping: data, by: {$0.group})
        let gap = (width-((w+3)*data.count))/(grouped.count - 1)
//        self.addShape(x: x, y: y, width: width, height: height, shape: "rect", color: Colors.gray.withAlphaComponent(0.2), fill: true, radius: 6)
//        y+=30
        self.addText(x: x, y: y, text: title, font: PDFonts.heading, color: Colors.black, width: width, alignment: .center)
        y += 50
        
        grouped.sorted(by: {$0.key < $1.key}).forEach{group in
            let gw = group.value.count*w + 3*group.value.count
            self.addLine(from: (x, y+h+5), to: (x+gw, y+h+5), color: Colors.black, lineWeight: 1)
//            self.addShape(x: x, y: y+h+5, width: gw, height: 1, shape: "rect", color: Colors.black, fill: false)
            self.addText(x: x, y: y+h+10, text: "\(group.key)", font: PDFonts.body, color: Colors.black, width: gw, alignment: .center)
            group.value.forEach{bar in
                let barHeight = bar.value * h / max
//                print(bar.value, barHeight, max)
                self.addShape(x: x, y: y+h-barHeight, width: w, height: barHeight, shape: "rect", color: bar.color, fill: true, radius: 3)
                self.addText(x: x, y: y+h-barHeight-15, text: bar.value.description, font: PDFonts.caption, color: Colors.black, width: w, alignment: .center)
                x+=3+w
            }
            x+=gap
        }
        y = y+h+30
        x=startX
        let labels = Dictionary(grouping: data, by: {$0.label}).map({($0.key, $0.value.first?.color ?? .black)})
        labels.forEach{label in
            self.addShape(x: x, y: y+3, width: 10, height: 10, shape: "rect", color: label.1, fill: true, radius: 5)
            var sp = label.0.trad().count
            sp = sp >= 5 ? sp*10 : sp == 1 ? 35 : sp*15
            self.addText(x: x+15, y: y, text: label.0.trad(), font: PDFonts.body, color: Colors.black, width: sp)
            x+=sp+10
        }
        return (width, y)
    }
    
    func getCoords(x:Int, y: Int, width: Int, direction: String, isServe: Bool)->((Int, Int), (Int, Int)){
        var dest = ((0,0), (0,0))
        let codes = direction.split(separator: "#")
        let from = Int(codes[0])
        let to = codes[1].first!
        let subTo = codes[1].last!
        
        switch from {
        case 1:
            dest.0 = (Int(width/6), Int(width/3))
        case 2:
            dest.0 = (Int(width/6), Int(5*width/6))
        case 3:
            dest.0 = (Int(width/2), Int(5*width/6))
        case 4:
            dest.0 = (Int(5*width/6), Int(5*width/6))
        case 5:
            dest.0 = (Int(5*width/6), Int(width/3))
        case 6:
            dest.0 = (Int(width/2), Int(width/3))
        default:
            dest.0 = (0, 0)
        }
        
        switch to{
        case "1":
            dest.1 = (Int(5*width/6), Int(5*width/6))
        case "2":
            dest.1 = (Int(5*width/6), Int(width/6))
        case "3":
            dest.1 = (Int(width/2), Int(width/6))
        case "4":
            dest.1 = (Int(width/6), Int(width/6))
        case "5":
            dest.1 = (Int(width/6), Int(5*width/6))
        case "6":
            dest.1 = (Int(width/2), Int(5*width/6))
        case "7":
            dest.1 = (Int(width/6), Int(width/2))
        case "8":
            dest.1 = (Int(width/2), Int(width/2))
        case "9":
            dest.1 = (Int(5*width/6), Int(width/2))
        default:
            dest.1 = (0, 0)
        }
        
        switch subTo{
        case "A":
            dest.1.0 -= Int(width/12)
            dest.1.1 -= Int(width/12)
        case "B":
            dest.1.0 += Int(width/12)
            dest.1.1 -= Int(width/12)
        case "C":
            dest.1.0 += Int(width/12)
            dest.1.1 += Int(width/12)
        case "D":
            dest.1.0 -= Int(width/12)
            dest.1.1 += Int(width/12)
            
        default:
            dest.1 = (0, 0)
        }
        
        if (isServe){
            dest.0.1 = 0
        }
        
        dest.1.1 += width
        
        dest.0.0 += x
        dest.1.0 += x
        dest.0.1 += y
        dest.1.1 += y
        
        return dest
    }
    
    func addCourt(ix:Int, iy: Int, width: Int, full: Bool = false){
        var x = ix
        var y = iy
        if full {
            
            addShape(x: x, y: y, width: width, height: width, shape: "rect", color: UIColor.orange, fill: true, radius: 0)
            
            addShape(x: ix, y: iy, width: width, height: width, shape: "rect", color: UIColor.black, fill: false, radius: 2)
            addLine(from: (ix, y+((2*width/3))), to: (ix+width, y+((2*width/3))), color: UIColor.black, lineWeight: 2)
//            addShape(x: ix, y: iy+((width/3)*2), width: width, height: 1, shape: "rect", color: UIColor.black, fill: false, radius: 2)
            
        }
        y+=width
        addShape(x: x, y: y, width: width, height: width, shape: "rect", color: UIColor.orange, fill: true, radius: 0)
        
        addShape(x: ix, y: y, width: width, height: width, shape: "rect", color: UIColor.black, fill: false, radius: 2)
        addLine(from: (ix, y+((width/3))), to: (ix+width, y+((width/3))), color: UIColor.black, lineWeight: 2)
//        addShape(x: ix, y: y+((width/3)), width: width, height: 1, shape: "rect", color: UIColor.black, fill: false, radius: 2)
    }
    
    func directionsGraph(x: Int, y: Int, width: Int, stats: [(String, Double)], isServe: Bool){
        self.addCourt(ix: x, iy: y, width: width, full: true)
        let max = stats.max{a, b in a.1 < b.1}?.1 ?? 1
        stats.forEach{code in
            let coord = getCoords(x: x, y: y, width: width, direction: code.0, isServe: isServe)
            self.addLine(from: coord.0, to: coord.1, color: .red, lineWeight: code.1*7/max)
        }
    }
    
    func getColorScale(value: Double?)->UIColor{
        if value == nil {
            return .clear
        }
        if value! <= 0.5{
            return .red
        }
        if value! > 0.5 && value! <= 1.5{
            return .orange
        }
        if value! > 1.5 && value! <= 2.5 {
            return .yellow
        }
        return .green
    }
    
    func addHeatmapCourt(ix:Int, iy: Int, width: Int, colorScale: Bool, stats: [(String, Double)]){
        var x = ix
        var y = iy
        let max = stats.max{a, b in a.1 < b.1}?.1 ?? 0
        addShape(x: x, y: y, width: width, height: width, shape: "rect", color: .gray, fill: true, radius: 0)
        [[4,3,2],[7,8,9],[5,6,1]].forEach{row in
            row.forEach{zone in
                let a = stats.filter{s in s.0.contains("\(zone)A")}.first?.1
                let b = stats.filter{s in s.0.contains("\(zone)B")}.first?.1
                let c = stats.filter{s in s.0.contains("\(zone)C")}.first?.1
                let d = stats.filter{s in s.0.contains("\(zone)D")}.first?.1
                
                addShape(x: x, y: y, width: width/6, height: width/6, shape: "rect", color: colorScale ? getColorScale(value: a) : UIColor.red.withAlphaComponent(a ?? 0/max), fill: true, radius: 0)
                addShape(x: x+(width/6), y: y, width: width/6, height: width/6, shape: "rect", color: colorScale ? getColorScale(value: b) : UIColor.red.withAlphaComponent(b ?? 0/max), fill: true, radius: 0)
                addShape(x: x, y: y+(width/6), width: width/6, height: width/6, shape: "rect", color: colorScale ? getColorScale(value: d) : UIColor.red.withAlphaComponent(d ?? 0/max), fill: true, radius: 0)
                addShape(x: x+(width/6), y: y+(width/6), width: width/6, height: width/6, shape: "rect", color: colorScale ? getColorScale(value: c) : UIColor.red.withAlphaComponent(c ?? 0/max), fill: true, radius: 0)
                x += width/3
            }
            y += width/3
            x = ix
        }
        addShape(x: ix, y: iy, width: width, height: width, shape: "rect", color: UIColor.black, fill: false, radius: 2)
        addLine(from: (ix, iy+((width/3))), to: (ix+width, iy+((width/3))), color: UIColor.black, lineWeight: 2)
//        addShape(x: ix, y: iy+((width/3)), width: width, height: 1, shape: "rect", color: UIColor.black, fill: false, radius: 2)
    }
    
    func addImage(x:Int, y:Int, width:CGFloat, height:CGFloat, image:UIImage){
//        let maxHeight = self.page.height * 0.4
//        let maxWidth = self.page.width * 0.8
          // 2
          let aspectWidth = width / image.size.width
          let aspectHeight = height / image.size.height
          let aspectRatio = min(aspectWidth, aspectHeight)
          // 3
          let scaledWidth = image.size.width * aspectRatio
          let scaledHeight = image.size.height * aspectRatio
          // 4
//            let imageX = (self.page.width - scaledWidth) / 2.0
        
          let imageRect = CGRect(x: x, y: y, width: Int(scaledWidth), height: Int(scaledHeight))
          self.elements.append(PDFElement(x: x, y: y, data: image, rect: imageRect))
          // 5
//          image.draw(in: imageRect)
//          return imageRect.origin.y + imageRect.size.height
    }
    
    func addText(x:Int, y:Int, text: String, font: UIFont, color:UIColor, width: Int? = nil, alignment: NSTextAlignment = .left){
        self.elements.append(PDFElement(x: x, y: y, data: text, font: font, color: color, width: width, alignment: alignment))
    }
    
    func addShape(x: Int, y:Int, width:Int, height:Int, shape:String, color: UIColor, fill: Bool, radius:CGFloat = 6){
        self.elements.append(PDFElement(x: x, y: y, width: width, height: height, shape: shape, color: color, fill: fill, radius:radius))
    }
    
    func addLine(from:(Int, Int), to: (Int, Int), color: UIColor, lineWeight: CGFloat){
        self.elements.append(PDFElement(x: from.0, y: from.1, width: to.0, height: to.1, shape: "line", color: color, fill: false, radius:lineWeight))
    }
    
    func newPage(){
        self.elements.append(PDFElement())
    }
    
    func drawShape(x: Int, y:Int, width:Int, height:Int, shape:String, color: UIColor, fill: Bool, radius:CGFloat, context:UIGraphicsPDFRendererContext){
        if shape == "rect" {
            if fill {
//                context.stroke(self.pdf.format.bounds)
//                color.setFill()
//                context.fill(CGRect(x: x, y: y, width: width, height: height))
                let rect = CGRect(x: x, y: y, width: width, height: height)
                context.cgContext.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
                context.cgContext.setFillColor(color.cgColor)
                context.cgContext.closePath()
                context.cgContext.fillPath()
            } else{
                let rect = CGRect(x: x, y: y, width: width, height: height)
                context.cgContext.addRect(rect)
                context.cgContext.setStrokeColor(color.cgColor)
                context.cgContext.setLineWidth(radius)
                context.cgContext.drawPath(using: .stroke)
                
                
            }
            
        }
        if shape == "line" {
            context.cgContext.setStrokeColor(color.cgColor)
            context.cgContext.setLineWidth(radius)
            context.cgContext.setLineCap(.round)
            
            context.cgContext.move(to: CGPoint(x: x, y: y))
            context.cgContext.addLine(to: CGPoint(x: width, y: height))
            context.cgContext.drawPath(using: .stroke)
            
        }
    }
    
    func generate() -> URL {
        let data = self.pdf.pdfData { (context) in
            // 5
            context.beginPage()
            // 6
            self.elements.forEach{el in
                if el.type == "image" {
                    el.image!.draw(in: el.rect!)
                } else if el.type == "shape" {
                    self.drawShape(x: el.x, y: el.y, width: el.width!, height: el.height!, shape: el.shape!, color: el.color!, fill: el.fill, radius: el.radius,  context: context)
                    context.cgContext.setStrokeColor(UIColor.clear.cgColor)
                    context.cgContext.setFillColor(UIColor.clear.cgColor)
                } else if el.type == "newPage" {
                    context.beginPage()
                } else {
                    let pStyle = NSMutableParagraphStyle()
                    pStyle.alignment = el.alignment!
                    let attributes = [
                        NSAttributedString.Key.font: el.font!,
                        NSAttributedString.Key.foregroundColor: el.color!,
                        NSAttributedString.Key.paragraphStyle: pStyle
                    ]
                    el.text!.draw(in: CGRect(x: el.x, y: el.y, width: el.width ?? Int(self.pageWidth)-50, height: Int(self.pageHeight)-30), withAttributes: attributes)
//                    el.text!.draw(at: CGPoint(x: el.x, y: el.y), withAttributes: attributes)
                }
                
            }
        }
        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(title).pdf")
        else { fatalError("Destination URL not created") }
//        do{
//            try FileManager.default.createDirectory(atPath: outputURL.path, withIntermediateDirectories: true)
            
            PDFDocument(data: data)?.write(to: outputURL)
            
//        } catch {
//            print("Report not created")
//        }
        return outputURL
    }
}
