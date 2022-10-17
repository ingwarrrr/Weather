//
//  GreetingView.swift
//  Weather
//
//  Created by Igor on 17.10.2022.
//

import SwiftUI

struct GreetingView: View {
    
    @EnvironmentObject var locationService: LocationService
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView()
    }
}
