//
//  WeatherViewController.swift
//  Krunal_Vaghani_FE_8857416
//
//  Created by user228677 on 8/8/23.
//

import UIKit
import CoreLocation
import MapKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var SearchedResult: UITextView!
    @IBOutlet weak var weatherBgImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempretureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var errorLabel:UILabel!
    
    //variable declaration
    var Coordinates : CLLocationCoordinate2D?
    var Address : String?
    var City : String?
    let API_KEY = "ab8be759a0d4ccb34cf5f24b0f304b33"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        //set the textview text and call weather API
        if let Coordinate = Coordinates,let address = Address,let city = City{
            SearchedResult.text = "Address : \(address) \nCity: \(city) \nLatitude : \(Coordinate.latitude) \nLongitude : \(Coordinate.longitude)"
            self.errorLabel.text = ""
            self.getWeatherData(Coordinate.latitude, Coordinate.longitude)
        }
    }
    func getWeatherData(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) {
        //setup url
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(API_KEY)";
        //initialize the semaphore
        let semaphore = DispatchSemaphore (value: 0)
        //initialize the urlrequest
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        //creating task to fetch data with urlsession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                semaphore.signal()
                return
            }
            //initialize jsondecoder
            let jsonDecoder = JSONDecoder()
            do{
                //parse data into model
                let weatherData = try
                    jsonDecoder.decode(WeatherData.self, from: data)
                //because of execution happenning in the another thread
                DispatchQueue.main.async {
                    self.cityLabel.text = "\(weatherData.name)"
                    self.weatherDescriptionLabel.text = "\(weatherData.weather[0].main)"
                    self.setWeatherBackgroud(weatherData.weather[0].main)
                    self.tempretureLabel.text = "\(String(format: "%.1f", weatherData.main.temp - 273.15))°"
                    self.humidityLabel.text = "Humidity : \(weatherData.main.humidity)%"
                    self.windLabel.text = "Wind : \(String(format: "%.1f", weatherData.wind.speed * 3.6)) km/h"
                    let iconURLString = "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon).png"
                    self.setImage(from: iconURLString)
                }
                
            }catch{
                self.errorLabel.text = "Something went wrong please try again later"
            }
            //unlock the semaphore
            semaphore.signal()
        }
        
        task.resume()
        //wait for semaphore to signaled (waiting for the API request done)
        semaphore.wait()
    }
    
    func setWeatherBackgroud(_ weatherType:String)
    {
        //setup background image based on weather
        DispatchQueue.main.async {
            switch weatherType {
            case "Clear":
                self.weatherBgImageView.image = UIImage(named: "Clear")
            case "Clouds":
                self.weatherBgImageView.image = UIImage(named: "Clouds")
            case "Rain":
                self.weatherBgImageView.image = UIImage(named: "Rain")
            case "Drizzle":
                self.weatherBgImageView.image = UIImage(named: "Drizzle")
            case "Thunderstorm":
                self.weatherBgImageView.image = UIImage(named: "Thunderstorm")
            case "Mist":
                self.weatherBgImageView.image = UIImage(named: "Mist")
            case "Fog":
                self.weatherBgImageView.image = UIImage(named: "Fog")
            case "Smoke":
                self.weatherBgImageView.image = UIImage(named: "Smoke")
            case "Haze":
                self.weatherBgImageView.image = UIImage(named: "Haze")
            case "Sand":
                self.weatherBgImageView.image = UIImage(named: "Sand")
            case "Tornado":
                self.weatherBgImageView.image = UIImage(named: "Tornado")
            default:
                self.weatherBgImageView.image = UIImage(named: "Default")
            }
            
        }
    }
    //setup image from the url
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        DispatchQueue.main.async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.weatherImageView.image = image
            }
        }
    }
}
