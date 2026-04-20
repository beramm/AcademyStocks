//
//  ContentView.swift
//  StocksAppCh2
//
//  Created by Keira on 15/04/26.
//

import Charts
import SwiftUI


struct stockItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    var company: String
    var currentPrice: Double
    var difference: Double
}

let sampleData: [stockItem] = [
    stockItem(name: "Dow Jones", company: "Dow Jones Industrial Average", currentPrice: 48000, difference: 237,),
    stockItem(name: "GE", company: "GE Aerospace", currentPrice: 2800, difference: -10),
    stockItem(name: "HD", company: "The Home Depot, Inc.", currentPrice: 337.15, difference: -1.76),
    stockItem(name: "BRK-B", company: "Berkshire Hathaway Inc.", currentPrice: 475.12, difference: 1.03),
]




struct ContentView: View {

    @State private var selectedOption: WatchlistOption = .manual
    @State private var selectedSort: orderlistOption = .Ascending
    @State private var selectedShow: showListOption = .PriceChange

    var body: some View {
        NavigationStack {

            List {
                Menu {
                    Button("My Symbols") {}
                    Divider()
                    Button(
                        "Manage Watchlist",
                        systemImage: "slider.horizontal.3"
                    ) {}
                    Button("New Watchlist", systemImage: "plus") {}
                } label: {
                    HStack(spacing: 4) {
                        Text("My Symbols").bold().font(.title3)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption2.weight(.heavy))
                    }
                    .font(.subheadline.bold())
                }
                .foregroundStyle(.primary)
                .padding(.horizontal)
                .padding(.top)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                ForEach(sampleData) { data in

                    StockListItem(name: data.name, company: data.company, currentPrice: data.currentPrice, difference: data.difference)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                            } label: {
                                Label(
                                    "Share",
                                    systemImage: "square.and.arrow.up"
                                )
                            }
                            .tint(.orange)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                            } label: {
                                Label(
                                    "Lists",
                                    systemImage: "list.bullet"
                                )
                            }
                            .tint(.blue)
                        }
                        .contextMenu {
                            Button(
                                "Share Symbol",
                                systemImage: "square.and.arrow.up"
                            ) {}
                            Button("Copy Link", systemImage: "link") {}
                            Button(
                                "Manage Symbol",
                                systemImage: "list.bullet",
                            ) {}
                        } preview: {

                            HStack {
                                Text("Dow Jones")
                            }
                            .frame(width: 400)
                        }

                }
            }
            .listStyle(.plain)

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Stocks")

                        Text(Date.now, format: .dateTime.day().month(.wide))
                            .font(.title2.bold())
                            .foregroundStyle(.secondary)
                    }
                    .font(.title)
                    .bold()
                    .fixedSize()
                }
                .sharedBackgroundVisibility(.hidden)

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }

                    MenuSort(
                        selectedOption: $selectedOption,
                        sortOption: $selectedSort,
                        showOption: $selectedShow
                    )

                }
            }
        }

    }
}

#Preview {
    ContentView()
}
