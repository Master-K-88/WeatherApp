//
//  Weather.swift
//  myWeatherApp
//
//  Created by Decagon on 29/06/2021.
//

import Foundation

struct DailyWeatherResponse: Codable {
    let current: CurrentWeatherObject?
    let daily: [DailyWeather]
}
struct CurrentWeatherObject: Codable {
    let temp: Double
}

struct DailyWeather: Codable {
    let dt: Int
    let temp: TempObject
    let weather: [WeatherValues]
    let alerts: [Alert]?
}

struct TempObject: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct WeatherValues: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Alert: Codable {
    let sender_name: String
    let event: String
    let description: String
}
