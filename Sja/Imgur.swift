//
//  Imgur.swift
//  screenshot2imgur
//
//  Created by Ómar Kjartan Yasin on 25/05/15.
//  Copyright (c) 2015 Ómar Kjartan Yasin. All rights reserved.
//

import Foundation
import Alamofire

struct Imgur: ScreenshotUploader {
    let apiBase = "https://api.imgur.com/3"
    
    // Find a better way to do this
    func upload(image: Screenshot,
        done: (UploadedScreenshot) -> Void,
        progress: (Int64, Int64) -> Void) {
        var request = createQuery("image", method: "POST")
        Alamofire.upload(request, image.getData())
            .validate(statusCode: [200])
            .validate(contentType: ["application/json"])
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                progress(totalBytesWritten, totalBytesExpectedToWrite)
            }
            .responseJSON { (_, _, JSON, _) in
                if JSON!.valueForKey("success") as! Bool {
                    let link = JSON!.valueForKey("data")!.valueForKey("link") as! String
                    let deletehash = JSON!.valueForKey("data")!.valueForKey("deletehash") as! String
                    let uploadedScreenshot = UploadedScreenshot(directLink: link, deleteHash: deletehash)
                    done(uploadedScreenshot)
                }
        }
    }
    
    func createQuery(resource: String, method: String) -> URLRequestConvertible {
        var key = lookupPlist("Imgur client ID") as! String
        let headers = ["Authorization": "Client-ID \(key)"]
        let url = NSURL(string: "\(apiBase)/\(resource)")!
        let mutableURLRequest = NSMutableURLRequest(URL: url)
        mutableURLRequest.HTTPMethod = method
        for (headerName, headerValue) in headers {
            mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerName)
        }
        return mutableURLRequest
    }
}