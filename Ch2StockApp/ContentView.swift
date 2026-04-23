//
//  ContentView.swift
//  StocksAppCh2
//
//  Created by Keira on 15/04/26.
//

import Charts
import Foundation
import SwiftUI

struct stockItem: Identifiable {
    var id: UUID = UUID()
    var beachId: Int
    var name: String
    var company: String //wave
    var currentPrice: Double //water temp
    var difference: Double //air temp
}

let sampleData: [stockItem] = [
    stockItem(
        beachId: 1,
        name: "Padang Padang",
        company: "Pecatu SouthKuta",
        currentPrice: 48000,
        difference: 237,
    ),
    stockItem(
        beachId: 2,
        name: "Kuta",
        company: "Pecatu SouthKuta",
        currentPrice: 2800,
        difference: -10
    ),
    stockItem(
        beachId: 3,
        name: "Balangan",
        company: "Pecatu SouthKuta",
        currentPrice: 475.12,
        difference: 1.03
    ),
    stockItem(
        beachId: 4,
        name: "Dreamland",
        company: "Pecatu SouthKuta",
        currentPrice: 337.15,
        difference: -1.76
    ),
    
]

struct dataPoint: Identifiable { // 1 hour data of 1 beach
    var id: UUID = UUID()
    var beach_id: Int
    var time: Date
    var waveHeight: Double
    var waterTemperature: Double
    var airTemperature: Double
    var windSpeed: Double
    var precipitation: Double
    var cloudCover: Double
}

struct beachData{
    var beachId: Int
    var datapoints: [dataPoint]
} // one beach


let beaches: [beachData] = [] // beaches

    


struct ContentView: View {

    @State private var selectedOption: WatchlistOption = .manual
    @State private var selectedSort: orderlistOption = .Ascending
    @State private var selectedShow: showListOption = .PriceChange

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                //gradient shape
                Image("gradient")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()

                VStack {
                    //image
                    Spacer(minLength: 50)
                    Image("surfer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                    //streak info
                    HStack {
                        Text("7 Days")
                        Image(systemName: "flame.fill")
                            .foregroundStyle(
                                Color(
                                    red: 242 / 255,
                                    green: 95 / 255,
                                    blue: 37 / 255
                                )
                            )
                    }.font(Font.largeTitle.bold())
                        .fontWeight(Font.Weight.heavy)

                    Spacer(minLength: 20)
                    Divider()
                        .frame(height: 1)
                        .background(Color.white)
                        .opacity(0.4)
                        .frame(width: 350)
                    HStack {
                        Button {

                        } label: {
                            Text("Bali").bold(true)
                            Image(systemName: "mappin.circle.fill")
                        }.foregroundStyle(Color(.white)).bold(true)
                            .padding(10)
                            .glassEffect(.regular)

                        Spacer()
                        Button {

                        } label: {
                            Text("16 April")
                            Image(systemName: "chevron.right")
                        }.foregroundStyle(Color(.white))
                            .fontWeight(.heavy)

                    }.padding(10)

                    List {

                        ForEach(mockBeaches.enumerated(), id: \.offset) { id,data in
                            NavigationLink {
                                DetailView(beach: mockBeaches[id], item: dataAll[id])
                            } label: {
                                BeachListItem(
                                    name: data.name,
                                    address: data.address,
//                                    currentPrice: data.currentPrice,
//                                    difference: data.difference
                                )
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
                    }
                }
            }

            .listStyle(.plain)

            .toolbar {

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
