//
//  InputViewViewController.swift
//  Krunal_Vaghani_MT_8857416
//
//  Created by user228677 on 6/26/23.
//

import UIKit

class InputViewViewController: UIViewController {
    
    //outlet for image view
    @IBOutlet weak var cityImageView: UIImageView!
    //outlet for city input
    @IBOutlet weak var cityTextInput: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        cityTextInput.resignFirstResponder()
    }
    
    @IBAction func FindMyCity_Click(_ sender: UIButton) {
        
        //dismiss city input keyboard
        cityTextInput.resignFirstResponder()
        
        //remove text from the error label
        errorMessageLabel.text = ""
        
        //if user entered the value then check using switch
        if(cityTextInput.text != ""){
            
            //checking with the lowecases of the user input
            switch cityTextInput.text?.lowercased() {
            case "calgary":
                cityImageView.image = UIImage(named: "Calgary")
            case "halifax":
                cityImageView.image = UIImage(named: "Halifax")
            case "montreal":
                cityImageView.image = UIImage(named: "Montreal")
            case "toronto":
                cityImageView.image = UIImage(named: "Toronto")
            case "vancouver":
                cityImageView.image = UIImage(named: "Vancouver")
            case "winnipeg":
                cityImageView.image = UIImage(named: "Winnipeg")
            //if user entered the value but city did not found
            default:
                errorMessageLabel.text = "Can't find the entered city"
                cityImageView.image = UIImage(named: "Canada")
            }
        }else{
            //if user did not entered anything
            errorMessageLabel.text = "Enter the city Please"
            cityImageView.image = UIImage(named: "Canada")
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
