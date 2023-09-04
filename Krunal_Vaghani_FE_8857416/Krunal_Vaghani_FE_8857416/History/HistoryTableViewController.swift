//
//  HistoryTableViewController.swift
//  Krunal_Vaghani_FE_8857416
//
//  Created by user228677 on 8/11/23.
//

import UIKit
import CoreLocation

class HistoryTableViewController: UITableViewController {
    
    
    @IBOutlet var historyTable: UITableView!
    
    //declaring variables
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var locationList:[Location] = []
    let API_KEY = "S5_jjcAbY4Sqqevus_gRnlej8XYGt0Ii-zUuqDsumDo"
    var SelectedLocationIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //table datasource and delegate
        historyTable.dataSource = self
        historyTable.delegate = self
        //fetch location from the core data
        self.fetchLocation()
    }
    
    @IBAction func mapButtonClicked(_ sender: UIButton) {
        //set the index based on which button clicked
        SelectedLocationIndex = sender.tag
        //pass the data from the segue
        self.performSegue(withIdentifier: "goToMapView", sender: self)
    }
    
    @IBAction func weatherButtonClicked(_ sender: UIButton) {
        //set the index based on which button clicked
        SelectedLocationIndex = sender.tag
        //pass the data from the segue
        self.performSegue(withIdentifier: "goToWeatherView", sender: self)
    }
    
    @IBAction func addNewLocation(_ sender: Any) {
        //iniatialize alert controller
        let alertController = UIAlertController(
            title: "Add City/Address",
            message: "",
            preferredStyle: .alert)
        
        //adding textfield to alert
        alertController.addTextField{ (textField : UITextField!) -> Void in
            textField.placeholder = "Search City/Address"
        }
        //add action buttons
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
            //get the data user entered in alert
            let searchedAddress = alertController.textFields![0] as UITextField
            //check for the empty string
            if(searchedAddress.text != ""){
                //search for the address based on user input
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(searchedAddress.text!) {
                    (placemarks, error) in
                    guard let placemarks = placemarks,
                          let location = placemarks.first?.location
                    else {
                        print ("no location found")
                        return
                    }
                    //save location into core data
                    let newLocation = Location(context: self.content)
                    newLocation.address = searchedAddress.text!
                    newLocation.city = placemarks.first?.locality == nil ? searchedAddress.text : placemarks.first?.locality
                    newLocation.latitude = Double(location.coordinate.latitude)
                    newLocation.longitude = Double(location.coordinate.longitude)
                    newLocation.imageUrl = self.getImageUrl(newLocation.city!)
                    do{
                        try self.content.save()
                    }catch{
                        print("Error saving data")
                    }
                    
                    //fetch data and reload table
                    self.fetchLocation()
                    self.tableView.reloadData()
                }
            }
        }))
        //present alert
        present(alertController, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToMapView"){
            //setup mapviewVC
            if let mapViewVC = segue.destination as? MapViewController{
                let SelectedLocation = self.locationList[SelectedLocationIndex!]
                let Coordinate = CLLocationCoordinate2D(latitude: SelectedLocation.latitude, longitude: SelectedLocation.longitude)
                mapViewVC.Coordinates = Coordinate
                mapViewVC.Address = SelectedLocation.address
                mapViewVC.City = SelectedLocation.city
            }
        }
        if(segue.identifier == "goToWeatherView"){
            //setup weatherView VC
            if let weatherViewVC = segue.destination as? WeatherViewController{
                let SelectedLocation = self.locationList[SelectedLocationIndex!]
                let Coordinate = CLLocationCoordinate2D(latitude: SelectedLocation.latitude, longitude: SelectedLocation.longitude)
                weatherViewVC.Coordinates = Coordinate
                weatherViewVC.Address = SelectedLocation.address
                weatherViewVC.City = SelectedLocation.city
            }
        }
    }
    func fetchLocation(){
        do{
            self.locationList = try content.fetch(Location.fetchRequest())
            //reverse the list(latest data will come first now)
            self.locationList.reverse()
            DispatchQueue.main.async {
                self.historyTable.reloadData()
            }
        }catch{
            print("no data")
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return locationList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //setup for cell in tableview
        let location = locationList[indexPath.row]
        //custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        cell.cityValLabel.text = location.city
        cell.latitudeValLabel.text = String(location.latitude)
        cell.longitudeValLabel.text = String(location.longitude)
        //set button tag as index
        cell.mapButton.tag = indexPath.row
        cell.weatherButton.tag = indexPath.row
        //city image in cell
        if let imageurl = location.imageUrl{
            if(imageurl != ""){
                let imageURL = URL(string: location.imageUrl!)
                do{
                    let imageData = try Data(contentsOf: imageURL!)
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
                catch{
                    cell.cityImageView.image = UIImage(named: "city")
                }
            }else{
                cell.cityImageView.image = UIImage(named: "city")
            }
        }else{
            cell.cityImageView.image = UIImage(named: "city")
        }
        //adding image in stack(sometime image goes outof cell so this code will set the image constrains)
        cell.imageStack.addSubview(cell.imageView!)
        cell.imageView?.translatesAutoresizingMaskIntoConstraints = false
        cell.imageView?.clipsToBounds = true
        cell.imageView?.heightAnchor.constraint(equalToConstant: 120).isActive = true
        cell.imageView?.widthAnchor.constraint(equalToConstant: 160).isActive = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //fix height for row
        return 240
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let locationToRemove = self.locationList[indexPath.row]
            //delete location from coredata
            self.content.delete(locationToRemove)
            do{
                try self.content.save()
            }catch{
                print("error in saving data")
            }
            //remove from the list and reload the table
            self.locationList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func getImageUrl(_ city : String)-> String{
        //API calling for getting image
        var imageUrl = ""
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=1&query=\(city)&client_id=\(API_KEY)";
        let defaultURL = "https://api.unsplash.com/search/photos?page=1&per_page=1&query=Downtown&client_id=\(API_KEY)"
        //initialize semaphore
        let semaphore = DispatchSemaphore (value: 0)
        //Initiate URLrequest
        var request = URLRequest(url: URL(string: urlString) ?? URL(string: defaultURL)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        //making task to fetch data using urlsession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                //unlock the semaphore
                semaphore.signal()
                return
            }
            let jsonDecoder = JSONDecoder()
            do{
                //parse the data into model
                let imageDataModel = try
                    jsonDecoder.decode(UnsplashResponse.self, from: data)
                imageUrl = imageDataModel.results[0].urls.regular
                
            }catch{
                imageUrl = defaultURL
                return
            }
            //unlock the semaphore
            semaphore.signal()
        }
        
        task.resume()
        //wait for semaphore to be signaled
        semaphore.wait()
        return imageUrl
    }
}
