//
//  WeatherForecastData.swift
//  weatherapp
//
//  Created by Mushegh Mavisakalyan on 1/29/19.
//  Copyright © 2019 Mushegh Mavisakalyan. All rights reserved.
//

import Foundation

class DailyWeatherData {
    var dayOfWeek: String?
    var weatherData = [WeatherData]()
}

class WeatherForecastData {
    var dailyWeatherData = [DailyWeatherData]()
    var forecastData = [WeatherData]()
    
    init(json: [String: Any]) throws {
        let today = Calendar.current.component(.day, from: Date())
        let currentDayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date())
        if let list = json["list"] as? [[String: Any]] {
            list.forEach { (weatherJson) in
                do {
                    let w = try WeatherData(json: weatherJson)
                    if let dt = w.measureDate {
                        let dayOfMonth = Calendar.current.component(.day, from: dt)
                        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: dt)
                        let weekDay = Calendar.current.component(.weekday, from: dt)
                        let month = Calendar.current.component(.month, from: dt)
                        let dateFormat: String?
                        if dayOfMonth == today {
                            dateFormat = "Today"
                        } else if dayOfMonth - today == 1 {
                            dateFormat = "Tomorrow"
                        } else {
                            let weekDayName = Calendar.current.weekdaySymbols[weekDay - 1]
                            let monthName = Calendar.current.monthSymbols[month - 1]
                            dateFormat = "\(weekDayName), \(monthName) \(dayOfMonth)"
                        }
                        let indx = dayOfYear! - currentDayOfYear!
                        if indx < dailyWeatherData.count {
                            dailyWeatherData[indx].weatherData.append(w)
                        } else {
                            let dwd = DailyWeatherData()
                            dwd.dayOfWeek = dateFormat
                            dwd.weatherData.append(w)
                            dailyWeatherData.append(dwd)
                        }
                        forecastData.append(w)
                    }
                } catch let error {
                    print(error)
                }
            }
        } else {
            throw BlockerInitializationError.ForecastDataNotAvailableError
        }
    }
}
