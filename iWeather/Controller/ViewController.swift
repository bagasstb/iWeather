//
//  ViewController.swift
//  iWheater
//
//  Created by bagasstb on 06/03/19.
//  Copyright © 2019 xProject. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    func userEnterCityName(city: String) {
        let param: [String: String] = ["q": city, "appid": APP_ID ]
        getWeatherData(url: WEATHER_URL, parameters: param)
        print(city)
        cityLabel.text = city
    }
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "4617be9e27b25a22a7d598323d2c12d4"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                print(weatherJSON)
            } else {
                print(response.result.error)
                self.cityLabel.text = "Connection Issues"
            }
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
            print("long: \(location.coordinate.longitude) lat: \(location.coordinate.latitude)")
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            let params: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
}

