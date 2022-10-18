//
//  ContentView.swift
//  Weather
//
//  Created by Igor on 16.10.2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject var locationService: LocationService
    @ObservedObject var viewModel: HomeViewModel
    
    init(_ viewModel: ObservedObject<HomeViewModel>,
         _ locationService: LocationService) {
        _viewModel = viewModel
        _locationService = StateObject(wrappedValue: locationService)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.blue.opacity(0.2), .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if let location = locationService.location {
                    if let weather = viewModel.weather {
                        WeatherView(weather: weather)
                    } else {
                        LoadingView()
                            .task {
                                await viewModel.fetchWeather(latitude: location.latitude, longtitude: location.longitude)
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
        HomeView(ObservedObject(wrappedValue: HomeViewModel()), LocationService())
    }
}
