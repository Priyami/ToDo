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
   
    
    override func viewDidAppear(animated: Bool) {
        /*let welcomeAlert = UIAlertController(title: "Welcome to my TodoApp ",message: FIRAuth.auth()?.currentUser?.email, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        welcomeAlert.addAction(defaultAction)
        self.presentViewController(welcomeAlert, animated:true, completion: nil) */
    }

    
    func startObservingDB() {
        dbRef.observeEventType(.Value, withBlock: {(snapshot:FIRDataSnapshot) in
            var newTodo = [ToDo]()
            for todo in snapshot.children {
                let todoObject = ToDo(snapshot: todo as! FIRDataSnapshot)
                newTodo.append(todoObject)
            }
            self.todos = newTodo
            self.tableView.reloadData()
            }) { (error:NSError) in
                print(error.description)
                
            }
    }

    
    
    
    
    @IBAction func presentTaskView(sender: AnyObject) {
        
        
        performSegueWithIdentifier("TaskVC", sender: nil)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }
    
 override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
             print(indexPath.row)
    let todo = todos[indexPath.row]
        print(todo.content)
        print(todo.setTime)
        self.selectedRowText = todo.content
         self.selectedRowSubText = todo.setTime
     _ = tableView.indexPathForSelectedRow!
    if let _ = tableView.cellForRowAtIndexPath(indexPath){
        
      performSegueWithIdentifier("TaskVC", sender: self)
    }
    }
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    
      if  (segue.identifier! == "TaskVC"&&(self.tableView.indexPathForSelectedRow) != nil) {
       
        if let guest = segue.destinationViewController as? TaskViewController{
            let path = self.tableView.indexPathForSelectedRow
            let cell = self.tableView.cellForRowAtIndexPath(path!)
        
          guest.selectedTitle = cell?.textLabel?.text
            guest.selectedSubTitle = cell?.detailTextLabel?.text
        }
      }else {
        if let guest = segue.destinationViewController as? TaskViewController{
            //let path = self.tableView.indexPathForSelectedRow
            //let cell = self.tableView.cellForRowAtIndexPath(path!)
            
            guest.selectedTitle = " "
            guest.selectedSubTitle = " "
        }
    }
    }
    



    
   

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let todo = todos[indexPath.row]
            
            todo.itemRef?.removeValue()
            
        }
     }
    
    

  
}
