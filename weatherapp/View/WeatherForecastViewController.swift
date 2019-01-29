//
//  WeatherForecastViewController.swift
//  weatherapp
//
//  Created by Mushegh Mavisakalyan on 1/29/19.
//  Copyright © 2019 Mushegh Mavisakalyan. All rights reserved.
//

import UIKit

class WeatherForecastViewController: UIViewController {
    @IBOutlet weak var weatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var lon = 40.171964
        var lat = 44.511598
        if let location = DataManager.shared.locationManager?.location?.coordinate {
            lon = location.longitude
            lat = location.latitude
        }
        DataManager.shared.requestWeatherForecast(lon, lat) { (err) in
            if let e = err {
                print(e)
                let alert = UIAlertController(title: "Error", message: "Failed to fetch weather data", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.weatherTableView.reloadData()
            }
        }
    }
}


extension WeatherForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataManager.shared.weatherData.forecast?.dailyWeatherData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DataManager.shared.weatherData.forecast?.dailyWeatherData[section].dayOfWeek
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.weatherData.forecast?.dailyWeatherData[section].weatherData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherTableViewCell
        if let data = DataManager.shared.weatherData.forecast?.dailyWeatherData[indexPath.section].weatherData[indexPath.row] {
            cell.updateWithWeatherData(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = DataManager.shared.weatherData.forecast?.dailyWeatherData[indexPath.section] {
            let vc = storyboard?.instantiateViewController(withIdentifier: "todayVC") as! TodayWeatherViewController
            vc.weatherData = data.weatherData[indexPath.row]
            vc.title = data.dayOfWeek
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
