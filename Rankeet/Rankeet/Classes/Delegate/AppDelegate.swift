//
//  AppDelegate.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

import GoogleSignIn
import Firebase
import FBSDKLoginKit
import GooglePlaces
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        //Notification
        NotificationsManager.sharedInstance.requestNotificationsAllowed()
        
        //Firebase Init
        FirebaseApp.configure()
        
        //GooglePlaces Init
        GMSPlacesClient.provideAPIKey("AIzaSyAFS6Y3gCBehYuZ681QfTOnyE2bm6KuTio")
        
        //Facebook Init
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Realm Check configuration
        self.checkDatabase()
        
        return true
    }
    
    func checkDatabase(){
        let config = Realm.Configuration(
            schemaVersion: UInt64(DevDefines.datbaseVersion),
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < UInt64(DevDefines.datbaseVersion) {

                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            var result = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
            if result == false {
                result = GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
            }
            return result
    }
    
    
    
    //
    // MARK: - Notification methods
    //
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        NotificationsManager.sharedInstance.checkIfFirstLaunchNotificationsMethod()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let state: UIApplicationState = application.applicationState
        var message = ""
        var title = ""
        if let apsDict = userInfo["aps"] as? [String:AnyObject]{
            if  let currentMessage = apsDict["alert"] as? String{
                message = currentMessage
            }else if let currentMessageDict = apsDict["alert"] as? [String:AnyObject]{
                message = currentMessageDict["body"] as? String ?? ""
                title = currentMessageDict["title"] as? String ?? ""
            }
        }
        if state == .inactive || state == .background {
            LauncherManager.sharedInstance.deeepLinkingtoReference(reference: userInfo["link"] as? String)
        }else {
            LauncherManager.sharedInstance.askUserMessge(message: message, title: title, reference: userInfo["link"] as? String)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

