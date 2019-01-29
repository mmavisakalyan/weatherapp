//
//  WhetherData.swift
//  whetherapp
//
//  Created by Mushegh Mavisakalyan on 1/29/19.
//  Copyright © 2019 Mushegh Mavisakalyan. All rights reserved.
//

import Foundation

class WeatherCondition {
    var name: String?
    var description: String?
    var iconId: String?
    
    init(json: [String: Any]) throws {
        if let m = json["main"] as? String,
            let d = json["description"] as? String,
            let i = json["icon"] as? String
        {
            name = m
            description = d
            iconId = i
        }
    }
    
    func getIconUrl() -> URL? {
        return URL(string: "http://openweathermap.org/img/w/\(iconId ?? "10d").png")
    }
}

class WeatherData {
    var temperature: Double?
    var pressure: Double?
    var humidity: Double?
    var temperatureMin: Double?
    var temperatureMax: Double?
    var visibility: Double?
    var windSpeed: Double?
    var windDirection: Double?
    var cloudinessPercentage: Double?
    var weatherConditions = [WeatherCondition]()
    var sunriseDate: Date?
    var sunsetDate: Date?
    var measureDate: Date?
    var sunriseTimestamp: UInt?
    var sunsetTimestamp: UInt?
    var measureTimestamp: UInt?
    
    init(json: [String: Any]) throws {
        try initWeatherConditions(json)
        try initMainWeatherData(json)
        try initWindData(json)
        try initCloudsData(json)
        try initLightingData(json)
        if let vis = json["visibility"] as? Double {
            self.visibility = vis
        }
        if let dt = json["dt"] as? UInt {
            self.measureTimestamp = dt
            self.measureDate = Date(timeIntervalSince1970: TimeInterval(exactly: dt)!)
        }
    }
    
    public func temperatureInCelsius() -> Double? {
        if let t = temperature {
            return t - 273.15
        }
        return nil
    }
    
    public func temperatureInFahrenheit() -> Double? {
        if let t = temperatureInCelsius() {
            return t * 9 / 5 + 32
        }
        return nil
    }
    
    func getWindDirection() -> String {
        guard let degree = windDirection else {
            return "NULL"
        }
        
        switch degree {
        case (0...20.0), (340.0...360.0):
            return "N"
        case (20.0...70.0):
            return "NE"
        case (70.0...110.0):
            return "E"
        case (110.0...160.0):
            return "SE"
        case (160.0...200.0):
            return "S"
        case (200.0...250.0):
            return "SW"
        case (250.0...290.0):
            return "W"
        case (290.0...360.0):
            return "WN"
        default:
            return ""
        }
    }
    
    private func initWeatherConditions(_ json: [String: Any]) throws {
        if let conditions = json["weather"] as? [[String: Any]] {
            try conditions.forEach { (weatherCondition) in
                let cond = try WeatherCondition(json: weatherCondition)
                weatherConditions.append(cond)
            }
        }
    }
    
    private func initMainWeatherData(_ json: [String: Any]) throws {
        if let mainData = json["main"] as? [String: Any] {
            temperature = mainData["temp"] as? Double
            pressure = mainData["pressure"] as? Double
            humidity = mainData["humidity"] as? Double
            temperatureMin = mainData["temp_min"] as? Double
            temperatureMax = mainData["temp_max"] as? Double
        } else {
            throw BlockerInitializationError.MainWeatherDataError
        }
    }
    
    private func initWindData(_ json: [String: Any]) throws {
        if let windData = json["wind"] as? [String: Any] {
            windSpeed = windData["speed"] as? Double
            windDirection = windData["deg"] as? Double
        }
    }
    
    private func initCloudsData(_ json: [String: Any]) throws {
        if let cloudsData = json["clouds"] as? [String: Any] {
            cloudinessPercentage = cloudsData["all"] as? Double
        }
    }
    
    private func initLightingData(_ json: [String: Any]) throws {
        if let lightData = json["sys"] as? [String: Any] {
            sunriseTimestamp = lightData["sunrise"] as? UInt
            sunsetTimestamp = lightData["sunset"] as? UInt
            if let sr = sunriseTimestamp, let ss = sunsetTimestamp {
                sunriseDate = Date(timeIntervalSince1970: TimeInterval(exactly: sr)!)
                sunsetDate = Date(timeIntervalSince1970: TimeInterval(exactly: ss)!)
            }
        }
    }
}
