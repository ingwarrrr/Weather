//
//  WeatherRowViewModel.swift
//  Weather
//
//  Created by Igor on 18.10.2022.
//

import Foundation


protocol WeatherRowViewModelProtocol {
    var logo: String { get }
    var name: String { get }
    var value: String { get }
}

@MainActor final class WeatherRowViewModel: ObservableObject {
    
    init(weather: WeatherResponce) {
        self.weather = weather
    }
    
    var logo: String {
        weather.name
    }
    
    var name: String {
        weather.main.feelsLike.roundDouble() + "°"
    }
    
    var value: String {
        weather.weather[0].main
    }
}
