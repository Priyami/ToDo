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
        
        let value = snapshot.value as? NSDictionary
        if let todocontent = value?["content"] as? String {
            
            content = todocontent
        }
        else{
            
            content = ""
        }
        if let todoTime = value?["setTime"] as? String {
            
            setTime = todoTime
        }
        else{
            
            setTime = ""
        }
        
        
    }
    
    func toAnyObject() -> Any {
              return ["content": content, "setTime": setTime]
    }
    
    
}
