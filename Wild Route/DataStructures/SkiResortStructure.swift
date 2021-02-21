//
//  SkiResorts.swift
//  Outdoor Activity Recommender
//
//  Created by THOMAS GRAY on 01/02/2021.
//
import SwiftUI
import Mapbox
// MARK: - Welcome
struct SkiJSON: Codable {
    let searchAPI: SearchAPI
    
    enum CodingKeys: String, CodingKey {
        case searchAPI = "search_api"
    }
}

// MARK: - SearchAPI
struct SearchAPI: Codable {
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let areaName, country, region: [AreaName]
    let latitude, longitude, population: String
    let weatherURL: [AreaName]
    
    enum CodingKeys: String, CodingKey {
        case areaName, country, region, latitude, longitude, population
        case weatherURL = "weatherUrl"
    }
}

// MARK: - AreaName
struct AreaName: Codable {
    let value: String
}

class SkiResorts {
    
    func skiSearch(lat: Double, lon: Double, completion: @escaping ([Result])->()) {
        print("here")
        var skiData = [Result]()
        // Create URL
        let url = URL(string: "https://api.worldweatheronline.com/premium/v1/search.ashx?key=02e686314f7b48a2a75162854212801&q=\(lat),\(lon)&format=json&num_of_results=4&wct=Ski")
        
        guard let requestUrl = url else {
            print("Invalid URL")
            return
        }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            // Using parseJSON() function to convert data to Swift struct
            DispatchQueue.main.async {
                let parsedData = self.parseJSON(data: data)
                guard let parsedModel = parsedData else { return }
                skiData = parsedModel.searchAPI.result
                completion(skiData)
            }
        }
        task.resume()
    }
    
    func parseJSON(data: Data) -> SkiJSON? {
        do {
            let skijson = try? JSONDecoder().decode(SkiJSON.self, from: data)
            //print(skijson!)
            return skijson
        }
    }
}
