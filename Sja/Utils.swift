//
//  Utils.swift
//  sja
//
//  Created by Ómar Kjartan Yasin on 25/05/15.
//  Copyright (c) 2015 Ómar Kjartan Yasin. All rights reserved.
//

import Foundation

func lookupPlist(key: String) -> AnyObject? {
    if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist") {
        if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
            switch dict[key] {
            case let res as String:
                return res
            case let res as Bool:
                return res
            default:
                return nil
            }
        }
    }
    return nil
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}