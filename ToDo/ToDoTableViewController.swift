//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by Rajkumar Desigachari on 1/6/17.
//  Copyright © 2017 Rajkumar Desigachari. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class ToDoTableViewController: UITableViewController {
    
    var dbRef:FIRDatabaseReference!
    var todos  = [ToDo]()
    
    var selectedRowText: String?
    var selectedRowSubText: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
       dbRef = FIRDatabase.database().reference().child("todo-items")
        startObservingDB()
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        /*let welcomeAlert = UIAlertController(title: "Welcome to my TodoApp ",message: FIRAuth.auth()?.currentUser?.email, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        welcomeAlert.addAction(defaultAction)
        self.presentViewController(welcomeAlert, animated:true, completion: nil) */
    }

    
    func startObservingDB() {
        dbRef.observe(.value, with: {(snapshot:FIRDataSnapshot) in
            var newTodo = [ToDo]()
            for todo in snapshot.children {
                let todoObject = ToDo(snapshot: todo as! FIRDataSnapshot)
                newTodo.append(todoObject)
            }
            self.todos = newTodo
            self.tableView.reloadData()
            }) { (Error) in
                print(Error.localizedDescription)
                
            }
    }

    
    
    
    
    @IBAction func presentTaskView(_ sender: AnyObject) {
        
        
        performSegue(withIdentifier: "TaskVC", sender: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.content
        cell.detailTextLabel?.text = todo.setTime
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
 override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             print(indexPath.row)
    let todo = todos[indexPath.row]
        print(todo.content)
        print(todo.setTime)
        self.selectedRowText = todo.content
         self.selectedRowSubText = todo.setTime
     _ = tableView.indexPathForSelectedRow!
    if let _ = tableView.cellForRow(at: indexPath){
        
      performSegue(withIdentifier: "TaskVC", sender: self)
    }
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    
      if  (segue.identifier! == "TaskVC"&&(self.tableView.indexPathForSelectedRow) != nil) {
       
        if let guest = segue.destination as? TaskViewController{
            let path = self.tableView.indexPathForSelectedRow
            let cell = self.tableView.cellForRow(at: path!)
        
          guest.selectedTitle = cell?.textLabel?.text
            guest.selectedSubTitle = cell?.detailTextLabel?.text
        }
      }else {
        if let guest = segue.destination as? TaskViewController{
            //let path = self.tableView.indexPathForSelectedRow
            //let cell = self.tableView.cellForRowAtIndexPath(path!)
            
            guest.selectedTitle = " "
            guest.selectedSubTitle = " "
        }
    }
    }
    



    
   

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let todo = todos[indexPath.row]
            
            todo.itemRef?.removeValue()
            
        }
     }
    
    

  
}
