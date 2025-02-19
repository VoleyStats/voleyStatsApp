import SwiftUI

struct CircleGraph: View{
    var title: String
    var percentage: Double
    var color: Color
    var size: CGFloat
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 15, style: .continuous).fill(.white.opacity(0.1)).frame(maxWidth: size*1.5, minHeight: size*2).padding()
            VStack(alignment: .center){
                if percentage != 0 {
                    ZStack{
                        Circle().stroke(.gray.opacity(0.3), style: StrokeStyle(lineWidth: size/10, lineCap: .round, lineJoin: .round))
                        Circle().trim(from: 0, to: percentage)
                            .stroke(getColor(), style: StrokeStyle(lineWidth: size/10, lineCap: .round, lineJoin: .round)).rotationEffect(.init(degrees: -90)).shadow(color: getColor(), radius: 5, x: 0.0, y: 0.0)
                        //round to two decimals
                        Text("\(String(format: "%.2f", percentage*100))%").font(.headline)
                    }
                    .frame(maxHeight: size)
                    .padding()
                } else {
                    EmptyState(icon: Image(systemName: "chart.bar.fill"), msg: "no.data.filters".trad(), width: 80, button:{EmptyView()}).frame(maxHeight: size)
                }
                Text(title).font(.headline).frame(maxWidth: size*1.1, alignment: .center).padding(.horizontal).multilineTextAlignment(.center)
            }
        }
    }
    func getColor() -> Color {
        if percentage < 0.25 {
            return .red
        } else if percentage > 0.5 {
            return .green
        } else {
            return .yellow
        }
    }
}

//struct CircleGraph_Previews: PreviewProvider {
//    static var previews: some View {
//        CircleGraph(title: "Example very long title", percentage: 0.63, color: .blue, size: 90)
//    }
//}
