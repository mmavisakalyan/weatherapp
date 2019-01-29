//
//  Errors.swift
//  weatherapp
//
//  Created by Mushegh Mavisakalyan on 1/29/19.
//  Copyright © 2019 Mushegh Mavisakalyan. All rights reserved.
//

import Foundation

enum BlockerInitializationError : Error {
    case InvalidDataError
    case MainWeatherDataError
    case ForecastDataNotAvailableError
}

