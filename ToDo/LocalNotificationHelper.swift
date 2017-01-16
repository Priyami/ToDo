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
        
        guard let settings = UIApplication.shared.currentUserNotificationSettings else
        
        { return false }
        
        if settings.types == UIUserNotificationType() {
            
            return false
            
        }
        else {
            return true
        }
        
        
    }
    
    func checkNotificationExists(_ taskTypeId: String) -> Bool {
        
        
        for notification in UIApplication.shared.scheduledLocalNotifications! as
            [UILocalNotification] {
                
                if(notification.userInfo!["taskObjectId"] as? String == String(taskTypeId)) {
                    
                    return true
                }
        }
        return false
        
        
    }
    
    func scheduleLocal(_ taskTypeId: String, alertDate: Date){
       
        print("Date and Time Came\(alertDate)")
        let notification = UILocalNotification()
        notification.fireDate = alertDate
        notification.alertBody = "Task \(taskTypeId)"
        notification.alertAction = "Due : \(alertDate)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["taskObjeckId": taskTypeId]
        UIApplication.shared.scheduleLocalNotification(notification)
        UIApplication.shared.applicationIconBadgeNumber = badgeCount +  1
        print("Notification set for taskTypeId: \(taskTypeId) at \(alertDate)")
        
        
    }
    
    func removeNotification(_ taskTypeId: String){
        
        for notification in UIApplication.shared.scheduledLocalNotifications! as
            [UILocalNotification]{
                
                if(notification.userInfo!["taskObjectId"] as? String == String(taskTypeId)){
                UIApplication.shared.cancelLocalNotification(notification)
                print("Notification deleted for TaskTypeID: \(taskTypeId)")
                UIApplication.shared.applicationIconBadgeNumber = 0
                break
                
                }
         }
    }
    
    func listNotifications() -> [UILocalNotification] {
        
        var localNotify:[UILocalNotification]?
        
        for notification in UIApplication.shared.scheduledLocalNotifications! as
            [UILocalNotification]{
                localNotify?.append(notification)
        }
        
        return localNotify!
            
            
        }
    
        func printNotifications() {
        
        print("List of notifications currently set:-")
        
        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification] {
            
            print("\(notification)")
            
            
        }
    
    
     }
    

}
