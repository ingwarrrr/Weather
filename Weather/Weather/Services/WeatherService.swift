//
//  WeatherService.swift
//  Weather
//
//  Created by Igor on 17.10.2022.
//

import Foundation
import CoreLocation

class WeatherService {
    let APIkey = "75dfad1749d7bd498d8431971023296f"
    
    func getCurrentWeatherFrom(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async throws {
        let apiString = "https://api.openweathermap.org/data/2.5/weather?lat={\(latitude)}&lon={\(longtitude)}&appid={\(APIkey)&units=metric}"
        guard let url = URL(string: apiString) else {fatalError("Ошибка URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Ошибка на получение запроса данных погоды")}
    }
}
