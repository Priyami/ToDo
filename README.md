# ToDo



ToDo List IOS App using Firebase as BAAS - Backend As a Service. 

To Configure the Firebase in Xcode Project

Register your gmail to Firebase GoogleConsole - Create a New Project under IOS Development.

Auto-download Googleservice-info.plist file to your mac. 

Create New xcode project as ToDo. Move Googleservice-info.plist to ToDo project folder.

To install the pods. Goto Terminal under your ToDo Project folder

ToDo $: sudo gem install cocoapods - To work with pods 

ToDo $: pod init // Creates Podfile

Open & Edit Podfile in Xcode

pod 'Firebase/Core'  
pod 'Firebase/Auth'
pod 'Firebase/Database'
 
ToDo $: pod install

For Database Access in Firebase - Need to Create an User for Authentication - dummy one

Todo - AppDelegate.swift

import CoreData

import Firebase

import FirebaseAuth



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        }
        
Run ToDo Project - Build succeeds. 

Console view shows the Firebase Enabled which denotes Firebase is successfully configured in your project.


        
        
