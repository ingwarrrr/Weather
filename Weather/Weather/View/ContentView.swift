//
//  ContentView.swift
//  Weather
//
//  Created by Igor on 16.10.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationService = LocationService()
    @State var weather: WeatherModel?
    var weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol = WeatherService.shared) {
        self.weatherService = weatherService
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.blue.opacity(0.2), .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if let location = locationService.location {
                    if let weather = weather {
                        WeatherView(weather: weather)
                    } else {
                        LoadingView()
                            .task {
                                do {
                                    weather = try await weatherService.fetchCurrentWeatherFor(latitude: location.latitude, longtitude: location.longitude)
                                } catch{
                                    print("Ошибка при получении данных погоды: \(error.localizedDescription)")
                                }
                            }
                    }
                } else {
                    if locationService.isLoading {
                        LoadingView()
                    } else {
                        GreetingView()
                            .environmentObject(locationService)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
