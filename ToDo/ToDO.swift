//
//  ToDO.swift
//  ToDo
//
//  Created by Rajkumar Desigachari on 1/6/17.
//  Copyright © 2017 Rajkumar Desigachari. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ToDo{
    
    let key:String!
    let content:String!
    let setTime:String!
    //let addedByUser:String!
    let itemRef:FIRDatabaseReference?
    
    
    init(content:String, setTime: String, key:String = ""){
        
        self.key = key
        self.content = content
        self.setTime = setTime
       // self.addedByUser = addedByUser
        self.itemRef = nil
        
    }
    
    init (snapshot:FIRDataSnapshot){
        
        key =  snapshot.key
        itemRef = snapshot.ref
        
        if let todoContent = snapshot.value!["content"] as? String {
            
            content = todoContent
        }
        else{
            
            content = ""
        }
        if let todoTime = snapshot.value!["setTime"] as? String {
            setTime = todoTime
        }
        else{
            setTime = ""
        }
        
        
        
    }
    
    func toAnyObject() -> AnyObject {
        
        return ["content": content, "setTime": setTime]
    }
    
    
}
