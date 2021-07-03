//
//  ViewController.swift
//  myWeatherApp
//
//  Created by Decagon on 29/06/2021.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorEffect = .none
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        // Setting Delegate and Datasource for the table
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = #colorLiteral(red: 0.2032072842, green: 0.4291871786, blue: 0.7031712532, alpha: 1)
        self.tableView.backgroundColor = #colorLiteral(red: 0.2032072842, green: 0.4291871786, blue: 0.7031712532, alpha: 1)
        
        // Register two cell (The hourly and Daily Cells)
        tableView.register(HourlyTableViewCell.nib(),
                           forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.register(WeatherTableViewCell.nib(),
                           forCellReuseIdentifier: WeatherTableViewCell.identifier)
        viewModel.networkCall()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setting the frame for the table
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.frame.size.width,
                                 height: view.frame.size.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Network.shared.completionHandler = { [weak self] result, current in
            self?.viewModel.dailyDataEntry = result
            self?.viewModel.currentWeather = current
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.tableHeaderView = self?.createTableHeader()
            }
        }
    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        
        let currentLocation = UILabel(frame: CGRect(x: 0,
                                                    y: headerView.frame.size.height / 4,
                                                    width: view.frame.size.width,
                                                    height: headerView.frame.size.height / 5))
        let currentTemp = UILabel(frame: CGRect(x: 0,
                                                y: currentLocation.frame.size.height * 0.75 + currentLocation.frame.size.height,
                                                width: view.frame.size.width,
                                                height: headerView.frame.size.height / 5))
        let weatherDetails = UILabel(frame: CGRect(x: 0,
                                                       y: currentLocation.frame.size.height * 0.35 + currentTemp.frame.size.height + currentLocation.frame.size.height,
                                                       width: view.frame.size.width,
                                                       height: headerView.frame.size.height / 5))
        
        guard let currentWeatherDetail = viewModel.currentWeather else {
            return UIView()
        }
        
        currentTemp.text = "\(String(format: "%.0f", currentWeatherDetail.temp))°"
        currentTemp.font = UIFont(name: "Helvetica", size: 70)
        
        currentLocation.text = "Lagos"
        
        weatherDetails.text = currentWeatherDetail.weather[0].description
            
        [currentTemp, currentLocation, weatherDetails].forEach{headerView.addSubview($0)}
        [currentTemp, currentLocation, weatherDetails].forEach{$0.textAlignment = .center}
        
        headerView.backgroundColor = #colorLiteral(red: 0.2032072842, green: 0.4291871786, blue: 0.7031712532, alpha: 1)
        
        return headerView
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyDataEntry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: viewModel.dailyDataEntry[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
