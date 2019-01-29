//
//  TodayWeatherViewController.swift
//  weatherapp
//
//  Created by Mushegh Mavisakalyan on 1/29/19.
//  Copyright © 2019 Mushegh Mavisakalyan. All rights reserved.
//

import UIKit
import SDWebImage

class TodayWeatherViewController: UIViewController {
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureImageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    
    private var degreeSign = "°"
    
    var weatherData: WeatherData?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateWeatherInfo()
    }
    
    private func updateWeatherInfo() {
        if let weatherData = self.weatherData {
            let locationInfo = DataManager.shared.weatherData
            if let city = locationInfo.city, let country = locationInfo.countryAbbr {
                locationLabel.text = "\(city), \(country)"
            }
            if let weatherCondition = weatherData.weatherConditions.first {
                if let cond = weatherCondition.name {
                    weatherConditionLabel.text = cond
                }
                if let iconUrl = weatherCondition.getIconUrl() {
                    weatherConditionImageView.sd_setImage(with: iconUrl)
                }
            }
            if let temp = weatherData.temperatureInCelsius() {
                temperatureLabel.text = "\(Int(temp))\(degreeSign)C"
            }
            if let pressure = weatherData.pressure {
                pressureLabel.text = "\(Int(pressure)) hPa"
            }
            if let humidity = weatherData.humidity {
                humidityLabel.text = "\(Int(humidity))%"
            }
            if let windSpeed = weatherData.windSpeed {
                windSpeedLabel.text = "\(Int(windSpeed)) km/h"
            }
            windDirectionLabel.text = weatherData.getWindDirection()
            windDegreeLabel.text = "\(weatherData.windDirection ?? 0)\(degreeSign)"
        }
    }

}

extension TodayWeatherViewController: DataManagerDelegate {
    func initializationCompleted() {
        var lon = 40.171964
        var lat = 44.511598
        if let location = DataManager.shared.locationManager?.location?.coordinate {
            lon = location.longitude
            lat = location.latitude
        }
        DataManager.shared.requestTodayWeather(lon, lat) { (err) in
            if let e = err {
                print(e)
                let alert = UIAlertController(title: "Error", message: "Failed to fetch weather data", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.weatherData = DataManager.shared.weatherData.weather
                self.updateWeatherInfo()
                print("Success fetching data")
            }
        }
    }
}
