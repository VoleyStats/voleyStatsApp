//
//  RadarChart.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 15/12/23.
//

import SwiftUI

struct RadarChart: Shape{
    var maxValue: Int
    @Binding var dataPoints: [(String, Float)]
    func path(in rect: CGRect)-> Path {
            // ensure we have at least two corners, otherwise send back an empty path
            guard dataPoints.count >= 2 else { return Path() }

            // draw from the center of our rectangle
            let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

            // start from directly upwards (as opposed to down or to the right)
            var currentAngle = -CGFloat.pi / 2

            // calculate how much we need to move with each star corner
            let angleAdjustment = .pi * 2 / Double(dataPoints.count )

            // figure out how much we need to move X/Y for the inner points of the star
    //        let innerX = center.x
    //        let innerY = center.y

            // we're ready to start with our path now
            var path = Path()

            // move to our initial position
            
        
            // track the lowest point we draw to, so we can center later
            var bottomEdge: Double = 0

            // loop over all our points/inner points
        for i in 0..<dataPoints.count  {
                // figure out the location of this point
            let dp = dataPoints[i]
                let sinAngle = sin(currentAngle)
                let cosAngle = cos(currentAngle)
                let bottom: Double
            let diffX = ((CGFloat(dp.1) * rect.width)/CGFloat(maxValue))/rect.width
            let diffY = ((CGFloat(dp.1) * rect.height)/CGFloat(maxValue))/rect.height
                
                // if we're a multiple of 2 we are drawing the outer edge of the star
    //            if corner.isMultiple(of: 2) {
                    // store this Y position
                bottom = (center.y*CGFloat(diffY)) * sinAngle

                    // …and add a line to there
            if i == 0{
                path.move(to: CGPoint(x: center.x*cosAngle, y: bottom))
            }else{
                path.addLine(to: CGPoint(x: (center.x*CGFloat(diffX)) * cosAngle, y: bottom))
            }
    //            } else {
    //                // we're not a multiple of 2, which means we're drawing an inner point
    //
    //                // store this Y position
    //                bottom = innerY * sinAngle
    //
    //                // …and add a line to there
    //                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
    //            }

                // if this new bottom point is our lowest, stash it away for later
                if bottom > bottomEdge {
                    bottomEdge = bottom
                }

                // move on to the next corner
                currentAngle += angleAdjustment
            }

            // figure out how much unused space we have at the bottom of our drawing rectangle
        let unusedSpace = (rect.height / bottomEdge) / 2

            // create and apply a transform that moves our path down by that amount, centering the shape vertically
            let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
            return path.applying(transform)
        }
}

struct RadarChartView: View{
    var maxValue: Int
    @Binding var dataPoints: [(String, Float)]
    var size: Int
    init(maxValue: Int, dataPoints: Binding<[(String, Float)]>, size: Int){
        self.maxValue = maxValue
        self.size = size - 100
        self._dataPoints = dataPoints
        
//        print(dataPoints.wrappedValue)
    }
    var body: some View{
        ZStack{
            let reduce:Int = size/maxValue
            let dp = self.dataPoints
            GeometryReader{geo in
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)

                // start from directly upwards (as opposed to down or to the right)
                var currentAngle = -CGFloat.pi / 2

                // calculate how much we need to move with each star corner
                let angleAdjustment = .pi * 2 / Double(dp.count )
                ForEach( 0..<self.dataPoints.count, id:\.self ) {i in
                        // figure out the location of this point
                    let dp = self.dataPoints[i]
                        let sinAngle = sin(currentAngle+(angleAdjustment*Double(i)))
                        let cosAngle = cos(currentAngle+(angleAdjustment*Double(i)))
                    Text("\(dp.0)").position(CGPoint(x: (center.x*cosAngle)+center.x, y: (center.y * sinAngle)+center.y))
                        
                    }
            }.padding()
            ForEach(0..<maxValue, id:\.self){i in
                Polygon(corners: self.dataPoints.count > 0 ? self.dataPoints.count : 5).stroke(.white, lineWidth: i == 0 ? 3 : 1).frame(width: CGFloat(size-(reduce*i)), height: CGFloat(size-(reduce*i)))
            }
            Circle().fill(.white).frame(width: 5, height: 5)
            RadarChart(maxValue: maxValue, dataPoints: self.$dataPoints).fill(.cyan.opacity(0.6)).frame(width: CGFloat(size), height: CGFloat(size))
        }
    }
}
