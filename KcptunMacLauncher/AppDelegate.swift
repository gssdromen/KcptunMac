//
//  AppDelegate.swift
//  KcptunMacLauncher
//
//  Created by cedricwu on 1/24/17.
//  Copyright © 2017 Cedric Wu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        let mainBundleId = "com.cedric.KcptunMac"
        var alreadyRunning = false;
//        for app in NSWorkspace.shared().runningApplications {
//            if app.bundleIdentifier == mainBundleId {
//                alreadyRunning = true
//                break
//            }
//        }

//        if (!alreadyRunning) {
            let helperPath: NSString = Bundle.main.bundlePath as NSString;
            var pathComponents = helperPath.pathComponents;
            pathComponents.removeLast(3);
            let mainBundlePath = NSString.path(withComponents: pathComponents);

            if !NSWorkspace.shared().launchApplication(mainBundlePath) {
                NSLog("Launch app \(mainBundleId) failed.")
            }
//        }
        NSApp.terminate(nil);
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

