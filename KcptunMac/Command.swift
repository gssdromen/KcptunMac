//
//  Command.swift
//  KcptunMac
//
//  Created by Cedric Wu on 8/27/16.
//  Copyright © 2016 Cedric Wu. All rights reserved.
//

import Foundation
import ServiceManagement
import Cocoa

class Command {
    class func runKCPTUN(_ configurationErrorBlock: @escaping (() -> Void)) {
        DispatchQueue.global().async {
            let pipe = Pipe()
            let file = pipe.fileHandleForReading

            let task = Process()
            let model = PreferenceModel.sharedInstance
            task.launchPath = model.clientPath
            if model.localPort.isEmpty || model.remoteAddress.isEmpty {
                configurationErrorBlock()
            } else {
                var args = model.combine()
                args.append("&")
                task.arguments = args
                task.standardOutput = pipe
                task.launch()
                model.pid = task.processIdentifier

                let data = file.readDataToEndOfFile()
                file.closeFile()

                let grepOutput = String(data: data, encoding: String.Encoding.utf8)
                if grepOutput != nil {
                    print(grepOutput!)
                }
            }
        }
    }

    class func stopKCPTUN() {
        DispatchQueue.global().async { 
            let task = Process()
            let model = PreferenceModel.sharedInstance
            print(model.pid)
            if model.pid != -1 {
                task.launchPath = "/bin/kill"

                task.arguments = ["-9", String(model.pid)]
                task.launch()
            }
        }
    }

    class func triggerRunAtLogin(startup: Bool) {
        // 这里请填写你自己的Heler BundleID
        let launcherAppIdentifier = "com.cedric.KcptunMac.KcptunMacLauncher"

        // 开始注册/取消启动项
        let flag = SMLoginItemSetEnabled(launcherAppIdentifier as CFString, startup)

        if flag {
            let userDefaults = UserDefaults.standard
            userDefaults.set(startup, forKey: "LaunchAtLogin")
            userDefaults.synchronize()
        }

//        var startedAtLogin = false
//
//        for app in NSWorkspace.shared().runningApplications {
//            if let id = app.bundleIdentifier {
//                if id == launcherAppIdentifier {
//                    startedAtLogin = true
//                }
//            }
//
//        }
//
//        if startedAtLogin {
//            DistributedNotificationCenter.default().post(name: NSNotification.Name(rawValue: "killhelper"), object: Bundle.main.bundleIdentifier!)
//        }
    }
}
