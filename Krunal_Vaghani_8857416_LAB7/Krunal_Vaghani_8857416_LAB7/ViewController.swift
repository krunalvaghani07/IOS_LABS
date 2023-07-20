//
//  ViewController.swift
//  Krunal_Vaghani_8857416_LAB7
//
//  Created by user228677 on 7/7/23.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    
    @IBOutlet weak var CurrentSpeed: UILabel!
    
    
    @IBOutlet weak var MaxSpeed: UILabel!
    
    
    @IBOutlet weak var AverageSpeed: UILabel!
    
    
    @IBOutlet weak var Distance: UILabel!
    
    @IBOutlet weak var MaxAccelaration: UILabel!
    
    
    @IBOutlet weak var MyMapView: MKMapView!
    
    @IBOutlet weak var TopBarView: UIView!
    
    @IBOutlet weak var BottomBarView: UIView!
    
    
    @IBOutlet weak var DistanceToMaxSpeed: UILabel!
    let manager  = CLLocationManager()
    var isSpeedLimitReached : Bool = false
    var locationValues: [CLLocation] = []
    var speedValues: [Double] = []
    var accelarationValues: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
      
    }
    
    @IBAction func StartTrip(_ sender: UIButton) {
        manager.startUpdatingLocation()
        BottomBarView.backgroundColor = .systemGreen
    }
    
    @IBAction func StopTrip(_ sender: Any) {
        manager.stopUpdatingLocation()
        BottomBarView.backgroundColor = .darkGray
        locationValues.removeAll()
        speedValues.removeAll()
        accelarationValues.removeAll()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        locationValues.append(location)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let mylocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: mylocation, span: span)
        
        MyMapView.setRegion(region, animated: true)
        self.MyMapView.showsUserLocation = true
        
        //converting spped in m/s to km/h
        let speed = location.speed
        speedValues.append(speed)
        
        //sum of the elements in the array
        let sumSpeed = speedValues.reduce(0, +)
        //array length
        let speedArraylength = speedValues.count
        //average of the array
        let averageSpeed =  Double(sumSpeed)/Double(speedArraylength)
        
        //calculate accelaration
        if(locationValues.count > 2){
            let locationArrayLength = locationValues.count
            let timeSpan = location.timestamp.timeIntervalSince(locationValues[locationArrayLength - 2].timestamp)
            let speedDifference = speedValues[speedValues.count - 1] - speedValues[speedValues.count - 2]
            let accelaration = speedDifference / timeSpan
            accelarationValues.append(accelaration)
            MaxAccelaration.text = "\(Double(round(1000 * accelarationValues.max()!) / 1000)) m/s^2"
        }
        
        
        CurrentSpeed.text = "\(Double(round(1000 * location.speed * (3.6)) / 1000)) km/h"
        
        MaxSpeed.text = "\(Double(round(1000 * speedValues.max()! * (3.6)) / 1000)) km/h"
        
        AverageSpeed.text = "\(Double(round(1000 * averageSpeed * (3.6)) / 1000)) km/h"
        
        Distance.text = "\(Double(round(1000 * location.distance(from: locationValues[0])/1000) / 1000)) km"
       
     
        //checking for the speed limit
        if(Double(round(1000 * location.speed * (3.6)) / 1000) > 115){
          
            if(!isSpeedLimitReached){
                TopBarView.backgroundColor = .red
                isSpeedLimitReached = true
                DistanceToMaxSpeed.text = "\(Double(round(1000 * location.distance(from: locationValues[0])/1000) / 1000)) km"
            }
        }else{
            TopBarView.backgroundColor = .white
            DistanceToMaxSpeed.text = ""
            isSpeedLimitReached = false
        }
       
    }
   
    

    
}

