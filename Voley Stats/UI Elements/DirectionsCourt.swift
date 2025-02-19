import SwiftUI

struct DirectionsCourt: View{
    @ObservedObject var viewModel: DirectionsCourtModel
    var rect: some View = Rectangle().fill(.orange)
    
    var body: some View{
        VStack{
            
            GeometryReader{size in
                let height = size.size.height-size.size.height*0.15
                let width = (height/2)
                let start = Int((size.size.width-width)/2)
                let starty = Int((height/2)+height*0.15)
                ZStack{
                    
                    VStack(spacing: 0){
                        HStack{
                            Rectangle().fill(viewModel.isServe ? .orange : .gray).onTapGesture {
                                if viewModel.isServe{
                                    viewModel.from = "1"
                                    viewModel.line.0 = (start+Int(width/6), Int(height*0.1))
                                }
                            }
                            Rectangle().fill(viewModel.isServe ? .orange : .gray).onTapGesture {
                                if viewModel.isServe{
                                    viewModel.from = "6"
                                    viewModel.line.0 = (start+Int(width/2), Int(height*0.1))
                                }
                            }
                            Rectangle().fill(viewModel.isServe ? .orange : .gray).onTapGesture {
                                if viewModel.isServe{
                                    viewModel.from = "5"
                                    viewModel.line.0 = (start+Int(width*5/6), Int(height*0.1))
                                }
                            }
                        }.frame(width: width, height: height*0.1)
                        ZStack(alignment: .top){
                            
                            VStack(spacing: 0){
                                HStack(spacing: 3){
                                    Rectangle().fill(viewModel.isServe ? .gray : .orange).onTapGesture {
                                        if !viewModel.isServe{
                                            viewModel.from = "1"
                                            viewModel.line.0 = (start+Int(width/6), Int(height/3))
                                        }
                                    }
                                    Rectangle().fill(viewModel.isServe ? .gray : .orange).onTapGesture {
                                        if !viewModel.isServe{
                                            viewModel.from = "6"
                                            viewModel.line.0 = (start+Int(width/2), Int(height/3))
                                        }
                                    }
                                    Rectangle().fill(viewModel.isServe ? .gray : .orange).onTapGesture {
                                        if !viewModel.isServe{
                                            viewModel.from = "5"
                                            viewModel.line.0 = (start+Int(width*5/6), Int(height/3))
                                        }
                                    }
                                }.frame(width: width,height: height/3)
                                HStack(spacing: 3){
                                    Rectangle().fill(viewModel.isServe ? .gray : .orange).onTapGesture {
                                        if !viewModel.isServe{
                                            viewModel.from = "2"
                                            viewModel.line.0 = (start+Int(width/6), Int(height/2)+Int(height*0.05))
                                        }
                                    }
                                    Rectangle().fill(viewModel.isServe ? .gray : .orange).onTapGesture {
                                        if !viewModel.isServe{
                                            viewModel.from = "3"
                                            viewModel.line.0 = (start+Int(width/2), Int(height/2)+Int(height*0.05))
                                        }
                                    }
                                    Rectangle().fill(viewModel.isServe ? .gray : .orange).onTapGesture {
                                        if !viewModel.isServe{
                                            viewModel.from = "4"
                                            viewModel.line.0 = (start+Int(width*5/6), Int(height/2)+Int(height*0.05))
                                        }
                                    }
                                }.frame(width: width,height: height/6)
                            }
//                            VStack{
                                Rectangle().stroke(.black, lineWidth: 7).frame(width: width, height: height/2)
                                Rectangle().stroke(.black, lineWidth: 7).frame(width: width, height: height/3)
//                            }
                        }//.padding(.bottom)
                            
                        let rows = [[4,3,2],[7,8,9],[5,6,1]]
                        ZStack(alignment: .bottom){
                            VStack(spacing: 0){
                                ForEach(Array(zip(rows.indices, rows)), id:\.0){idy, row in
                                    HStack(spacing: 3){
                                        let rowy = starty + (idy*Int(height/6))
                                        ForEach(Array(zip(row.indices, row)), id:\.0){idx, pos in
                                            let colx = start + (idx*Int(width/3))
                                            VStack(spacing: 3){
                                                HStack(spacing: 3){
                                                    rect.overlay{Text("A").foregroundStyle(.white)}.onTapGesture {
                                                        viewModel.to = "\(pos)A"
                                                        viewModel.line.1 = (colx+Int(width/12), rowy+Int(height/24))
                                                    }
                                                    rect.overlay{Text("B").foregroundStyle(.white)}.onTapGesture {
                                                        viewModel.to = "\(pos)B"
                                                        viewModel.line.1 = (colx+Int(width/4), rowy+Int(height/24))
                                                    }
                                                }
                                                HStack(spacing: 3){
                                                    rect.overlay{Text("D").foregroundStyle(.white)}.onTapGesture {
                                                        viewModel.to = "\(pos)D"
                                                        viewModel.line.1 = (colx+Int(width/12), rowy+Int(height/8))
                                                    }
                                                    rect.overlay{Text("C").foregroundStyle(.white)}.onTapGesture {
                                                        viewModel.to = "\(pos)C"
                                                        viewModel.line.1 = (colx+Int(width/4), rowy+Int(height/8))
                                                    }
                                                }
                                            }.overlay{Text("\(pos)").font(.title2).foregroundStyle(.white)}
                                        }
                                    }.frame(width: width,height: height/6)
                                }
                            }
                            Rectangle().stroke(.black, lineWidth: 3).frame(width: width, height: height/6)
                            Rectangle().stroke(.black, lineWidth: 7).frame(width: width, height: height/2)
                            Rectangle().stroke(.black, lineWidth: 7).frame(width: width, height: height/3)
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)//.background(.red)
                    
                        Path{path in
                            path.move(to: CGPoint(x: viewModel.line.0.0, y: viewModel.line.0.1))
                            path.addLine(to: CGPoint(x: viewModel.line.1.0, y: viewModel.line.1.1))
                        }.stroke(viewModel.drawLine() ? .red : .clear, lineWidth: 5)
                    
                }
                //            .clipped()
                //            .frame(maxWidth: .infinity, alignment: .center)
                //                .clipShape(RoundedRectangle(cornerRadius: 8))
                //                .frame(maxWidth: size.size.width, maxHeight: size.size.height)
            }
        }.frame(maxWidth: .infinity)
        
    }
}

class DirectionsCourtModel: ObservableObject{
    @Binding var direction: String
    var numberPlayers: Int = 6
    var isServe: Bool = true
    var from: String = ""
    var to: String = ""
    @Published var line:((Int, Int), (Int, Int)) = ((0,0), (0,0))
    
    init(direction: Binding<String>, isServe: Bool, numberPlayers: Int){
        self._direction = direction
        
        self.isServe = isServe
        self.numberPlayers = numberPlayers
        if (self.direction != ""){
            let pos = self.direction.split(separator: "#")
            self.from = String(pos[0])
            self.to = String(pos[1])
        }
    }
    
    func drawLine()->Bool{
        if from != "" && to != ""{
            self.direction = "\(from)#\(to)"
            return true
        }
        return false
    }
}

//struct Court_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        DirectionsCourt(viewModel: DirectionsCourtModel())
//    }
//}
