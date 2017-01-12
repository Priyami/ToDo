//
//  TaskViewController.swift
//  ToDo
//
//  Created by Rajkumar Desigachari on 1/9/17.
//  Copyright © 2017 Rajkumar Desigachari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TaskViewController: UIViewController{
 var dbRef:FIRDatabaseReference!
    var todos  = [ToDo]()
    
    @IBOutlet var TaskView: UIView!
   

    @IBOutlet var setTime: UITextField!
    
    
    @IBOutlet var taskDesc: UITextField!
   
    @IBOutlet var createdBy: UITextField!
    
   
    @IBOutlet var addButton: UIButton!
    @IBOutlet var picker: UIDatePicker!
    var data = NSDate()
    @IBAction func datePickerAction(sender: AnyObject) {
        
        let  dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY hh:mm a"
        let  strDate = dateFormatter.stringFromDate(picker.date)
        self.setTime.text = strDate
        

    }
    @IBAction func showPicker(sender: AnyObject) {
       picker.hidden = false
        
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        picker.hidden = true
          let cuUser = FIRAuth.auth()?.currentUser
        
        dbRef = FIRDatabase.database().reference().child("todo-items")

        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func addTask(sender: AnyObject) {
        
        let todoContent = taskDesc.text
        //let todoUser = createdBy.text
        let reminderTime = setTime.text
        
            let todo = ToDo(content: todoContent!,setTime: reminderTime! )
            let todoRef = self.dbRef.child(todoContent!.lowercaseString)
            todoRef.setValue(todo.toAnyObject())
      
        
        let taskTypeId:String = taskDesc.text!
        
        notificationSetter(addButton, taskTypeId: taskTypeId, fireDate: fixNotificationDate(picker.date))
        
           }
    
    
    private func notificationSetter(sender: UIButton, taskTypeId: String, fireDate: NSDate){
        
        if sender.touchInside == true{
            
            if LocalNotificationHelper().checkNotificationEnabled() == true{
                
                LocalNotificationHelper().scheduleLocal(taskTypeId, alertDate: fireDate)
               // print("Scheduled the Notification at \(fireDate)")
            }
            else{
                
                displayNotificationDisabled()
            }
        }else{
                
                if LocalNotificationHelper().checkNotificationExists(taskTypeId) == true {
                    
                    LocalNotificationHelper().removeNotification(taskTypeId)
                    print("Removing Notitification \(taskTypeId)")
                }
            }
        }
    
    func fixNotificationDate(dateToFix: NSDate) ->NSDate{
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var dateFire = NSDate()
        let fireComponents = calendar.components([.Day,.Month,.Year,.Hour,.Minute], fromDate: dateToFix)
        
        fireComponents.second = 0
        fireComponents.timeZone = NSTimeZone.localTimeZone()
        dateFire = calendar.dateFromComponents(fireComponents)!
        return dateFire
    }
    
    
    private func displayNotificationDisabled(){
        
        let alertController = UIAlertController(title: "Notifications disabled for ToDo App", message: "Please enable Notifications in Settings -> Notifications -? ToDo", preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
