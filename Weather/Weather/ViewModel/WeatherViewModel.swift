//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Igor on 18.10.2022.
//

import Foundation

protocol WeatherViewModelProtocol {
    var weather: WeatherResponce { get }
    var cityName: String { get }
    var feelsLike: String { get }
    var main: String { get }
    var tempMin: String { get }
    var tempMax: String { get }
    var windSpeed: String { get }
    var humidity: String { get }
}

@MainActor final class WeatherViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published var weather: WeatherResponce
    
    // MARK: - Properties
    
    var cityName: String {
        weather.name
    }
    
    var feelsLike: String {
        weather.main.feelsLike.roundDouble() + "°"
    }
    
    var main: String {
        weather.weather[0].main
    }
    
    var tempMin: String {
        weather.main.tempMin.roundDouble() + "°"
    }
    
    var tempMax: String {
        weather.main.tempMax.roundDouble() + "°"
    }
    
    var windSpeed: String {
        weather.wind.speed.roundDouble() + " м/с"
    }
    
    var humidity: String {
        weather.main.humidity.roundDouble() + "°"
    }
    
    // MARK: - Initializers
    
    init(weather: WeatherResponce) {
        self.weather = weather
    }
}
