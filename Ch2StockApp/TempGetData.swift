//
//  TempGetData.swift
//  Ch2StockApp
//
//  Created by bram raiskay chandra on 21/04/26.
//

import SwiftUI

func fetchBeachData(
    beachID: Int,
    completion: @escaping (Result<Data, Error>) -> Void
) {

    var components = URLComponents(
        string:
            "http://localhost:5678/webhook/32fe08af-1312-4978-b0a4-668e589c79a2"
    )!

    components.queryItems = [
        URLQueryItem(name: "beachID", value: String(beachID))
    ]

    guard let url = components.url else {
        completion(.failure(URLError(.badURL)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    URLSession.shared.dataTask(with: request) {
        data,
        response,
        error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        completion(.success(data))
    }.resume()
}

func fetchBeachName(
    beachID: Int,
    completion: @escaping (Result<Data, Error>) -> Void
) {

    var components = URLComponents(
        string:
            "http://localhost:5678/webhook/c13c7169-2e3d-4ddd-8779-fe95aae934dc"
    )!

    components.queryItems = [
        URLQueryItem(name: "beachID", value: String(beachID))
    ]

    guard let url = components.url else {
        completion(.failure(URLError(.badURL)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    URLSession.shared.dataTask(with: request) {
        data,
        response,
        error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        completion(.success(data))
    }.resume()
}

struct BeachName: Decodable {
    let id: Int
    let name: String
    let address: String
}

struct TempGetData: View {
    var beachIdTarget: Int
    @State private var responseTextData: String = ""
    @State private var responseTextBeach: String = ""

    @State private var isLoading = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                Text(responseTextData).padding()
                Text(responseTextBeach).padding()

            }
        }.onAppear {
            loadData()
            loadBeach()
        }
    }

    func loadBeach() {
        isLoading = true

        fetchBeachName(beachID: beachIdTarget) { result in
            DispatchQueue.main.async {
                isLoading = false

                switch result {
                case .success(let data):
                    do {
                        let beaches = try JSONDecoder().decode(
                            [BeachName].self,
                            from: data
                        )

                        if let beach = beaches.first {
                            responseTextBeach =
                                "\(beach.name)\n\(beach.address)"
                        } else {
                            responseTextBeach = "No data"
                        }

                    } catch {
                        responseTextBeach =
                            "JSON error: \(error.localizedDescription)"
                    }

                case .failure(let error):
                    responseTextBeach = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    func loadData() {
        isLoading = true

        fetchBeachData(beachID: beachIdTarget) { result in
            DispatchQueue.main.async {
                isLoading = false

                switch result {
                case .success(let data):
                    do {
                        let json = try JSONSerialization.jsonObject(with: data)

                        if let array = json as? [Any] {
                            responseTextData = "Items received: \(array.count)"
                        } else if let dict = json as? [String: Any],
                            let array = dict["data"] as? [Any]
                        {
                            responseTextData = "Items received: \(array.count)"
                        } else {
                            responseTextData = "Not an array response"
                        }

                    } catch {
                        responseTextData =
                            "JSON error: \(error.localizedDescription)"
                    }

                case .failure(let error):
                    responseTextData = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

}
