//
//  CategoryApiMenager.swift
//  Todolist
//
//  Created by Petar Sakotic on 11/12/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation

enum NetworksErrors: Error {
    case noInternet
    case badURL
    case server
    case invalidData
    case unknown
}

class NetworkMenager {
    
    static let shared = NetworkMenager()
    func getCategories(errorHandler:@escaping ErrorHandler, successHandler:@escaping SuccessHandler){
        if let url = URL(string: "https://jsonpraksa.quantox.dev/api/return-json") {
            guard ConnectivityMenager.isConnectedToInternet() else {
                return errorHandler(NetworksErrors.noInternet)
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    errorHandler(NetworksErrors.unknown)
                    return
                }
                switch httpResponse.statusCode {
                case 200...299:
                    guard let jsonData = data else {
                        errorHandler(NetworksErrors.invalidData)
                        return
                    }
                    do {
                        guard let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                            let categoriesDict = jsonDict["categories"],
                            let categoriesData = try? JSONSerialization.data(withJSONObject: categoriesDict, options: .init()) else {
                                return errorHandler(NetworksErrors.invalidData)
                        }
                        let allCategoryItems = try JSONDecoder().decode([CategoryItem].self, from: categoriesData)
                        successHandler(allCategoryItems)
                    }
                    catch{
                        errorHandler(NetworksErrors.invalidData)
                    }
                case 400...499:
                    errorHandler(NetworksErrors.badURL)
                case 500...599:
                    errorHandler(NetworksErrors.server)
                default:
                    errorHandler(NetworksErrors.unknown)
                }
            }.resume()
        }
    }
}

