//
//  WeatherService.swift
//  Weather
//
//  Created by Igor on 17.10.2022.
//

import Foundation
import CoreLocation
import Combine

protocol OpenWeatherAPIProtocol {
    func fetchCurrentWeatherFor(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async throws -> WeatherResponce
    func absoluteURL(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) -> URL?
}

// MARK: - OpenWeatherAPI Singleton

class OpenWeatherAPI {
    static let shared: OpenWeatherAPIProtocol = OpenWeatherAPI()
    private init() { }
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    let APIKey = "75dfad1749d7bd498d8431971023296f"
}

extension OpenWeatherAPI: OpenWeatherAPIProtocol {
    
    // MARK: - Methods
    
    func fetchCurrentWeatherFor(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async throws -> WeatherResponce {
        
        guard let url = absoluteURL(latitude: latitude, longtitude: longtitude) else { fatalError("Ошибка URL") }
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Ошибка на получение запроса данных погоды")}
        
        let decoder = JSONDecoder()
        let weatherData = try decoder.decode(WeatherResponce.self, from: data)
        
        return weatherData
    }
    
    func absoluteURL(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) -> URL? {
        let queryURL = URL(string: baseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longtitude)),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: APIKey)]
        return urlComponents.url
    }
}
