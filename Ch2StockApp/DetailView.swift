//
//  DetailView.swift
//  Ch2StockApp
//
//  Created by Keira on 21/04/26.
//

import SwiftUI
import Charts
import Foundation


let exampleData: [BeachData] = mockPadangPadangData

struct DetailView: View {
    var beach: Beach
    var item: BeachData
    @State private var currDate: Date = Calendar.current.startOfDay(for: .now)
    @State var isShowRuleMarker: Bool = true

    
    var currentWaveHeight: Double {
        let calendar = Calendar.current
        let now = Date.now
        let currentHour = calendar.component(.hour, from: now)
        
        let match = mockPadangPadangData.first { entry in
            guard let entryDate = parseDate(entry.time) else { return false }
            return calendar.isDateInToday(entryDate) &&
                   calendar.component(.hour, from: entryDate) == currentHour
        }
        
        return match?.wave ?? 0.0
    }

    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: string)
    }
    
    func dayRange(for date: Date, calendar: Calendar = .current) -> (start: Date, end: Date) {
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
            guard let entryDate = Self.formatterDate.date(from: entry.time) else { return false }
            return entryDate >= start && entryDate < end
        }
    }


    var body: some View {
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let afterTomorrow = calendar.date(byAdding: .day, value: 2, to: today) ?? today

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
                    VStack(alignment: .trailing) {
                        
                    }
                }

                HStack {
                    Button {
                        currDate=today
                        isShowRuleMarker=true
                    } label: {
                        Text("Today").bold(true)
                    }.foregroundStyle(Color(.white)).bold(true)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 239/255, green:107/255, blue:13/255))
                        )
                        .opacity(calendar.isDate(currDate, inSameDayAs: today) ? 1.0 : 0.4)

                    
                    Button {
                        currDate=tomorrow
                        isShowRuleMarker=false
                    } label: {
                        Text("Tomorrow").bold(true)
                    }.foregroundStyle(Color(.white)).bold(true)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 239/255, green:107/255, blue:13/255))
                        )
                        .opacity(calendar.isDate(currDate, inSameDayAs: tomorrow) ? 1.0 : 0.41)
                    

                    Button {
                        currDate=afterTomorrow
                        isShowRuleMarker=false
                    } label: {
                        Text(afterTomorrow.formatted(.dateTime.month(.wide).day())).bold(true)
                    }.foregroundStyle(Color(.white)).bold(true)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 239/255, green:107/255, blue:13/255))
                        )
                        .opacity(calendar.isDate(currDate, inSameDayAs: afterTomorrow) ? 1.0 : 0.41)
                    

                }

                HStack {

                    Text("Hello from card")
                        .foregroundColor(.orange)
                        .padding(16)
                        .frame(maxWidth: 200, maxHeight: 100)
                        .background(Color(red: 0.22, green: 0.10, blue: 0.02))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(beach.name)
                        .foregroundColor(.orange)
                        .padding(16)
                        .frame(maxWidth: 200, maxHeight: 100)
                        .background(Color(red: 0.22, green: 0.10, blue: 0.02))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                VStack{
                    Text("Hello from card")
                }
                BeachChart(chartColor: (Color(red: 239/255, green:107/255, blue:13/255)), width: 350, height: 150, currentHeight: currentWaveHeight,Data: filterBeachData(mockPadangPadangData, for: currDate),currentHour: Double(Calendar.current.component(.hour, from: .now)),isShowRuleMark: isShowRuleMarker)
                
            }
            .padding(.top, 200)
            .padding(.horizontal)
        }

    }
}

#Preview {
    DetailView(
        beach: mockBeaches[0],
        item: mockPadangPadangData[0]
    )
}
