//
//  Networking.swift
//  iWeather
//
//  Created by bagasstb on 20/03/19.
//  Copyright © 2019 xProject. All rights reserved.
//

import Alamofire

protocol NetworkServiceDelegate {
    func didComplete(result: Result<Any>)
}

class Networking {
    
    var delegate: NetworkServiceDelegate?
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    
    func getWeatherData(parameters: [String: String]) {
        Alamofire.request(WEATHER_URL, method: .get, parameters: parameters).responseJSON {
            response in
            self.delegate?.didComplete(result: response.result)
        }
    }
    
}
