//
//  MainViewController.swift
//  Krunal_Vaghani_FE_8857416
//
//  Created by user228677 on 8/8/23.
//

import UIKit
import MapKit
import NotificationCenter

class MainViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var searchLocationTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var MapButton: UIButton!
    @IBOutlet weak var errorLabel : UILabel!
    
    //variable for the storing selected locations
    var selectedLocation: CLLocation?
    var selectedAddress : String?
    var selectedCity : String?
    //list for the location table which will be shown if user start inserting into searchfield
    var matchingLocations:[MKMapItem] = []
    var isLocationSaved : Bool = false
    //table for the location suggetions
    let LocationTable = UITableView()
    
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //API Key for Unsplash image
    let IMAGE_API_KEY = "S5_jjcAbY4Sqqevus_gRnlej8XYGt0Ii-zUuqDsumDo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchLocationTextField.text = ""
        selectedLocation = nil
        selectedAddress = ""
        selectedCity = ""
        
        //setup for location table
        self.LocationTable.dataSource = self
        self.LocationTable.delegate = self
        self.LocationTable.isHidden = true
        self.LocationTable.allowsSelection = true
        self.LocationTable.allowsSelectionDuringEditing = true
        self.LocationTable.isUserInteractionEnabled = true
        view.addSubview(LocationTable)
        //constarins for the location table
        LocationTable.translatesAutoresizingMaskIntoConstraints = false
        LocationTable.topAnchor.constraint(equalTo: searchLocationTextField.bottomAnchor).isActive = true
        LocationTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        LocationTable.bottomAnchor.constraint(equalTo: MapButton.topAnchor).isActive = true
        LocationTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //register the cell
        LocationTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //setup for the tapgesture
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        //setup of notification for the keyboard refrence https://mohammed-r-ghate.medium.com/how-to-move-a-uitextfield-view-when-the-keyboard-appears-999751d1d0b5
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //when keyboard hide
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 120, right: 0)
        }
    }
    //when keyboard show
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -(keyboardSize.height + 120), right: 0)
        }
    }
    
    @IBAction func navigateToWeatherView(_ sender: Any) {
        //go to weather view
        searchLocationTextField.resignFirstResponder()
        navigateToNextVC(withIdentifier: "goToWeatherView")
    }
    
    @IBAction func navigateToMapView(_ sender: Any) {
        //go to map view
        searchLocationTextField.resignFirstResponder()
        navigateToNextVC(withIdentifier: "goToMapView")
    }
    
    func navigateToNextVC(withIdentifier identifier: String) {
        errorLabel.text = ""
        //if user not seleted location from the table
        if(selectedLocation?.coordinate == nil){
            //if user not entered any thing
            if(searchLocationTextField.text != ""){
                //location search from the string
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(searchLocationTextField.text!) {
                    (placemarks, error) in
                    guard let placemarks = placemarks,
                          let location = placemarks.first?.location
                    else {
                        self.errorLabel.text = "Can't find the city/address you entered"
                        return
                    }
                    //set the location
                    self.selectedAddress = self.parseAddress(selectedItem: MKPlacemark(placemark: placemarks.first!))
                    self.selectedCity = placemarks.first?.locality == nil ? self.searchLocationTextField!.text : placemarks.first?.locality
                    self.selectedLocation = location
                    //save location
                    self.saveLocation()
                    //pass data to next VC via segue
                    self.performSegue(withIdentifier: identifier, sender: self)
                }
            }else{
                errorLabel.text = "Please Enter City/Address"
                return
            }
            
        }else{
            //save location
            self.saveLocation()
            performSegue(withIdentifier: identifier, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToMapView"){
            //set the variable value of mapvieVC
            if let mapViewVC = segue.destination as? MapViewController{
                mapViewVC.Coordinates = self.selectedLocation?.coordinate
                mapViewVC.Address = self.selectedAddress
                mapViewVC.City = self.selectedCity
            }
        }
        if(segue.identifier == "goToWeatherView"){
            //set the variable value of weather view VC
            if let weatherViewVC = segue.destination as? WeatherViewController{
                weatherViewVC.Coordinates = self.selectedLocation?.coordinate
                weatherViewVC.Address = self.selectedAddress
                weatherViewVC.City = self.selectedCity
            }
        }
    }
    func saveLocation(){
        //condtion for not allowing to save mutiple time when user come back from the map/weather vc and want
        //to go for same or next VC
        if(!isLocationSaved){
            let location = Location(context: self.content)
            location.address = self.selectedAddress
            location.city = self.selectedCity == nil ? self.selectedAddress: self.selectedCity
            location.latitude = Double(self.selectedLocation!.coordinate.latitude)
            location.longitude = Double(self.selectedLocation!.coordinate.longitude)
            location.imageUrl = self.getImageUrl(location.city!)
            do{
                try self.content.save()
                isLocationSaved = !isLocationSaved
            }catch{
                print("Error saving data")
                return
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        //dismiss the keyboard
        searchLocationTextField.resignFirstResponder()
    }
    
    @IBAction func SearchBarValueChanged(_ sender: UITextField) {
        selectedLocation = nil
        isLocationSaved = false
        let searchVal = sender.text
        self.matchingLocations.removeAll()
        //search for the locations based on user start editing
        let mapView = MKMapView()
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = mapView.region
        searchRequest.naturalLanguageQuery = searchVal
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            //set locaiontable items
            self.matchingLocations = response.mapItems
            self.LocationTable.reloadData()
            self.LocationTable.isHidden = false
        }
        //if not matching location found
        if(matchingLocations.count == 0){
            self.LocationTable.isHidden = true
        }
        //reload the table
        self.LocationTable.reloadData()
        
    }
    
    func getImageUrl(_ city : String)-> String{
        var imageUrl = ""
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=1&query=\(city)&client_id=\(IMAGE_API_KEY)";
        let defaultURL = "https://api.unsplash.com/search/photos?page=1&per_page=1&query=Downtown&client_id=\(IMAGE_API_KEY)"
        //code for API Request
        let semaphore = DispatchSemaphore (value: 0)
        //Initiate URLrequest
        var request = URLRequest(url: URL(string: urlString) ?? URL(string: defaultURL)!,timeoutInterval: Double.infinity)
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
                let imageDataModel = try
                    jsonDecoder.decode(UnsplashResponse.self, from: data)
                imageUrl = imageDataModel.results[0].urls.regular
                
            }catch{
                return
            }
            //unlock the semaphore
            semaphore.signal()
        }
        
        task.resume()
        //wait for semaphore to signaled (waiting for the API request done)
        semaphore.wait()
        return imageUrl
    }
    
    //necessary methods for the table view
    func numberOfSections(in mytableView: UITableView) -> Int {
        //number of section
        return 1
    }
    func tableView(_ mytableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //umber of rows in section
        return matchingLocations.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //this code will selecte the location from the table if user want to select location from the table
        //and hide the table with removing all items
        //select location from the table when touched
        let selectedMapItem = matchingLocations[indexPath.row]
        //setting variable for seletedlocations
        searchLocationTextField.text = selectedMapItem.placemark.name
        selectedLocation = selectedMapItem.placemark.location
        selectedCity = selectedMapItem.placemark.locality
        selectedAddress = self.parseAddress(selectedItem: selectedMapItem.placemark)
        //remove all item
        matchingLocations.removeAll()
        //hide the table
        LocationTable.isHidden = true
    }
    func tableView(_ mytableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = mytableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //setup style for the tablecell
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = .default
        let selectedItem = matchingLocations[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
    
    //refrence from the https://thorntech.com/how-to-search-for-location-using-apples-mapkit/
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
}
