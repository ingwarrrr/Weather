//
//  WeatherService.swift
//  Weather
//
//  Created by Igor on 17.10.2022.
//

import Foundation
import CoreLocation

protocol WeatherServiceProtocol {
    func fetchCurrentWeatherFor(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async throws -> WeatherModel
}

class WeatherService {
    static let shared: WeatherServiceProtocol = WeatherService()
    private init() { }
}

extension WeatherService: WeatherServiceProtocol {
    func fetchCurrentWeatherFor(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async throws -> WeatherModel {
        let urlComponents = makeCurrentWeatherComponents(latitude: latitude, longtitude: longtitude)
        guard let url = urlComponents.url else { fatalError("Ошибка URL") }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Ошибка на получение запроса данных погоды")}
        
        let decoder = JSONDecoder()
        let weatherData = try decoder.decode(WeatherModel.self, from: data)
        
        return weatherData
    }
}

// MARK: - OpenWeatherMap URL
private extension WeatherService {
    struct OpenWeatherAPI {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let key = "75dfad1749d7bd498d8431971023296f"
    }
    
    func makeCurrentWeatherComponents(
        latitude: CLLocationDegrees, longtitude: CLLocationDegrees) -> URLComponents {
            var components = URLComponents()
            components.scheme = OpenWeatherAPI.scheme
            components.host = OpenWeatherAPI.host
            components.path = OpenWeatherAPI.path + "/weather"
            
            components.queryItems = [
                URLQueryItem(name: "lat", value: String(latitude)),
                URLQueryItem(name: "lon", value: String(longtitude)),
                URLQueryItem(name: "mode", value: "json"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
            ]
            
            return components
        }
}
