//
//  AppDelegate.swift
//  TableColumnChooser
//
//  Created by Gene De Lisa on 7/9/15.
//  Copyright © 2015 Gene De Lisa. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  
    let kUserDefaultsKeyVisibleColumns = "kUserDefaultsKeyVisibleColumns"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application


        // Register user defaults. Use a plist in real life.
        var dict = [String : Bool]()
        dict["givenName"] = false
        dict["familyName"] = false
        dict["age"] = false
        var defaults = [String:AnyObject]()
        defaults[kUserDefaultsKeyVisibleColumns] = dict as AnyObject
        UserDefaults.standard.register(defaults: defaults)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

