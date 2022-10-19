//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Igor on 18.10.2022.
//

import Foundation
import Combine
import CoreLocation

protocol HomeViewModelProtocol {
    var weather: WeatherResponce? { get }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async
}

@MainActor final class HomeViewModel: ObservableObject {
    
    // MARK: - Published properties

    @Published var weather: WeatherResponce?
    
    // MARK: - Properties
    
    enum PageState {
            case idle
            case loading
            case failed(ErrorType)
            case loaded(WeatherResponce)
        }

    private var subscriptions: Set<AnyCancellable> = []
    private var weatherService: OpenWeatherAPIProtocol
    
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
}
