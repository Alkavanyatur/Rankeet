//
//  NotificationsManager.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit
import FirebaseMessaging
import UserNotifications

class NotificationsManager: NSObject {

    static let sharedInstance = NotificationsManager()
    override init() {
        super.init()
    }
}

//
// MARK: - State methods
//

extension NotificationsManager {
    
    func isNotificationsEnabled()->Bool{
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            return true
        } else {
            return false
        }
    }
    
    func needToRequestNotificationsAllowed()->Bool{
        let defaults = UserDefaults.standard
        defaults.synchronize()
        guard defaults.object(forKey: RankeetDefines.Notifications.notifications_requested) != nil else {
            defaults.set(RankeetDefines.Notifications.notifications_first_iteration, forKey: RankeetDefines.Notifications.notifications_requested)
            defaults.synchronize()
            return true
        }
        return false
    }
    
    func isNotificationsAlreadyRequested()->Bool{
        let defaults = UserDefaults.standard
        defaults.synchronize()
        if let currentNotificationValue:String = defaults.object(forKey: RankeetDefines.Notifications.notifications_requested) as? String, currentNotificationValue == RankeetDefines.Notifications.notifications_first_iteration{
            return true
        }else{
            return false
        }
    }
    
    func checkIfFirstLaunchNotificationsMethod(){
        let defaults = UserDefaults.standard
        defaults.synchronize()
        if defaults.object(forKey: RankeetDefines.Notifications.is_first_notifications_launch) == nil {
            defaults.set(true, forKey: RankeetDefines.Notifications.is_first_notifications_launch)
            defaults.synchronize()
        }
    }
    
    func requestNotificationsAllowed() {
        if isNotificationsAlreadyRequested() {
            if #available(iOS 10.0, *) {
                let categories = Set<UNNotificationCategory>([currentCategoryActionsIOS10()])
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().setNotificationCategories(categories)
                UNUserNotificationCenter.current().delegate = self
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                let categories = Set<UIMutableUserNotificationCategory>([currentCategoryActions()])
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: categories)
                UIApplication.shared.registerUserNotificationSettings(settings)
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    func getCurrentNotificationsToken()->String{
        return Messaging.messaging().fcmToken ?? ""
    }
}

//
// MARK: - Categories methods
//

extension NotificationsManager {
    
    func currentCategoryActions() -> UIMutableUserNotificationCategory {
        let action1: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        action1.activationMode = .background
        action1.title = "Acción 1"
        action1.identifier = RankeetDefines.Notifications.notificationActionOneIdent
        action1.isDestructive = false
        action1.isAuthenticationRequired = false
        
        let action2: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        action2.activationMode = .background
        action2.title = "Acción 2"
        action2.identifier = RankeetDefines.Notifications.notificationActionTwoIdent
        action2.isDestructive = false
        action2.isAuthenticationRequired = false
        
        let actionCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        actionCategory.identifier = RankeetDefines.Notifications.notificationCategoryIdent
        actionCategory.setActions([action1, action2], for: .default)
        return actionCategory
    }
    
    @available(iOS 10.0, *)
    func currentCategoryActionsIOS10() -> UNNotificationCategory {
        let action1 = UNNotificationAction(identifier: RankeetDefines.Notifications.notificationActionOneIdent, title: "Acción fore", options: .foreground)
        let action2 = UNNotificationAction(identifier: RankeetDefines.Notifications.notificationActionTwoIdent, title: "Acción con aut", options: .authenticationRequired)
        let actionCategory: UNNotificationCategory = UNNotificationCategory(identifier: RankeetDefines.Notifications.notificationCategoryIdent, actions: [action1, action2], intentIdentifiers: [RankeetDefines.Notifications.notificationActionOneIdent, RankeetDefines.Notifications.notificationActionTwoIdent], options: [])
        return actionCategory
    }

}

//
// MARK: - Categories methods
//

@available(iOS 10, *)
extension NotificationsManager: UNUserNotificationCenterDelegate{
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
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
        LauncherManager.sharedInstance.askUserMessge(message: message, title: title, reference: userInfo["link"] as? String)
        completionHandler(.sound)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if response.actionIdentifier  == UNNotificationDismissActionIdentifier{
        }else if response.actionIdentifier  == UNNotificationDefaultActionIdentifier{
        }else if response.notification.request.content.categoryIdentifier  == RankeetDefines.Notifications.notificationCategoryIdent{
            if response.actionIdentifier  == RankeetDefines.Notifications.notificationActionOneIdent{
            }else if response.actionIdentifier  == RankeetDefines.Notifications.notificationActionTwoIdent{
            }
        }
        LauncherManager.sharedInstance.deeepLinkingtoReference(reference: userInfo["link"] as? String)
        completionHandler()
    }
}

extension NotificationsManager : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    }
}

