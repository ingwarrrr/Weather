//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Igor on 18.10.2022.
//

import Foundation
import Combine
import CoreLocation
import Alamofire

protocol HomeViewModelProtocol {
    var weather: WeatherResponce? { get }
    
//    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async
    func fetchCurrentWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async
}

@MainActor final class HomeViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published var weather: WeatherResponce?
    @Published var hasError = false
    @Published var error: DataError?
    
    // MARK: - Properties
    
    private var weatherService: OpenWeatherAPIProtocol
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let APIKey = "75dfad1749d7bd498d8431971023296f"
    private var task: Cancellable?
    
    // MARK: - Initializers
    
    init(weatherService: OpenWeatherAPIProtocol = OpenWeatherAPI.shared) {
        self.weatherService = weatherService
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Methods
    
//    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async {
//        hasError = false
//
//        do {
//            weather = try await weatherService.fetchCurrentWeatherFor(latitude: latitude, longtitude: longtitude)
//        } catch{
//            self.hasError = true
//            self.error = DataError.custom(error: error)
//        }
//    }
    
    // MARK: - Alamofire request
    
    func fetchCurrentWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async {
        hasError = false
        guard let url = weatherService.absoluteURL(latitude: latitude, longtitude: longtitude) else {
            self.hasError = true
            self.error = DataError.invalidURL
            return
        }

        self.task = AF.request(url)
            .publishDecodable(type: WeatherResponce.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    self.hasError = true
                    self.error = DataError.custom(error: error)
                }
            }, receiveValue: { [weak self] response in
                switch response.result {
                case .success(let weather):
                    self?.weather = weather
                case .failure(let error):
                    self?.hasError = true
                    self?.error = DataError.custom(error: error)
                }
            })
    }
}

// MARK: - DataError

extension HomeViewModel {
    enum DataError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        case invalidStatusCode
        case invalidURL
        
        var errorDescription: String? {
            switch self {
            case .failedToDecode:
                return "Ошибка декодирования"
            case .custom(let error):
                return error.localizedDescription
            case .invalidStatusCode:
                return "Запрос не вернул валидный статус код"
            case .invalidURL:
                return "Ошибка URL"
            }
        }
    }
}
