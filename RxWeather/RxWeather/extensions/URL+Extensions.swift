//
//  URL+Extensions.swift
//  RxWeather
//
//  Created by Jason Sanchez on 7/11/19.
//  Copyright © 2019 Jason Sanchez. All rights reserved.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: WeatherApi.baseUrl + "\(city)" + WeatherApi.apiKey )
        //(string: WeatherApi.baseUrl + "\(city)" + WeatherApi.apiKey )
        //(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=ba0d703a8332b5fa2f3a398e9c401321")
    }
}
