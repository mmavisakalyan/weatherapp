//
//  LocationWeatherData.swift
//  weatherapp
//
//  Created by Mushegh Mavisakalyan on 1/29/19.
//  Copyright © 2019 Mushegh Mavisakalyan. All rights reserved.
//

import Foundation

/**
 This class specifically implemented for the further improvements of the weather app having a support for multiple locations.
 As an example in the DataManager we will have an array of objects of LocationWeatherData type and we will keep the track
 of the various locations through this object.
 */
class LocationWeatherData {
    var weather: WeatherData?
    var forecast: WeatherForecastData?
    var countryAbbr: String?
    var city: String?
    var longitude: Double?
    var latitude: Double?
}
