//
//  NotificationService.swift
//  DreamhouseNotificationService
//
//  Created by QUINTON WALL on 2/21/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "Price changed!"
            bestAttemptContent.body = bestAttemptContent.body+"xxxx"
            
            /*
             * Salesforce push doesnt currently support setting of the mutable-content aps flag, so this will never get called. Im adding it here for futurenessification
             see: https://code.tutsplus.com/tutorials/ios-10-notification-service-extensions--cms-27550
             
            let rawbody = bestAttemptContent.body
            //let delim = rawbody.characters.index(of: "|")
            //let imageurlstring = rawbody.substring(from: rawbody.index(delim!, offsetBy: 1))
            
            //bestAttemptContent.body = rawbody.substring(to: delim!)+"xxxx"
            
            //var content : UNMutableNotificationContent?
            //content = notification.request.content.mutableCopy() as! UNMutableNotificationContent
            //content?.body = notification.request.content.body.substring(to: delim!)
        */
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
