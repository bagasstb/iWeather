//
//  ViewController.swift
//  iWheater
//
//  Created by bagasstb on 06/03/19.
//  Copyright © 2019 xProject. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate, NetworkServiceDelegate {
    
    let APP_ID = "4617be9e27b25a22a7d598323d2c12d4"
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    let networkService = Networking()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func userEnterCityName(city: String) {
        let param: [String: String] = ["q": city, "appid": APP_ID ]
        networkService.getWeatherData(parameters: param)
        cityLabel.text = city
    }

    func didComplete(result: Result<Any>) {
        if result.isSuccess {
            let weatherJSON: JSON = JSON(result.value!)
            self.updateWeatherData(json: weatherJSON)
        } else {
            self.cityLabel.text = "Connection Issues"
        }
    }

    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateIUWithWeatherData()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    func updateIUWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature) °C"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            let params: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            networkService.getWeatherData(parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
}

