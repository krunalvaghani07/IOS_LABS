//
//  MapViewController.swift
//  Krunal_Vaghani_FE_8857416
//
//  Created by user228677 on 8/8/23.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var SearchedResult: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    //variable declaration
    var Coordinates : CLLocationCoordinate2D?
    var Address : String?
    var City : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        //set the textview text and render the map based on location
        if let Coordinate = Coordinates,let address = Address,let city = City{
            SearchedResult.text = "Address : \(address) \nCity: \(city) \nLatitude : \(Coordinate.latitude) \nLongitude : \(Coordinate.longitude)"
            //render the map
            self.render(Coordinate)
        }
        mapView.delegate = self
    }
    
    @IBAction func zoomInOut(_ sender: UISlider) {
        //set the sapn based on slider value (Note :decrease the span value will zoomin)
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(1 - (sender.value)), longitudeDelta: CLLocationDegrees(1 - (sender.value)))
        let region = MKCoordinateRegion(center: Coordinates!, span: span)
        mapView.setRegion(region, animated: true)
    }
    func render (_ Coordinate: CLLocationCoordinate2D) {
        //span settings determine how much to zoom into the map - defined details default is set to 1
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        //region for the map
        let region = MKCoordinateRegion(center: Coordinate, span: span)
        //set the pin on location
        let pin = MKPointAnnotation ()
        pin.coordinate = Coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(region, animated: true)
    }
    
}
