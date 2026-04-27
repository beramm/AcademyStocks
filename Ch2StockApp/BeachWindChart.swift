//
//  BeachChart.swift
//  Ch2StockApp
//
//  Created by Keira on 21/04/26.
//

import SwiftUI
import Charts

struct BeachWindChart: View {

    var chartColor: Color
    var width: CGFloat
    var height: CGFloat
    var currentHeight: Double
    var showAxis: Bool = true

    var Data: [BeachData]
    var currentHour: Double

    var isShowRuleMark: Bool = true

    @State private var dragHour: Double? = nil
    @State private var dragHeight: Double? = nil

    var body: some View {
        let minHeight = Data.map { $0.windSpeed }.min() ?? 0
        let maxHeight = Data.map { $0.windSpeed }.max() ?? 0
        let padding = (maxHeight - minHeight) * 0.1

        let activeHour: Double? = {
            if let dragHour { return dragHour }
            return isShowRuleMark ? currentHour : nil
        }()

        let activeHeight: Double? = {
            if let dragHeight { return dragHeight }
            return isShowRuleMark ? currentHeight : nil
        }()

        Chart(Data.enumerated(), id: \.offset) { index, item in

            AreaMark(
                x: .value("time", index),
                y: .value("height", item.windSpeed)
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
                y: .value("height", item.windSpeed)
            )
            .foregroundStyle(chartColor)
            .lineStyle(StrokeStyle(lineWidth: 3))

            if let activeHour, let activeHeight {
                RuleMark(
                    xStart: .value("start", activeHour),
                    xEnd: .value("end", 23),
                    y: .value("current", activeHeight)
                )
                .foregroundStyle(chartColor.opacity(0.5))
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 2]))

                RuleMark(
                    x: .value("time", activeHour),
                    yStart: .value("start", activeHeight),
                    yEnd: .value("end", minHeight - padding)
                )
                .foregroundStyle(chartColor.opacity(0.5))
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 2]))

                PointMark(
                    x: .value("time", activeHour),
                    y: .value("height", activeHeight)
                )
                .foregroundStyle(.clear)
                .annotation(position: .overlay) {
                    ZStack {
                        Circle().fill(chartColor.opacity(0.15)).frame(width: 16, height: 24)
                        Circle().fill(chartColor.opacity(0.25)).frame(width: 10, height: 16)
                        Circle().fill(chartColor).frame(width: 2, height: 8)
                    }
                }
            }

        }
        .frame(maxWidth: width, maxHeight: height)
        .chartXScale(domain: [0, 24])
        .chartYScale(domain: (minHeight - padding)...(maxHeight + padding))
        .chartPlotStyle { plotArea in
            plotArea.clipped()
        }
        .chartGesture { chart in
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if let hour: Double = chart.value(atX: value.location.x) {
                        let clampedHour = min(max(hour, 0), 23)
                        let index = Int(clampedHour.rounded())
                        let clampedIndex = min(max(index, 0), Data.count - 1)
                        dragHour = clampedHour
                        dragHeight = Data[clampedIndex].windSpeed
                    }
                }
                .onEnded { _ in
                    dragHour = nil
                    dragHeight = nil
                }
        }
        .chartXAxis(showAxis ? .automatic : .hidden)
        .chartYAxis(showAxis ? .automatic : .hidden)
    }
}


