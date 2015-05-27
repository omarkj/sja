//
//  SjaController.swift
//  sja
//
//  Created by Ómar Kjartan Yasin on 25/05/15.
//  Copyright (c) 2015 Ómar Kjartan Yasin. All rights reserved.
//

import Foundation
import AppKit

class SjaController: NSObject {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let metadataQuery = NSMetadataQuery()
    let appDelegate : AppDelegate
    let sound : NSSound
    
    init(app: AppDelegate) {
        appDelegate = app
        let path = NSBundle.mainBundle().pathForResource("upload_completed", ofType: "wav")
        sound = NSSound(contentsOfFile: path!, byReference: true)!
        super.init()
    }
    
    internal func start() {
        waitForScreenshot()
    }
    
    // Attach a query to the notification center which is triggered when a new screenshot is
    // taken. This is also triggered when a screenshot is deleted etc. but those events are
    // ignored for now.
    private func waitForScreenshot() {
        metadataQuery.predicate = NSPredicate(format: "kMDItemIsScreenCapture = 1", NSMetadataItemFSNameKey)
        metadataQuery.startQuery()
        NSNotificationCenter.defaultCenter().addObserverForName(
            NSMetadataQueryDidUpdateNotification,
            object: metadataQuery,
            queue: NSOperationQueue.mainQueue()) { result in
                if let userInfo = result.userInfo {
                    if let screenshotInfo = userInfo[kMDQueryUpdateAddedItems] as? NSArray {
                        for screenShotData in screenshotInfo {
                            var path = screenShotData.valueForAttribute(NSMetadataItemPathKey) as! String
                            var screenShot = Screenshot(path: path)
                            self.uploadScreenshot(screenShot)
                        }
                    }
                }
        }
    }
    
    private func uploadScreenshot(screenshot: Screenshot) {
        screenshot.upload(Imgur(), done: uploadDone,
        progress: uploadInProgress)
    }
    
    private func uploadDone(uploadedScreenshot: UploadedScreenshot) {
        appDelegate.IndicateUploadDone()
        appDelegate.SetPasteboard(uploadedScreenshot.directLink)
        maybePlaySound()
        maybeDeleteOriginal(uploadedScreenshot.screenshot)
    }
    
    private func uploadInProgress(done: Int64, left: Int64) {
        appDelegate.IndicateUpload("\(done / left * 100)")
    }
    
    private func maybePlaySound() {
        if lookupPlist("Sound") as! Bool {
            sound.play()
        }
    }
    
    private func maybeDeleteOriginal(screenshot: Screenshot) {
        if lookupPlist("Delete Once Uploaded") as! Bool {
            let fileManager = NSFileManager()
            fileManager.removeItemAtPath(screenshot.path, error: nil)
        }
    }
    
}