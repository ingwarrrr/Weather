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
        VStack {
            
            if let location = locationService.location {
                if let weather = viewModel.weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            await viewModel.fetchCurrentWeather(latitude: location.latitude, longtitude: location.longitude)
                        }
                        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
                            Button(action: {}) {
                                Text("Retry")
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
        .background(
            LinearGradient(gradient: .init(colors: [.blue.opacity(0.2), .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(ObservedObject(wrappedValue: HomeViewModel()), LocationService())
    }
}
