//
//  WeatherService.swift
//  Weather
//
//  Created by Igor on 17.10.2022.
//

import Foundation
import CoreLocation
import Alamofire
import Combine

protocol OpenWeatherAPIProtocol {
    func fetchCurrentWeatherFor(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async throws -> WeatherResponce
}

    // MARK: - OpenWeatherAPI Singleton

class OpenWeatherAPI {
    static let shared: OpenWeatherAPIProtocol = OpenWeatherAPI()
    private init() { }
}

extension OpenWeatherAPI: OpenWeatherAPIProtocol {
    
    // MARK: - Methods

    func fetchCurrentWeatherFor(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async throws -> WeatherResponce {
        let urlComponents = makeCurrentWeatherComponents(latitude: latitude, longtitude: longtitude)
        guard let url = urlComponents.url else { fatalError("Ошибка URL") }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Ошибка на получение запроса данных погоды")}
        
        let decoder = JSONDecoder()
        let weatherData = try decoder.decode(WeatherResponce.self, from: data)
        
        return weatherData
    }
    
    func fetchCurrentWeatherFor1(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) -> AnyPublisher<WeatherResponce, AFError> {
        
        let urlComponents = makeCurrentWeatherComponents(latitude: latitude, longtitude: longtitude)
        guard let url = urlComponents.url else { fatalError("Ошибка URL") }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        return AF.request(url,
                          method: .get,
                          headers: headers
        )
        .validate()
        .publishDecodable(type: WeatherResponce.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

    // MARK: - OpenWeather URL

private extension OpenWeatherAPI {
    struct ComponentsUrl {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let key = "75dfad1749d7bd498d8431971023296f"
    }
    
    func makeCurrentWeatherComponents(
        latitude: CLLocationDegrees, longtitude: CLLocationDegrees) -> URLComponents {
            var components = URLComponents()
            components.scheme = ComponentsUrl.scheme
            components.host = ComponentsUrl.host
            components.path = ComponentsUrl.path + "/weather"
            
            components.queryItems = [
                URLQueryItem(name: "lat", value: String(latitude)),
                URLQueryItem(name: "lon", value: String(longtitude)),
                URLQueryItem(name: "mode", value: "json"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "APPID", value: ComponentsUrl.key)
            ]
            
            return components
        }
}
