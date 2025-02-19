import SwiftUI
import Charts

struct LineChartView: View {
    var title: String
    var dataPoints: [(Color, [(String, Double)], String)]
//    var labels: [String]
//  var lineColor: Color = .red
//  var outerCircleColor: Color = .red
//  var innerCircleColor: Color = .white
//    var highestPoint: Double {
//        let max = dataPoints.flatMap{$0.1}.max() ?? 1.0
//      if max == 0 { return 1.0 }
//      return max
//    }
  var body: some View {
      VStack{
          Text(title.trad()).font(.headline).padding(.vertical)
          Divider().overlay(.white.opacity(0.6))
          if (dataPoints.reduce(0){ $0 + $1.1.count}) != 0{
              Chart{
                  ForEach(dataPoints, id:\.0){dp in
                      ForEach(dp.1, id: \.0){point in
                          LineMark(x: .value("Date", point.0), y: .value("Data", point.1), series: .value(dp.2, dp.2.trad()))
                              .foregroundStyle(dp.0)
                      }
                  }
              }.padding()
              Divider()
              HStack{
                  
                  ForEach(dataPoints, id:\.0){data in
                      HStack{
                          Circle().fill(data.0).frame(width: 15, height: 15)
                          Text(data.2.trad())
                      }.padding(.horizontal)
                  }
                  
              }.padding(.vertical)
          }else{
              EmptyState(icon: Image(systemName: "chart.bar.fill"), msg: "no.data.filters".trad(), width: 50, button:{EmptyView()})
          }
      }
        .padding(4)
          .background(Color.white.opacity(0.1).cornerRadius(15))
          .padding()
  }
}

