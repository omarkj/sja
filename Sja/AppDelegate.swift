//
//  AppDelegate.swift
//  screenshot2imgur
//
//  Created by Ómar Kjartan Yasin on 25/05/15.
//  Copyright (c) 2015 Ómar Kjartan Yasin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var window: NSWindow!

    let notificationCenter = NSNotificationCenter.defaultCenter()
    let metadataQuery = NSMetadataQuery()
    let statusBarItem : NSStatusItem?
    let pasteboard = NSPasteboard.generalPasteboard()
    
    override init() {
        let statusBar = NSStatusBar.systemStatusBar()
        statusBarItem = statusBar.statusItemWithLength(-1)
        super.init()
    }
    
    override func awakeFromNib() {
        setupStatusBar()
        let sjaController = SjaController(app: self)
        sjaController.start()
        return
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // After the application has loaded setup a notification listener for the
        // screenshot event
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func setupStatusBar() {
        statusBarItem!.title = "Sjá"
        var menu = NSMenu()
        statusBarItem!.menu = menu
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit Sjá", action: "exitApp", keyEquivalent: ""))
    }
    
    func exitApp() {
        NSApplication.sharedApplication().terminate(self)
    }
    
    // Public functions
    internal func SetPasteboard(url: String) {
        self.pasteboard.clearContents()
        self.pasteboard.setString(url, forType: NSPasteboardTypeString)
    }
    
    internal func IndicateUpload(percentage: String) {
        ChangeStatusBarTitle("Uploading: \(percentage)%")
    }
    
    internal func IndicateUploadDone() {
        ChangeStatusBarTitle("Upload successful")
        delay(1.0) {
            self.ChangeStatusBarTitle("Sjá")
        }
    }
    
    internal func ChangeStatusBarTitle(string: String) {
        statusBarItem!.title = string
    }
    
}