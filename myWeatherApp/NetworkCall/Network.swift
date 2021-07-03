//
//  Network.swift
//  myWeatherApp
//
//  Created by Decagon on 03/07/2021.
//

import Foundation
import CoreLocation

class Network: ViewController, CLLocationManagerDelegate {
    
    let networkViewModel = ViewModel()
    static let shared = Network()
    var completionHandler: (([DailyWeather], CurrentWeatherObject)-> Void)?
    
    func requestWeatherForLocation() {

        self.setupLocation()
        guard let currentLocation = networkViewModel.currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,hourly&appid=9250e45e424e1ca6a05fe8f347df00aa&units=metric")
        
        URLSession.shared.dataTask(with: url!, completionHandler: { [self] data, response, error in
            // validation
            guard let data = data, error == nil else {
                print("Error12: \((error?.localizedDescription))")
                return
            }
            //convert data to models
            var json: DailyWeatherResponse?
            do {
                json = try JSONDecoder().decode(DailyWeatherResponse.self, from: data)
            } catch {
                print("error54: \(error)")
            }
            guard let result = json else {
                return
            }
            guard let currentTemp = result.current else {
                return
            }
            let dailyData = result.daily
            
                networkViewModel.dailyDataEntry.append(contentsOf: dailyData)
                networkViewModel.currentWeather = currentTemp
            completionHandler?(networkViewModel.dailyDataEntry, currentTemp)
        }).resume()
        
        print("The Longitude: \(long) and the Latitude: \(lat)")
    }
    
    func setupLocation() {
        networkViewModel.locationManager.delegate = self
        networkViewModel.locationManager.requestWhenInUseAuthorization()
        networkViewModel.locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, networkViewModel.currentLocation == nil {
            networkViewModel.currentLocation = locations.first
            networkViewModel.locationManager.stopUpdatingLocation()
            self.requestWeatherForLocation()
        }
    }
}
