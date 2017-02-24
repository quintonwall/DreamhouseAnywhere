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
import WatchConnectivity



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

let NotificationPropertyFavoritedOnPhone = "PropertyFavoritedOnPhone"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginDelegate, UNUserNotificationCenterDelegate, WCSessionDelegate  {

    var window: UIWindow?
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
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
        setupWatchConnectivity()
        setupNotificationCenter()
   
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

    
    
    //MARK: - Push notifications
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

       Globals.registerForSalesforceNotifications(devicetoken: deviceTokenString, instanceUrl: "https://\(communityLoginHost)")
        
        print("Registered for push with device token: \(deviceTokenString)")
    }

   
    
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    
  

    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive = ",response.notification.request.content.userInfo)
        
        completionHandler()

    }
    
    //MARK: - Notification Center
    private func setupNotificationCenter() {
        notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationPropertyFavoritedOnPhone), object: nil, queue: nil) { (notification:Notification) -> Void in
            //self.senFavoritePropertiesToWatch(notification)
        }
    }
    
    
    //MARK: - WatchKit
    
    func setupWatchConnectivity() {
     
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WC Session did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WC Session did deactivate")
        WCSession.default().activate()
    }
   
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
         if let error = error {
            print("WC Session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: " + "\(activationState.rawValue)")
    }
    
    
    /*
    func sendPropertiesToWatch(_ notification: Notification) {
        if WCSession.isSupported() {
            let session = WCSession.default()
            if session.isWatchAppInstalled {
                print("sending to watch")
                do {
                     try session.updateApplicationContext(["properties" : "test"])
                } catch {
                    print("ERROR: \(error)")
                }
            }
        }
    }
 */
    
    //MARK: -  app lifecycle
    
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

