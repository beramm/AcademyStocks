//
//  MenuSort.swift
//  StocksAppCh2
//
//  Created by bram raiskay chandra on 16/04/26.
//

import SwiftUI

enum WatchlistOption: Int, CaseIterable {
    case manual = 1
    case priceChange, percentageChange, marketCap, symbol, name

    var title: String {
        switch self {
        case .manual: return "Manual"
        case .priceChange: return "Price Change"
        case .percentageChange: return "Percentage Change"
        case .marketCap: return "Market Cap"
        case .symbol: return "Symbol"
        case .name: return "Name"
        }
    }
}

enum orderlistOption: Int, CaseIterable {
    case Ascending = 1
    case Descending

    var title: String {
        switch self {
        case .Ascending: return "Ascending"
        case .Descending: return "Descending"
        }
    }
}

enum showListOption: Int, CaseIterable {
    case PriceChange = 1
    case PercentageChange, MarketCap

    var title: String {
        switch self {
        case .PriceChange: return "Price Change"
        case .PercentageChange: return "Percentage Change"
        case .MarketCap: return "Market Cap"
        }
    }

}

struct MenuSort: View {

    @Binding var selectedOption: WatchlistOption
    @Binding var sortOption: orderlistOption
    @Binding var showOption: showListOption


    @State private var isCurrencyEnabled = false

    var body: some View {
        Menu {
            Button(
                "Edit Watchlist",
                systemImage: "pencil"
            ) {}
            Button(
                "New Watchlist",
                systemImage: "plus"
            ) {}

            Divider()

            Menu {
                Picker("Sort Watchlist", selection: $selectedOption) {
                    ForEach(WatchlistOption.allCases, id: \.self) { option in
                        Text(option.title).tag(option)
                    }
                }

                Divider()

                Picker("Sort Option", selection: $sortOption) {
                    ForEach(orderlistOption.allCases, id: \.self) { option in
                        Text(option.title).tag(option)
                    }
                }

            } label: {

                Text("Sort Watchlist By")
                Text(selectedOption.title)
                Image(systemName: "arrow.up.arrow.down")

            }

            Menu {
                Picker("Watchlist Shows", selection: $showOption) {
                    ForEach(showListOption.allCases, id: \.self) { option in
                        Text(option.title).tag(option)
                    }
                }
                Divider()
                Button {
                    isCurrencyEnabled.toggle()
                } label: {
                    HStack {
                        if isCurrencyEnabled {
                            Image(systemName: "checkmark")
                        }
                        Text("Currency")
                    }
                }
            } label: {
                Text("Watchlist Shows")
                Text(showOption.title)
                Image(systemName: "arrow.up.arrow.down")

            }

            Divider()
            
            Button(
                "Provide Stocks Feedback",
                systemImage: "exclamationmark.bubble"
            ) {}
            
            Button(
                "Clear Recommendations Data",
            ) {}

        } label: {
            Image(systemName: "ellipsis")
        }

    }
}
