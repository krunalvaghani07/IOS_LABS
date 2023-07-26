//
//  MyTableViewTableViewController.swift
//  CodeDataApplication
//
//  Created by user228677 on 7/19/23.
//

import UIKit

class MyTableViewTableViewController: UITableViewController {
    
    var personList:[Person] = []
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var personTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        personTable.delegate = self
        personTable.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoItem")
        fetchPerson()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func fetchPerson(){
        do{
            self.personList = try content.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.personTable.reloadData()
            }
        }catch{
            print("no data")
        }
    }

    @IBAction func addTodoItems(_ sender: UIButton) {
        let alertCont = UIAlertController(
            title: "Add Person",
            message: "",
            preferredStyle: .alert)
        
        //adding textfield to alert
        alertCont.addTextField{ (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Person Name"
        }
        alertCont.addTextField{ (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Person Age"
        }
        alertCont.addTextField{ (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Work HairColor"
        }
        
        alertCont.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertCont.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
            let personName = alertCont.textFields![0] as UITextField
            let personAge = alertCont.textFields![1] as UITextField
            let personHairColor = alertCont.textFields![1] as UITextField
            
            let person = Person(context: self.content)
            person.name = personName.text
            person.age = personAge.text
            person.hairColor = personHairColor.text
            do{
                try self.content.save()
            }catch{
                print("Error saving data")
            }
            //append into array
            //self.personList.append(todoInput!)
            //reload table
            self.fetchPerson()
            self.tableView.reloadData()
            
            
        }))
        //present alert
        present(alertCont, animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.personList.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem", for: indexPath)

        let cellItem = self.personList[indexPath.row]
        cell.textLabel?.text = cellItem.name
        cell.detailTextLabel?.text = cellItem.age

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let personToRemove = self.personList[indexPath.row]
            self.content.delete(personToRemove)
            do{
                try self.content.save()
            }catch{
                print("error in saving data")
            }
            self.personList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
