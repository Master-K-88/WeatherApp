//
//  ViewController.swift
//  myWeatherApp
//
//  Created by Decagon on 29/06/2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var dailyDataEntry = [DailyWeather]()
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorEffect = .none
        return table
    }()
    let cityname = "Lagos"
    let stateCode = 101001
    let key = "55ef47bf09a41327217d8771c9297234"
    let countryCode = "+234"
    let locationManager = CLLocationManager()
    var model = [DailyWeather]()
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        // Setting Delegate and Datasource for the table
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register two cell (The hourly and Daily Cells)
        tableView.register(HourlyTableViewCell.nib(),
                           forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.register(WeatherTableViewCell.nib(),
                           forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        setupLocation()
        requestWeatherForLocation()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setting the frame for the table
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.frame.size.width,
                                 height: view.frame.size.height)
    }
    
    // Location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=currently,minutely,hourly&appid=9250e45e424e1ca6a05fe8f347df00aa&units=metric")
        
        URLSession.shared.dataTask(with: url!, completionHandler: { [self] data, response, error in
            // validation
            guard let data = data, error == nil else {
//                print("Error12: \((error?.localizedDescription))")
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
            guard let currentTemp = result.current?.temp else {
                return
            }
            let dailyData = result.daily
            self.dailyDataEntry.append(contentsOf: dailyData)
            print(currentTemp)
//            print("The current temperature is: \(currentTemp)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            // update userInterface
        }).resume()
        
        print("The Longitude: \(long) and the Latitude: \(lat)")
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyDataEntry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: dailyDataEntry[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            self.requestWeatherForLocation()
        }
    }
}

//api.openweathermap.org/data/2.5/find?lat=37.33233141&lon=\(long)&appid=\(key)
//https://api.openweathermap.org/data/2.5/onecall?lat=37.33233141&lon=-122.0312186&exclude=minutely,current&appid=9250e45e424e1ca6a05fe8f347df00aa

//let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,current&appid=\(key)")
