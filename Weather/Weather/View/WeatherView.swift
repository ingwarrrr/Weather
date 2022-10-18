//
//  WeatherView.swift
//  Weather
//
//  Created by Igor on 17.10.2022.
//

import SwiftUI

struct WeatherView: View {
    var weather: WeatherModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold().font(.title)
                    Text("Сегодня, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack {
                        Text(weather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 250, alignment: .leading)
                        
                        Spacer()
                            
                        VStack(spacing: 20) {
                            Image(systemName: "cloud")
                                .font(.system(size: 40))
                            
                            Text(weather.weather[0].main)
                        }
                        .padding(.trailing)
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    AsyncImage(url: URL(string: "https://static.vecteezy.com/system/resources/previews/000/183/639/large_2x/flat-design-vector-landscape-illustration.jpg")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                            .cornerRadius(35)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Погода сейчас")
                        .bold().padding(.bottom)
                    
                    HStack {
                        WeatherRow(logo: "thermometer.snowflake", name: "Минимальная температура", value: weather.main.tempMin.roundDouble() + "°")
                        Spacer()
                        WeatherRow(logo: "thermometer.sun.fill", name: "Максимальная температура", value: weather.main.tempMax.roundDouble() + "°")
                    }
                    HStack {
                        WeatherRow(logo: "wind", name: "Скорость ветра", value: weather.wind.speed.roundDouble() + " м/с")
                        Spacer()
                        WeatherRow(logo: "humidity", name: "Влажность", value: weather.main.humidity.roundDouble() + "°")
                            .padding(.trailing, 25)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
