//
//  AppDelegate.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/3/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UIKit
import SwiftlySalesforce
import SalesforceKit
import UserNotifications
import DreamhouseKit



enum QuickAction: String {
    case OpenFavorites = "OpenFavorites"
    case OpenDiscover = "OpenDiscover"

    
    init?(fullIdentifier: String) {
        guard let shortcutIdentifier = fullIdentifier.components(separatedBy: ".").last else {
        return nil
    }
    
        self.init(rawValue: shortcutIdentifier)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginDelegate, UNUserNotificationCenterDelegate  {

    var window: UIWindow?
    
    //salesforce connected app properties
    let consumerKey = "3MVG9uudbyLbNPZORlx5pdNbXe.eo_dVK0WlmqUuSbXszEw7gEIKzXkMdZC2IRCPPAJZYZkdeB.Ed0JDG8YSv"
    let redirectURL = URL(string: "sfdc://success")
    let communityLoginHost = "dreamhousenative-developer-edition.na30.force.com/consumerapp"
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
       let salesforceConfig : AuthManager.Configuration = AuthManager.Configuration(consumerKey: consumerKey, redirectURL: redirectURL!, loginHost: communityLoginHost, loginDelegate: self)
        salesforce.authManager.configuration = salesforceConfig
        
        //Use app groups for sharing data between the iMessage and main app
        let defaults = UserDefaults(suiteName: "group.com.quintonwall.dreamhouseanywhere")
        
        registerForRemoteNotification()
        
        /*
        //do some voodoo magic to map swiftlysalesforce back to mobilesdk so we can register for salesforce push notifications
        let token = salesforce.authManager.authData!.accessToken
        print("==>\(token)")
        

        print("==>\(SFAuthenticationManager.shared().coordinator.credentials)")
        var cred = SFOAuthCredentials(identifier: "dreamhouseanywhere-sfdc-authid", clientId: salesforce.authManager.configuration.consumerKey, encrypted: true)
        cred?.accessToken = token
        cred?.instanceUrl = instanceUrl
        SFAuthenticationManager.shared().coordinator.credentials = cred

        print("==+>\(SFAuthenticationManager.shared().coordinator.credentials)")
        //SFAuthenticationManager.shared().coordinator.credentials.accessToken = token
        // SFAuthenticationManager.shared().coordinator.credentials.identifier = (salesforce.authManager.authData?.userID)!
        
        SFPushNotificationManager.sharedInstance().registerForSalesforceNotifications()
       */
        
        
        
        
        return true
    }
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(handleQuickAction(shortcutItem: shortcutItem))
    }
    
    private func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = QuickAction(fullIdentifier: shortcutType) else {
            return false
        }
        
        switch shortcutIdentifier {
        case .OpenFavorites:
            print("add segue to favorites")
         case .OpenDiscover:
            print("add segue to discover")
        }
        
        return true
    }
            
            
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        handleRedirectURL(url: url)
        return true
    }
    
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
                UIApplication.shared.applicationIconBadgeNumber = 0
    }

    
    
    //MARK: Push notifications
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SFPushNotificationManager.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        PropertyData.shared.registerForSalesforceNotifications(devicetoken: deviceTokenString, instanceUrl: "https://\(communityLoginHost)")
        
        print("Registered for push with device token: \(deviceTokenString)")
    }

/*
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("User Info = ",application.applicationIconBadgeNumber)
        completionHandler()
    }*/
   
   
    
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        completionHandler()
    }
    
    
    //MARK: app lifecycle
    
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


}

