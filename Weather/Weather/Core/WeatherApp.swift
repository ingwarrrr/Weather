//
//  WeatherApp.swift
//  Weather
//
//  Created by Igor on 16.10.2022.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            var locationService: LocationService = LocationService()
            var viewModel: HomeViewModel = HomeViewModel()
            
            HomeView(ObservedObject(wrappedValue: viewModel), locationService)
        }
    }
}
