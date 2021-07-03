//
//  CurrentWeather.swift
//  myWeatherApp
//
//  Created by Decagon on 03/07/2021.
//

import Foundation

struct CurrentWeatherObject: Codable {
    let dt: Int
    let temp: Double
    let weather: [WeatherValues]
}
