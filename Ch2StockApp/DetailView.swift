//
//  DetailView.swift
//  Ch2StockApp
//
//  Created by Keira on 21/04/26.
//

import Charts
import Foundation
import SwiftUI

struct DetailView: View {
    var beach: Beach
    var item: [BeachData]
    @State private var currDate: Date = Calendar.current.startOfDay(for: .now)
    @State var isShowRuleMarker: Bool = true
    
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

    var currentSpeed: Double {
        let calendar = Calendar.current
        let now = Date.now
        let currentHour = calendar.component(.hour, from: now)

        let match = item.first { entry in
            guard let entryDate = parseDate(entry.time) else { return false }
            return calendar.isDateInToday(entryDate)
                && calendar.component(.hour, from: entryDate) == currentHour
        }

        return match?.windSpeed ?? 0.0
    }

    var activeWaterTemp: Int {
        let filtered = filterBeachData(item, for: currDate)

        if let entry = dataForHour(sharedDragHour, in: filtered) {
            return Int(entry.waterTemp)
        }

        let currentHour = Double(Calendar.current.component(.hour, from: .now))
        if let entry = dataForHour(currentHour, in: filtered) {
            return Int(entry.waterTemp)
        }

        return 0
    }

    var activeAirTemp: Int {
        let filtered = filterBeachData(item, for: currDate)

        if let entry = dataForHour(sharedDragHour, in: filtered) {
            return Int(entry.airTemp)
        }

        let currentHour = Double(Calendar.current.component(.hour, from: .now))
        if let entry = dataForHour(currentHour, in: filtered) {
            return Int(entry.airTemp)
        }

        return 0
    }
    
