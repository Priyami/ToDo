//
//  LocalNotificationHelper.swift
//  ToDo
//
//  Created by Rajkumar Desigachari on 1/10/17.
//  Copyright © 2017 Rajkumar Desigachari. All rights reserved.
//

import UIKit

class LocalNotificationHelper: NSObject {
     var badgeCount = 0
    
    func checkNotificationEnabled() -> Bool{
        
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else
        
        { return false }
        
        if settings.types == .None {
            
            return false
            
        }
        else {
            return true
        }
        
        
    }
    
    func checkNotificationExists(taskTypeId: String) -> Bool {
        
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as
            [UILocalNotification] {
                
                if(notification.userInfo!["taskObjectId"] as! String == String(taskTypeId)) {
                    
                    return true
                }
        }
        return false
        
        
    }
    
    func scheduleLocal(taskTypeId: String, alertDate: NSDate){
       
        print("Date and Time Came\(alertDate)")
        let notification = UILocalNotification()
        notification.fireDate = alertDate
        notification.alertBody = "Task \(taskTypeId)"
        notification.alertAction = "Due : \(alertDate)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["taskObjeckId": taskTypeId]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        UIApplication.sharedApplication().applicationIconBadgeNumber = ++badgeCount
        print("Notification set for taskTypeId: \(taskTypeId) at \(alertDate)")
        
        
    }
    
    func removeNotification(taskTypeId: String){
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as
            [UILocalNotification]{
                
                if(notification.userInfo!["taskObjectId"] as! String == String(taskTypeId)){
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                print("Notification deleted for TaskTypeID: \(taskTypeId)")
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                break
                
                }
         }
    }
    
    func listNotifications() -> [UILocalNotification] {
        
        var localNotify:[UILocalNotification]?
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as
            [UILocalNotification]{
                localNotify?.append(notification)
        }
        
        return localNotify!
            
            
        }
    
        func printNotifications() {
        
        print("List of notifications currently set:-")
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            
            print("\(notification)")
            
            
        }
    
    
     }
    

}
