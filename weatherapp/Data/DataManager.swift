//
//  DataManager.swift
//  whetherapp
//
//  Created by Mushegh Mavisakalyan on 1/29/19.
//  Copyright © 2019 Mushegh Mavisakalyan. All rights reserved.
//

import Alamofire
import CoreLocation
import Foundation

protocol DataManagerDelegate: class {
    func initializationCompleted()
}

class DataManager: NSObject {
    static let shared = DataManager()
    
    var weatherData = LocationWeatherData()
    var locationManager: CLLocationManager?
    
    weak var delegate: DataManagerDelegate?
    
    func initialize() {
        initializeLocationManager()
    }

    
    func requestTodayWeather(_ longitude: Double!, _ latitude: Double!, completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude ?? 0)&lon=\(longitude ?? 0)&APPID=efcedcd3af5bc5a5c58fff79f104666d"
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
                .validate().responseJSON { (response) in
                    do {
                        if let result = response.result.value, let json = result as? [String: Any] {
                            let w = try WeatherData(json: json)
                            if let sys = json["sys"] as? [String: Any] {
                                if let city = json["name"] as? String, let country = sys["country"] as? String
                                {
                                    self.weatherData.city = city
                                    self.weatherData.countryAbbr = country
                                    self.weatherData.longitude = longitude
                                    self.weatherData.latitude = latitude
                                    self.weatherData.weather = w
                                    self.invokeInMainThread(completion, nil)
                                }
                            }
                        } else {
                            self.invokeInMainThread(completion, BlockerInitializationError.InvalidDataError)
                        }
                    } catch let error {
                        self.invokeInMainThread(completion, error)
                    }
            }
        }
    }
    
    func requestWeatherForecast(_ longitude: Double!, _ latitude: Double!, completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude ?? 0)&lon=\(longitude ?? 0)&APPID=efcedcd3af5bc5a5c58fff79f104666d"
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
                .validate().responseJSON { (response) in
                    do {
                        if let result = response.result.value, let json = result as? [String: Any] {
                            let w = try WeatherForecastData(json: json)
                            if let cityJson = json["city"] as? [String: Any] {
                                if let city = cityJson["name"] as? String, let country = cityJson["country"] as? String
                                {
                                    self.weatherData.city = city
                                    self.weatherData.countryAbbr = country
                                    self.weatherData.longitude = longitude
                                    self.weatherData.latitude = latitude
                                    self.weatherData.forecast = w
                                    self.invokeInMainThread(completion, nil)
                                }
                            }
                        } else {
                            self.invokeInMainThread(completion, BlockerInitializationError.InvalidDataError)
                        }
                    } catch let error {
                        self.invokeInMainThread(completion, error)
                    }
            }
        }
    }
    
    private func invokeInMainThread(_ callback: @escaping (Error?) -> Void, _ param: Error?) {
        DispatchQueue.main.async {
            callback(param)
        }
    }
    
    private func initializeLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = .greatestFiniteMagnitude
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
}

extension DataManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.delegate?.initializationCompleted()
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("")
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("")
        self.delegate?.initializationCompleted()
    }
}
