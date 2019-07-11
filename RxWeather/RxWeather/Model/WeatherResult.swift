//
//  WeatherResult.swift
//  RxWeather
//
//  Created by Jason Sanchez on 7/11/19.
//  Copyright © 2019 Jason Sanchez. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}

