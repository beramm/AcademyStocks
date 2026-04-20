//
//  chartStock.swift
//  StocksAppCh2
//
//  Created by bram raiskay chandra on 15/04/26.
//

import Charts
import SwiftUI

struct Stock {
    var uuid: UUID = UUID()
    var month: String
    var price: Double
}

let stocks: [Stock] = [
    Stock(month: "Jan", price: 4400),
    Stock(month: "Feb", price: 4600),
    Stock(month: "Mar", price: 4200),
    Stock(month: "Apr", price: 4800),
    Stock(month: "May", price: 5000),
    Stock(month: "Jun", price: 4700),
    Stock(month: "Jul", price: 5300),
    Stock(month: "Aug", price: 5100),
    Stock(month: "Sep", price: 4900),
    Stock(month: "Oct", price: 5500),
    Stock(month: "Nov", price: 5800),
    Stock(month: "Dec", price: 6100),
]


struct chartStock: View {
    
    
    var chartColor: Color
    var width: CGFloat
    var height: CGFloat

    
    var body: some View {
        let minPrice = stocks.map { $0.price }.min() ?? 0
        let maxPrice = stocks.map { $0.price }.max() ?? 0
        let padding = (maxPrice - minPrice) * 0.1

        Chart(stocks.enumerated(), id: \.offset) { index, item in
            
            AreaMark(
                x: .value("Month", index),
                y: .value("Price", item.price)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [chartColor.opacity(0.3), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            LineMark(
                x: .value("Month", index),
                y: .value("Price", item.price)
            )
            .foregroundStyle(chartColor)
            .lineStyle(StrokeStyle(lineWidth: 3))

            RuleMark(
                y: .value("Threshold", stocks[0].price)
            ).foregroundStyle(chartColor.opacity(0.5))
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 2]))
        }
        .frame(width: width, height: height)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: (minPrice - padding)...(maxPrice + padding))
        .chartXScale(range: .plotDimension(padding: 0))
        .clipShape(Rectangle())
    }
}
