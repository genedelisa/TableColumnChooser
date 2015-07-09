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

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application


        // Register user defaults. Use a plist in real life.
        var dict = [String : Bool]()
        dict["givenName"] = false
        dict["familyName"] = false
        dict["age"] = false
        var defaults = [String:AnyObject]()
        defaults[kUserDefaultsKeyVisibleColumns] = dict
        NSUserDefaults.standardUserDefaults().registerDefaults(defaults)

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

