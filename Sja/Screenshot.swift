//
//  Screenshot.swift
//  screenshot2imgur
//
//  Created by Ómar Kjartan Yasin on 25/05/15.
//  Copyright (c) 2015 Ómar Kjartan Yasin. All rights reserved.
//

import Foundation

struct Screenshot {
    let path: String
    
    func upload(uploader: ScreenshotUploader,
        done: (UploadedScreenshot) -> Void,
        progress: (Int64, Int64) -> Void) {
            uploader.upload(self,
                done: done,
                progress: progress)
    }
    
    func getData() -> NSData {
        // Validate that the file is still here etc.
        return NSData(contentsOfFile: path)!
    }
}

struct UploadedScreenshot {
    let directLink: String
    let deleteHash: String
    let screenshot: Screenshot
}

protocol ScreenshotUploader {
    func upload(image: Screenshot,
        done: (UploadedScreenshot) -> Void,
        progress: (Int64, Int64) -> Void) -> Void
}