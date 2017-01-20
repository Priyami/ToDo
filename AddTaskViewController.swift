//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Rajkumar Desigachari on 1/20/17.
//  Copyright © 2017 Rajkumar Desigachari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddTaskViewController: UIViewController {

    @IBOutlet var addTaskDesc: UITextField!
    
    @IBOutlet var addSetTime: UITextField!
    
    @IBOutlet var addTaskButton: UIButton!
    
    @IBOutlet var addPicker: UIDatePicker!
    
    var dbRef:FIRDatabaseReference!
    var task = [ToDo]()
    
    @IBAction func addDatePicker(_ sender: UIDatePicker) {
        
        //Date Picker Format and Sets in Textfield
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-YYYY hh:mm a"
        let strDate = dateFormat.string(from: addPicker.date)
        self.addSetTime.text = strDate
    }
    
    @IBAction func showAddPicker(_ sender: UITextField) {
        
        addPicker.isHidden = false
    }
    
    @IBAction func addNewTask(_ sender: UIButton) {
        
        //New Task added to Firebase Database by AutoId
        
        let taskContent = addTaskDesc.text
        let taskSetTime = addSetTime.text
        let task = ToDo(content: taskContent!, setTime: taskSetTime!)
        let todoRef = dbRef
        todoRef?.setValue(task.toAnyObject())
        let taskId: String = addTaskDesc.text!
        notificationSetter(addTaskButton, taskTypeId: taskId, fireDate: fixNotificationDate(addPicker.date))
    }
    
    
    fileprivate func notificationSetter(_ sender: UIButton, taskTypeId: String, fireDate: Date){
        
        //Notification Initiated
        
        if sender.isTouchInside == true{
            
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
    
    func fixNotificationDate(_ dateToFix: Date) ->Date{
        
        //Date and Time Fixed - UTC
        
        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var dateFire = Date()
        var fireComponents = (calendar as NSCalendar).components([.day,.month,.year,.hour,.minute], from: dateToFix)
        
        fireComponents.second = 0
        (fireComponents as NSDateComponents).timeZone = TimeZone.autoupdatingCurrent
        dateFire = calendar.date(from: fireComponents)!
        return dateFire
    }
    
    
    fileprivate func displayNotificationDisabled(){
        
        //Notification Setup Disabled - Alert Message to Enable
        
        let alertController = UIAlertController(title: "Notifications disabled for ToDo App", message: "Please enable Notifications in Settings -> Notifications -? ToDo", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference().child("todo-list").childByAutoId()

        // Do any additional setup after loading the view.
    }

       

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
