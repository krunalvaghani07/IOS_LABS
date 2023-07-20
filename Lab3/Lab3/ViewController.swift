//
//  ViewController.swift
//  Lab3
//
//  Created by user228677 on 5/24/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var userMessage: UILabel!
    
    @IBOutlet weak var allData: UITextView!
    
    
    @IBOutlet weak var fName: UITextField!
    
    @IBOutlet weak var lName: UITextField!
    
    @IBOutlet weak var country: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    
    @IBAction func firstName(_ sender: UITextView) {
        if(!sender.text!.isEmpty){
            userInfoMesageString()
        }
        
    }
    

    @IBAction func lastName(_ sender: UITextView) {
        if(!sender.text!.isEmpty){
            userInfoMesageString()
        }
    }
    


    @IBAction func country(_ sender: UITextView) {
        if(!sender.text!.isEmpty){
            userInfoMesageString()
        }
    }
    

    @IBAction func age(_ sender: UITextView) {
        if(!sender.text!.isEmpty){
            userInfoMesageString()
        }
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        userInfoMesageString()
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        if(fName.text! == "" || lName.text! == "" || country.text! == "" || age.text! == ""){
            userMessage.text = "Add Missing Info"
        }else{
            userMessage.text = "successfully submitted"
           ()
        }
    }
    
    @IBAction func clearBtn(_ sender: UIButton) {
        clearAll()
    }
    
    func userInfoMesageString(){
        allData.text = "Full Name : \(fName.text!)  \(lName.text!)  \nCountry : \(country.text!)\nAge : \(age.text!)"
    }
    func clearAll(){
        fName.text = ""
        lName.text = ""
        country.text = ""
        age.text = ""
        userMessage.text = ""
        allData.text = ""
    }
        
}

