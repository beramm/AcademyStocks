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
            
//            if difference < 0 {
//                chartStock(chartColor: Color.red, width: 60, height: 40)
//            }else{
//                chartStock(chartColor: Color.green, width: 60, height: 40)
//            }
//            VStack(alignment: .trailing) {
//                Text("\(currentPrice, specifier: "%.2f")")
//                Button {
//
//                } label: {
//                    
//                    if difference < 0 {
//                        Text("\(difference, specifier: "%.2f")").padding(6)
//                            .frame(width: 55)
//                            .background(Color.red)
//                            .foregroundStyle(.white)
//                            .cornerRadius(6)
//                            .font(.system(size: 13))
//                    }else{
//                        Text("\(difference, specifier: "%.2f")").padding(6)
//                            .frame(width: 55)
//                            .background(Color.green)
//                            .foregroundStyle(.white)
//                            .cornerRadius(6)
//                            .font(.system(size: 13))
//                    }
//                    
//                }
//            }
        }
        //        .padding()
    }
}
