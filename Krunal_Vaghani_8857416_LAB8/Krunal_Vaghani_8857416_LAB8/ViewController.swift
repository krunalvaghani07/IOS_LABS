//
//  ViewController.swift
//  Krunal_Vaghani_8857416_LAB8
//
//  Created by user228677 on 7/17/23.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{

    let manager  = CLLocationManager()
    let API_KEY = "ab8be759a0d4ccb34cf5f24b0f304b33"
    
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    
    @IBOutlet weak var weatherTempreture: UILabel!
    
    @IBOutlet weak var weatherHumidity: UILabel!
    
    @IBOutlet weak var windSpeed: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.getWWeatherData(location.coordinate.latitude, location.coordinate.longitude)
        
    }
    func getWWeatherData(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(API_KEY)";
        
        /* let urlSession = URLSession(configuration:.default)
        let url = URL(string: urlString)
        
        if let url = url{
            let dataTask = urlSession.dataTask(with: url) { (data,
            response, error) in
                if let data = data {
                    print(data)
                }
            }
        }*/
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          let jsonDecoder = JSONDecoder()
            do{
                let weatherData = try
                    jsonDecoder.decode(WeatherData.self, from: data)
                print(weatherData)
                //because of execution happenning in the another thread
                DispatchQueue.main.async {
                    self.cityName.text = "\(weatherData.name)"
                    self.weatherDescription.text = "\(weatherData.weather[0].description)"
                    self.weatherTempreture.text = "\(String(format: "%.1f", weatherData.main.temp - 273.15))°"
                    self.weatherHumidity.text = "Humidity : \(weatherData.main.humidity)%"
                    self.windSpeed.text = "Wind : \(String(format: "%.1f", weatherData.wind.speed * 3.6)) km/h"
                    let iconURLString = "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon).png"
                    self.setImage(from: iconURLString)
                }
                
            }catch{
                print("Can't Decode")
            }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

        
    }
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.main.async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.weatherImage.image = image
            }
        }
    }
}

