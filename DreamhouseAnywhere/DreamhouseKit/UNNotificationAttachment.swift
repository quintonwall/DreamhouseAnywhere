//
//  UNNotificationAttachment.swift
//  DreamhouseAnywhere
//
//  Created by QUINTON WALL on 2/21/17.
//  Copyright © 2017 me.quinton. All rights reserved.
//

import Foundation
import UserNotifications


extension UNNotificationAttachment {
    
    /// Save the image to disk
    public static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
    let fileManager = FileManager.default
    let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
    let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
    
    do {
    try fileManager.createDirectory(at: tmpSubFolderURL!, withIntermediateDirectories: true, attributes: nil)
    let fileURL = tmpSubFolderURL?.appendingPathComponent(imageFileIdentifier)

    try data.write(to: fileURL!, options: [])
    let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL!, options: options)
    return imageAttachment
    } catch let error {
    print("error \(error)")
    }
    
    return nil
    }
}
