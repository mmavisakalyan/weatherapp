//
//  WeatherTableViewCell.swift
//  weatherapp
//
//  Created by Mushegh Mavisakalyan on 1/29/19.
//  Copyright © 2019 Mushegh Mavisakalyan. All rights reserved.
//

import UIKit
import SDWebImage

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateWithWeatherData(_ data: WeatherData) {
        if let temp = data.temperatureInCelsius() {
            temperatureLabel.text = "\(Int(temp))°"
        }
        
        if let descr = data.weatherConditions.first, let iconUrl = descr.getIconUrl() {
            weatherConditionImageView.sd_setImage(with: iconUrl, completed: nil)
            conditionLabel.text = descr.description
        }
        
        if let md = data.measureDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            timeLabel.text = "\(formatter.string(from: md))"
        }
    }

}
