//
//  ContentView.swift
//  Weather
//
//  Created by Igor on 16.10.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationService = LocationService()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.blue.opacity(0.2), .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if let location = locationService.location {
                    Text("Твое местороложение: \(location.longitude), \(location.latitude)")
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
