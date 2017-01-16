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
    var selectedTitle:String?
    var selectedSubTitle:String?
 var dbRef:FIRDatabaseReference!
    var todos  = [ToDo]()
    
    @IBOutlet var TaskView: UIView!
   

   
    @IBOutlet var setTime: UITextField!
    
    
    @IBOutlet var taskDesc: UITextField!
   
    
       
    @IBOutlet var addButton: UIButton!
    @IBOutlet var picker: UIDatePicker!
    var data = Date()
    @IBAction func datePickerAction(_ sender: AnyObject) {
        
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY hh:mm a"
        let  strDate = dateFormatter.string(from: picker.date)
        self.setTime.text = strDate
        

    }
    @IBAction func showPicker(_ sender: AnyObject) {
       picker.isHidden = false
        
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        picker.isHidden = true
        
        taskDesc.text = selectedTitle
        self.setTime.text = selectedSubTitle
        dbRef = FIRDatabase.database().reference().child("todo-items")

        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func addTask(_ sender: AnyObject) {
        
        let todoContent = taskDesc.text
        //let todoUser = createdBy.text
        let reminderTime = setTime.text
        
            let todo = ToDo(content: todoContent!,setTime: reminderTime! )
            let todoRef = self.dbRef.child(todoContent!.lowercased())
            todoRef.setValue(todo.toAnyObject())
      
        
        let taskTypeId:String = taskDesc.text!
        
        notificationSetter(addButton, taskTypeId: taskTypeId, fireDate: fixNotificationDate(picker.date))
        
           }
    
    
    fileprivate func notificationSetter(_ sender: UIButton, taskTypeId: String, fireDate: Date){
        
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
        
        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var dateFire = Date()
        var fireComponents = (calendar as NSCalendar).components([.day,.month,.year,.hour,.minute], from: dateToFix)
        
        fireComponents.second = 0
        (fireComponents as NSDateComponents).timeZone = TimeZone.autoupdatingCurrent
        dateFire = calendar.date(from: fireComponents)!
        return dateFire
    }
    
    
    fileprivate func displayNotificationDisabled(){
        
        let alertController = UIAlertController(title: "Notifications disabled for ToDo App", message: "Please enable Notifications in Settings -> Notifications -? ToDo", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
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
