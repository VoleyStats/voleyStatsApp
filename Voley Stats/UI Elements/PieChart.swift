import SwiftUI

struct PieChart: View{
    var title: String
    var total: Int
    var error: Int
    var earned: Int
    var size: CGFloat
    var action:(()->Void)? = nil
    var body: some View{
//        ZStack{
//            RoundedRectangle(cornerRadius: 15, style: .continuous).fill(.white.opacity(0.1)).frame(maxWidth: size*1.5, minHeight: size*2).padding()
            VStack{
                if action != nil{
                    Image(systemName: "arrow.up.left.and.arrow.down.right.circle").font(.title2).frame(maxWidth: size*1.1, alignment: .trailing).padding(.horizontal).onTapGesture {
                        action!()
                    }
                }
                VStack{
                    if total != 0{
                        ZStack{
                            Circle().stroke(.gray.opacity(0.3), style: StrokeStyle(lineWidth: size/10, lineCap: .round, lineJoin: .round))
                            //
                            if (total > 0){
                                let errorP = Double((error*100)/total)/100
                                Circle().trim(from: 0, to: errorP)
                                    .stroke(.red, style: StrokeStyle(lineWidth: size/10, lineCap: .round, lineJoin: .round)).rotationEffect(.init(degrees: -90)).shadow(color: .red, radius: 5, x: 0.0, y: 0.0)
                                
                                let earnP = Double((earned*100)/total)/100
                                Circle().trim(from: errorP, to: errorP
                                              + earnP)
                                .stroke(.green, style: StrokeStyle(lineWidth: size/10, lineCap: .round, lineJoin: .round)).rotationEffect(.init(degrees: -90)).shadow(color: .green, radius: 5, x: 0.0, y: 0.0)
                                
                            }
                            VStack{
                                Text("\(earned) / \(total)").foregroundColor(.green)
                                Text("\(error) / \(total)").foregroundColor(.red)
                                Text("\(total - earned - error) / \(total)")
                            }
                            //round to two decimals
                            //                    Text("\(String(format: "%.2f", percentage*100))%").font(.headline)
                        }
                        .frame(maxHeight: size)
                        .padding()
                    }else{
                        EmptyState(icon: Image(systemName: "chart.bar.fill"), msg: "no.data.filters".trad(), width: 50, button:{EmptyView()}).frame(maxHeight: size)
                    }
                }.frame(maxHeight: .infinity)
                Divider().overlay(.white.opacity(0.6)).padding(.horizontal)
                Text(title).font(.headline).frame(maxWidth: .infinity, alignment: .center).padding().multilineTextAlignment(.center)
            }.foregroundColor(.white).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: size*1.5, minHeight: size*2).padding()
//        }.clipped()
    }
}
