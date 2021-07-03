//
//  ViewModel.swift
//  myWeatherApp
//
//  Created by Decagon on 03/07/2021.
//

import Foundation
import CoreLocation

class ViewModel {
    
    let cityname = "Lagos"
    let stateCode = 101001
    let key = "55ef47bf09a41327217d8771c9297234"
    let countryCode = "+234"
    let locationManager = CLLocationManager()
    var model = [DailyWeather]()
    var currentLocation: CLLocation?
    var currentWeather: CurrentWeatherObject?
    var dailyDataEntry = [DailyWeather]()
    var viewModelCompletion: (() -> Void)?

    
    func networkCall() {
        Network.shared.requestWeatherForLocation()
    }
    
}
