//
//  Weather.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 21/02/2021.
//

import SwiftUI
import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, daily
    }
}

// MARK: - Current
struct Current: Codable {
    
    let dt, sunrise, sunset: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let uvi, clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let clouds: Int
    let pop, uvi: Double
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, pop, uvi, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}



struct WeatherView: View {
    
    @State var skiData : Welcome?
    var lat: Double
    var lon: Double
    
    var body: some View {
        VStack {
            HStack {
               VStack (spacing: 12) {
                    IconView(icon: skiData?.current.weather[0].icon)
                    Text(skiData?.current.weather[0].weatherDescription ?? "nowt")
                                       .font(.system(.footnote, design: .rounded))
                                       .foregroundColor(.gray)
                
                }
                Spacer()
                VStack (alignment: .trailing){
                    Text("\(String(format: "%.0f°", skiData?.current.temp ?? 0.0))")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Feels like \(String(format: "%.0f°", skiData?.current.feelsLike ?? 0.0))")
                        .font(.system(.footnote, design: .rounded))
                        .foregroundColor(.gray)
                }
            }
            .padding([.top, .trailing, .bottom])
            .padding(.leading, 24)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onAppear() {
            skiSearch(lat: lat, lon: lon)
        }
    }
    
    func skiSearch(lat: Double, lon: Double) {
        print("here")
        print(lat)
        // Create URL
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,hourly&APPID=dbf283d4e3f9e558105d7226873e8e20")
        
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
                self.skiData = parsedModel
            }
        }
        task.resume()
    }
    
    func parseJSON(data: Data) -> Welcome? {
        do {
            let skijson = try? JSONDecoder().decode(Welcome.self, from: data)
            //print(skijson!)
            return skijson
        }
    }
    
    
}

struct IconView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var icon: String?
    
    var body: some View {
        Image(systemName: weatherIcons[icon ?? "loading"] ?? "goforward")
            .foregroundColor(.gray)
            
    }
    
    let weatherIcons = [
        "01d": "sun.max.fill",
        "02d": "cloud.sun.fill",
        "03d": "cloud.fill",
        "04d": "smoke.fill",
        "09d": "cloud.drizzle.fill",
        "10d": "cloud.rain.fill",
        "11d": "cloud.bolt.rain.fill",
        "13d": "snow",
        "50d": "cloud.fog.fill",
        "01n": "moon.stars.fill",
        "02n": "cloud.moon.fill",
        "03n": "cloud.fill",
        "04n": "smoke.fill",
        "09n": "cloud.drizzle.fill",
        "10n": "cloud.rain.fill",
        "11n": "cloud.bolt.rain.fill",
        "13n": "snow",
        "50n": "cloud.fog.fill",
        "loading" : "goforward",
        "wind" : "wind",
        "sunrise" : "sunrise.fill",
        "sunset" : "sunset.fill",
    ]
    
}
