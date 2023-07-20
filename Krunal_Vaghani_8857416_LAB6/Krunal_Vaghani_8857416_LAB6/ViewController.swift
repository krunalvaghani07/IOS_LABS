//
//  ViewController.swift
//  Krunal_Vaghani_8857416_LAB6
//
//  Created by user228677 on 6/14/23.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var toDoTableView: UITableView!
   
    var todoListArr:[String] = ["Todo Item 1"]
    func numberOfSections(in mytableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ mytableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListArr.count
    }
   
    
    func tableView(_ mytableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableView.dequeueReusableCell(withIdentifier: "myFreindsm2", for: indexPath)
        cell.textLabel?.text = todoListArr[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.toDoTableView.dataSource = self
        self.toDoTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            //removing item from the array
            self.todoListArr.remove(at: indexPath.row)
            //reloading the table
            self.toDoTableView.reloadData()
        }
    }
    
    @IBAction func OpenAlert(_ sender: UIButton) {
        let alertCont = UIAlertController(
            title: "Add Item",
            message: "",
            preferredStyle: .alert)
        
        //adding textfield to alert
        alertCont.addTextField{ (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Second Name"
        }
        
        alertCont.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertCont.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
            let alertTextField = alertCont.textFields![0] as UITextField
            let todoInput = alertTextField.text
            //if input is empty then return
            if(todoInput!.isEmpty){
                return
            }
            //append into array
            self.todoListArr.append(todoInput!)
            //reload table
            self.toDoTableView.reloadData()
            
        }))
        //present alert
        present(alertCont, animated: true)
    }
    


}

