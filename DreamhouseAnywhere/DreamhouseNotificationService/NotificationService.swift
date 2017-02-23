//
//  NotificationService.swift
//  DreamhouseNotificationService
//
//  Created by QUINTON WALL on 2/21/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import UserNotifications
import MobileCoreServices

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
           // bestAttemptContent.title = bestAttemptContent.title+'add if you want'
            //bestAttemptContent.subtitle = bestAttemptContent.subtitle
            //bestAttemptContent.body = bestAttemptContent.body
            
            if let urlString = request.content.userInfo["media-attachment"] as? String, let fileUrl = URL(string: urlString) {
                URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                    if let location = location {
                        let options = [UNNotificationAttachmentOptionsTypeHintKey: kUTTypeJPEG]
                        if let attachment = try? UNNotificationAttachment(identifier: "", url: location, options: options) {
                            self.bestAttemptContent?.attachments = [attachment]
                        }
                    }
                    
                    self.contentHandler!(self.bestAttemptContent!)
                    }.resume()
            }
            
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
            
           // contentHandler(bestAttemptContent)
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
