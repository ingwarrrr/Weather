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
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async
}

@MainActor final class HomeViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published var weather: WeatherResponce?
    
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
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async {
        do {
            weather = try await weatherService.fetchCurrentWeatherFor(latitude: latitude, longtitude: longtitude)
        } catch{
            print("Ошибка при получении данных погоды: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Alamofire
    
    func fetchCurrentWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async {

        guard let url = weatherService.absoluteURL(latitude: latitude, longtitude: longtitude) else { fatalError("Ошибка URL") }

        self.task = AF.request(url)
            .publishDecodable(type: WeatherResponce.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                switch response.result {
                case .success(let weather):
                    self?.weather = weather
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}
