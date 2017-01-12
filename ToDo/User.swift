//
//  User.swift
//  ToDo
//
//  Created by Rajkumar Desigachari on 1/6/17.
//  Copyright © 2017 Rajkumar Desigachari. All rights reserved.
//  Changes to show git is working
//

import Foundation
import FirebaseAuth


struct User{
    
    let uid:String
    let email:String
    
    
    
    init(userData:FIRUser){
        
        uid = userData.uid
        
    
        if let mail = userData.providerData.first?.email{
            
            email = mail
        }
        else{
            
            email = ""
        }
    }
    
    init(uid:String,email:String){
        
        self.uid = uid
        self.email = email
    }
    
}