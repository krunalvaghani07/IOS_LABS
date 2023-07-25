//
//  FunctionViewViewController.swift
//  Krunal_Vaghani_MT_8857416
//
//  Created by user228677 on 6/28/23.
//

import UIKit

class FunctionViewViewController: UIViewController {

    //outlet for A text field
    @IBOutlet weak var inputTextA: UITextField!
    
    //outlet for B text field
    @IBOutlet weak var inputTextB: UITextField!
    
    //outlet for usermessage label
    @IBOutlet weak var userMessage: UILabel!
    
    //outlet label for value of C
    @IBOutlet weak var calculatedValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func claculateValueofC(_ sender: UIButton) {
        //get the value of A
        let valueOfA = inputTextA.text
        //get the value of B
        let valueOfB = inputTextB.text
        //setting the value of C to empty
        calculatedValue.text = ""
        
        //checking if value of a or value b is non empty
        if(valueOfA != "" && valueOfB != ""){
            //check if Both A or B is valid here if it is invalid numberA or numberB will be nill
            if let numberA = Double(valueOfA!), let numberB = Double(valueOfB!){
                //calculating value of c
                let numberC = sqrt(pow(numberA, 2) + pow(numberB, 2))
                //setting usermessage
                userMessage.text = "The value of C according to Pythagorean is"
                //setting value of c
                calculatedValue.text = String(numberC)
            }else if(Double(valueOfA!) == nil && Double(valueOfB!) == nil){
                //if value of a and b is invalid
                userMessage.text = "The value you entered for A and B is invalid."
            }else if(Double(valueOfA!) == nil){
                //if value of b is invalid
                userMessage.text = "The value you entered for A is invalid."
            }
            else if(Double(valueOfB!) == nil){
                //if value of b is invalid
                userMessage.text = "The value you entered for B is invalid."
            }
        }else{
            userMessage.text = "Enter a value for A and B to find C."
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        inputTextA.resignFirstResponder()
        inputTextB.resignFirstResponder()
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        inputTextA.text = ""
        inputTextA.resignFirstResponder()
        inputTextB.text = ""
        inputTextB.resignFirstResponder()
        userMessage.text = "Enter a value for A and B to find C."
        calculatedValue.text = ""
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
