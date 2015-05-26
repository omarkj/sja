//
//  SjaController.swift
//  sja
//
//  Created by Ómar Kjartan Yasin on 25/05/15.
//  Copyright (c) 2015 Ómar Kjartan Yasin. All rights reserved.
//

import Foundation

class SjaController {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let metadataQuery = NSMetadataQuery()
    let appDelegate : AppDelegate
    
    init(app: AppDelegate) {
        appDelegate = app
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
        screenshot.upload(Imgur(), done: { (uploadedScreenshot: UploadedScreenshot) -> Void in
            self.appDelegate.IndicateUploadDone()
            self.appDelegate.SetPasteboard(uploadedScreenshot.directLink!)
        },
        progress: { (done: Int64, left: Int64) -> Void in
            var percentage = done / left * 100
            self.appDelegate.IndicateUpload("\(percentage)")
        })
    }
}