//
//  GreetingView.swift
//  Weather
//
//  Created by Igor on 17.10.2022.
//

import SwiftUI
import CoreLocationUI

struct GreetingView: View {
    
    @EnvironmentObject var locationService: LocationService
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Image("cloud")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
                Text("Приветствую в Weather")
                    .bold().font(.title)
                Text("Пожалуйста поделитесь данными своего местоположения")
                    .padding()
            }
            .multilineTextAlignment(.center)
            .padding()
            
            LocationButton(.shareCurrentLocation) {
                locationService.requestLocation()
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView()
    }
}
