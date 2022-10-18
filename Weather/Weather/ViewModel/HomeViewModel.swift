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
    @Published var weather: WeatherResponce?
    var weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol = WeatherService.shared) {
        self.weatherService = weatherService
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async {
        do {
            weather = try await weatherService.fetchCurrentWeatherFor(latitude: latitude, longtitude: longtitude)
        } catch{
            print("Ошибка при получении данных погоды: \(error.localizedDescription)")
        }
    }
}
