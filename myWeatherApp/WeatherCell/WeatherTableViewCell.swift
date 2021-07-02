//
//  WeatherTableViewCell.swift
//  myWeatherApp
//
//  Created by Decagon on 29/06/2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    static let identifier = "WeatherTableViewCell"
    @IBOutlet var day: UILabel!
    @IBOutlet var tempIcon: UIImageView!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with model: DailyWeather) {
//        self.day.text = String(model.dt)
        self.maxTempLabel.text = "\(String(format: "%.0f", model.temp.max))°C"
        self.minTempLabel.text = "\(String(format: "%.0f", model.temp.min))°C"
        self.day.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.tempIcon.image = updateIcon(model.weather[0].main)!
    }
    func getDayForDate(_ date: Date?) -> String {
        guard let realDate = date else {
            return " "
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: realDate)
    }
    func updateIcon(_ main: String) -> UIImage? {
        print(main)
        if main == "Clear" {
            return UIImage(named: "sun")
        } else if main == "Clouds" {
            return UIImage(named: "cloudy")
        } else {
            return UIImage(named: "rainy")
        }
    }
    
}
