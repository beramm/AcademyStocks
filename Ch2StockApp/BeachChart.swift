//
//  BeachChart.swift
//  Ch2StockApp
//
//  Created by Keira on 21/04/26.
//
import SwiftUI
import Charts

struct BeachChart: View {
    
    var chartColor: Color
    var width: CGFloat
    var height: CGFloat
    var currentHeight: Double
    
    var Data : [BeachData]
    var currentHour: Double
    
    var isShowRuleMark: Bool = true
    

    
    
    
    
    
    
    var body: some View {
        let minHeight = Data.map { $0.wave }.min() ?? 0
        let maxHeight = Data.map { $0.wave }.max() ?? 0
        let padding = (maxHeight - minHeight) * 0.1

        Chart(Data.enumerated(), id: \.offset) { index, item in
            
            AreaMark(
                x: .value("time", index),
                y: .value("height", item.wave)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [chartColor.opacity(0.3), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            LineMark(
                x: .value("time", index),
                y: .value("height", item.wave)
            )
            .foregroundStyle(chartColor)
            .lineStyle(StrokeStyle(lineWidth: 3))
            
            
            RuleMark(
                xStart: .value("start", currentHour),
                xEnd: .value("end", 23),
                y: .value("current", currentHeight)
            )
            .foregroundStyle(chartColor.opacity(isShowRuleMark ? 0.5 : 0.0))
            .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 2]))
            

            RuleMark(
                x: .value("time", currentHour),
                yStart: .value("start", currentHeight),
                yEnd: .value("end", minHeight - padding)
            )
            .foregroundStyle(chartColor.opacity(isShowRuleMark ? 0.5 : 0.0))
            .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 2]))

        }
        .frame(maxWidth: width, maxHeight: height)
        .chartXScale(domain: [0, 24])
        .chartYScale(domain: (minHeight - padding)...(maxHeight + padding))
        .clipShape(Rectangle())
    }
}
