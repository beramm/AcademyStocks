//
//  Stock.swift
//  StocksAppCh2
//
//  Created by bram raiskay chandra on 16/04/26.
//

import SwiftUI

struct BeachListItem: View {
    var name: String
    var address: String
    var item: [BeachData]
    @State private var currDate: Date = Calendar.current.startOfDay(for: .now)
    @State private var sharedDragHour: Double? = nil
    @State private var sharedWaveHeight: Double? = nil
    @State private var sharedWindSpeed: Double? = nil

    var currentWaveHeight: Double {
        let calendar = Calendar.current
        let now = Date.now
        let currentHour = calendar.component(.hour, from: now)

        let match = item.first { entry in
            guard let entryDate = parseDate(entry.time) else { return false }
            return calendar.isDateInToday(entryDate)
                && calendar.component(.hour, from: entryDate) == currentHour
        }

        return match?.wave ?? 0.0
    }

    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: string)
    }

    func dayRange(for date: Date, calendar: Calendar = .current) -> (
        start: Date, end: Date
    ) {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        return (start, end)
    }

    private static let formatterDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    func filterBeachData(_ data: [BeachData], for date: Date) -> [BeachData] {
        let (start, end) = dayRange(for: date)
        return data.filter { entry in
            guard let entryDate = Self.formatterDate.date(from: entry.time)
            else { return false }
            return entryDate >= start && entryDate < end
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .bold()
                Text(address)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            Spacer()

            BeachChart(
                chartColor: (Color(
                    red: 239 / 255,
                    green: 107 / 255,
                    blue: 13 / 255
                )),
                width: 120,
                height: 50,
                currentHeight: currentWaveHeight,
                showAxis: false,
                Data: filterBeachData(item, for: currDate),
                currentHour: Double(
                    Calendar.current.component(.hour, from: .now)
                ),
                isShowRuleMark: false,
                dragHour: $sharedDragHour,
            )

            //            if difference < 0 {
            //                chartStock(chartColor: Color.red, width: 60, height: 40)
            //            }else{
            //                chartStock(chartColor: Color.green, width: 60, height: 40)
            //            }
            VStack(alignment: .trailing) {
                Text("\(currentWaveHeight, specifier: "%.2f") m")

            }
        }
        //        .padding()
    }
}
