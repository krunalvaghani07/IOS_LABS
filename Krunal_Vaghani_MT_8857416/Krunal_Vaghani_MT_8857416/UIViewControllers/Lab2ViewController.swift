//
//  ViewController.swift
//  Lab2
//
//  Created by user228677 on 5/17/23.
//

import UIKit

class Lab2ViewController: UIViewController {
    var count = 0
    var isTwo:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBOutlet weak var counter: UILabel!



    @IBAction func decrement(_ sender: Any) {
        if(isTwo){
            count = count - 2
        }else{
            count = count - 1
        }
        
        counter.text = String(count)
        
    }
    
    
    
    @IBAction func increment(_ sender: Any) {
        if(isTwo){
            count = count + 2
        }else{
            count = count + 1
        }
        counter.text = String(count)
    }
    
    
    @IBAction func reset(_ sender: Any) {
        count = 0
        counter.text = String(count)
        
    }
    
    
    @IBAction func steppingcount(_ sender: Any) {
        isTwo = !isTwo
       
    }
    
}