    func dataForHour(_ hour: Double?, in data: [BeachData]) -> BeachData? {
        guard let hour else { return nil }
        
        let index = Int(hour.rounded())
        let clampedIndex = min(max(index, 0), data.count - 1)
        
        return data[clampedIndex]
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
        let minwvaeHeight =
            filterBeachData(item, for: currDate).map { $0.wave }.min() ?? 0
        let maxwaveHeight =
            filterBeachData(item, for: currDate).map { $0.wave }.max() ?? 0

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let tomorrow =
            calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let afterTomorrow =
            calendar.date(byAdding: .day, value: 2, to: today) ?? today
        let isToday = Calendar.current.isDateInToday(currDate)
        
        
        
        ZStack(alignment: .topLeading) {
            VStack {
                Image("PadangBeach")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                Spacer()
                Spacer()
            }
            Image("gradient")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()

            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .black.opacity(0.0), location: 0.0),
                    .init(color: .black.opacity(0.0), location: 0.25),
                    .init(color: .black.opacity(1.0), location: 0.4),
                    .init(color: .black.opacity(1.0), location: 0.85),
                    .init(color: .black.opacity(1.0), location: 1.0),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {

                ZStack {
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .black.opacity(0.0), location: 0.0),
                            .init(color: .black.opacity(0.0), location: 0.25),
                            .init(color: .black.opacity(1.0), location: 0.4),
                            .init(color: .black.opacity(1.0), location: 0.85),
                            .init(color: .black.opacity(1.0), location: 1.0),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(beach.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(beach.address)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text(
                                "\(minwvaeHeight, specifier: "%.2f") - \(maxwaveHeight, specifier: "%.2f") M"
                            )
                            .font(Font.title.bold())
                        }

                        HStack {
                            Button {
                                currDate = today
                                isShowRuleMarker = true
                            } label: {
                                Text("Today").bold(true)
                            }.foregroundStyle(Color(.white)).bold(true)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            Color(
                                                red: 239 / 255,
                                                green: 107 / 255,
                                                blue: 13 / 255
                                            )
                                        )
                                )
                                .opacity(
                                    calendar.isDate(
                                        currDate,
                                        inSameDayAs: today
                                    ) ? 1.0 : 0.4
                                )

                            Button {
                                currDate = tomorrow
                                isShowRuleMarker = false
                            } label: {
                                Text("Tomorrow").bold(true)
                            }.foregroundStyle(Color(.white)).bold(true)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            Color(
                                                red: 239 / 255,
                                                green: 107 / 255,
                                                blue: 13 / 255
                                            )
                                        )
                                )
                                .opacity(
                                    calendar.isDate(
                                        currDate,
                                        inSameDayAs: tomorrow
                                    ) ? 1.0 : 0.41
                                )

                            Button {
                                currDate = afterTomorrow
                                isShowRuleMarker = false
                            } label: {
                                Text(
                                    afterTomorrow.formatted(
                                        .dateTime.month(.wide).day()
                                    )
                                ).bold(true)
                            }.foregroundStyle(Color(.white)).bold(true)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            Color(
                                                red: 239 / 255,
                                                green: 107 / 255,
                                                blue: 13 / 255
                                            )
                                        )
                                )
                                .opacity(
                                    calendar.isDate(
                                        currDate,
                                        inSameDayAs: afterTomorrow
                                    ) ? 1.0 : 0.41
                                )

                        }

                        HStack {

                            ZStack {
                                RoundedRectangle(cornerRadius: 11)
                                    .fill(
                                        Color(
                                            red: 0.22,
                                            green: 0.10,
                                            blue: 0.02
                                        )
                                    )
                                    .frame(width: .infinity, height: 150)
                                VStack(alignment: .leading) {

                                    HStack(alignment: .top) {
                                        Image(systemName: "water.waves")
                                            .font(Font.largeTitle.bold())

                                        VStack(alignment: .leading) {
                                            Text("Water")

                                            Text("Temperature")
                                                
                                        }
                                    }
                                    
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 2, trailing: 8))
                                    
                                    Text(
                                        "\(activeWaterTemp)° C"
                                    ).font(.system(size: 42) .bold())
                                        .frame(maxWidth: .infinity, alignment: .center)

                                }
                                

                                .foregroundStyle(
                                    Color(
                                        red: 239 / 255,
                                        green: 107 / 255,
                                        blue: 13 / 255
                                    )
                                )
                                .fontWeight(Font.Weight.heavy)

                            }


                            ZStack {
                                RoundedRectangle(cornerRadius: 11)
                                    .fill(
                                        Color(
                                            red: 0.22,
                                            green: 0.10,
                                            blue: 0.02
                                        )
                                    )
                                    .frame(width: .infinity, height: 150)
                                VStack(alignment: .leading) {

                                    HStack(alignment: .top) {
                                        Image(systemName: "wind")
                                            .font(Font.largeTitle.bold())

                                        VStack(alignment: .leading) {
                                            Text("Air")

                                            Text("Temperature")
                                                
                                        }
                                    }
                                    
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 2, trailing: 8))
                                    
                                    Text(
                                        "\(activeAirTemp)° C"
                                    ).font(.system(size: 42) .bold())
                                        .frame(maxWidth: .infinity, alignment: .center)

                                }
                                

                                .foregroundStyle(
                                    Color(
                                        red: 239 / 255,
                                        green: 107 / 255,
                                        blue: 13 / 255
                                    )
                                )
                                .fontWeight(Font.Weight.heavy)

                            }
                        }

                        Spacer(minLength: 25)

                        VStack(alignment: .leading) {
                            Text("WAVE HEIGHT")
                                .font(Font.title3.bold())
                            BeachChart(
                                chartColor: (Color(
                                    red: 239 / 255,
                                    green: 107 / 255,
                                    blue: 13 / 255
                                )),
                                width: 350,
                                height: 150,
                                currentHeight: currentWaveHeight,
                                Data: filterBeachData(item, for: currDate),
                                currentHour: Double(
                                    Calendar.current.component(
                                        .hour,
                                        from: .now
                                    )
                                ),
                                isShowRuleMark: isToday,
                                dragHour: $sharedDragHour,
                            )
                        }

                        Spacer(minLength: 25)
                        VStack(alignment: .leading) {
                            Text("WIND SPEED")
                                .font(Font.title3.bold())
                            BeachWindChart(
                                chartColor: (Color(.blue)),
                                width: 350,
                                height: 150,
                                currentHeight: currentSpeed,
                                Data: filterBeachData(item, for: currDate),
                                currentHour: Double(
                                    Calendar.current.component(
                                        .hour,
                                        from: .now
                                    )
                                ),
                                isShowRuleMark: isShowRuleMarker,
                                dragHour: $sharedDragHour,

                                
                            )
                        }

                        Spacer(minLength: 25)
                        VStack(alignment: .leading) {
                            Text("WIND SPEED")
                                .font(Font.title3.bold())
                            BeachWindChart(
                                chartColor: (Color(.blue)),
                                width: 350,
                                height: 150,
                                currentHeight: currentSpeed,
                                Data: filterBeachData(item, for: currDate),
                                currentHour: Double(
                                    Calendar.current.component(
                                        .hour,
                                        from: .now
                                    )
                                ),
                                isShowRuleMark: isShowRuleMarker,
                                dragHour: $sharedDragHour,
                            )
                        }
                    }
                    .padding(.top, 200)
                    .padding(.horizontal)
                    //                .background(Color(.black))

                }

            }

        }

    }
}
