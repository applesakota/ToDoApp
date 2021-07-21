//
//  AppDelegate.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/21/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

import CoreData




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    //MARK: Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let str_URL = url.absoluteString as NSString
        if str_URL.contains("523294401863103") {
            return ApplicationDelegate.shared.application(
                app,
                open: url as URL,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
        return ApplicationDelegate.shared.application(
            app,
            open: url as URL,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //For UserDefaults
        class WhatEver {
            let name = UIApplication.protectedDataDidBecomeAvailableNotification
            
            init() {
                startingPoint()
            }
            
            func startingPoint() {
                let selector = #selector(Self.protectedDataAvailableNotification(_:))
                switch UIApplication.shared.isProtectedDataAvailable {
                case true  : dataDidBecomeAvailable()
                case false: NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
                }
            }
            
            @objc func protectedDataAvailableNotification(_ notification: Notification) {
                NotificationCenter.default.removeObserver(self, name: name, object: nil)
                dataDidBecomeAvailable()
            }
            
            func dataDidBecomeAvailable() {
                // YOUR DATA IS AVAILABLE
            }
        }
        // Override point for customization after application launch.
        //Using UserDefaults check already loggedin user or not
        FirebaseApp.configure()
        
//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = AuthenticateMenager.shared
        
        CategoryMenager.shered.getCategories()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    
}

