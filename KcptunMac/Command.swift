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
import AEXML

class Command {
    static let kPidPath = "/var/run/com.cedric.KcptunMac.pid"

    class func runKCPTUN(_ configurationErrorBlock: @escaping (() -> Void)) {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
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

                Command.writePidToFilePath(path: Command.kPidPath, pid: String(task.processIdentifier))

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

            if let pid = Command.readPidToFilePath(path: Command.kPidPath) {
                print(pid)

                task.launchPath = "/bin/kill"

                task.arguments = ["-9", pid]
                task.launch()

            }
        }
    }

    class func genLaunchAgentsPlist(kcptunPath: String, params: [String]) -> AEXMLDocument {
        let xml = AEXMLDocument()
        let plist = AEXMLElement(name: "plist", value: nil, attributes: ["version": "1.0"])
        let dict = AEXMLElement(name: "dict")
        plist.addChild(dict)

        dict.addChild(name: "key", value: "Label", attributes: [:])
        dict.addChild(name: "string", value: "com.cedric.KcptunMac.plist", attributes: [:])
        dict.addChild(name: "key", value: "ProgramArguments", attributes: [:])
        let arrayElement = AEXMLElement(name: "array")
        arrayElement.addChild(name: "string", value: kcptunPath, attributes: [:])
        for param in params {
            arrayElement.addChild(name: "string", value: param, attributes: [:])
        }
        dict.addChild(arrayElement)

        dict.addChild(name: "key", value: "KeepAlive", attributes: [:])
        dict.addChild(name: "true", value: nil, attributes: [:])

        dict.addChild(name: "key", value: "ProcessType", attributes: [:])
        dict.addChild(name: "string", value: "Background", attributes: [:])

        xml.addChild(plist)

        return xml
    }

    // 保存kcptun的运行pid
    class func writePidToFilePath(path: String, pid: String) {
        do {
            try pid.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        } catch let e {
            print(e.localizedDescription)
        }
    }

    // 读取kcptun的运行pid
    class func readPidToFilePath(path: String) -> String? {
        guard FileManager.default.fileExists(atPath: path) else {
            return nil
        }

        if let data = FileManager.default.contents(atPath: path) {
            let pid = String(data: data, encoding: String.Encoding.utf8)
            return pid
        }

        return nil
    }

    // 写开机自启动的plist
    class func writeStringToFilePath(path: String, xmlString: String) {
        do {
            try xmlString.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        } catch let e {
            print(e.localizedDescription)
        }
    }

    // 此方法需要签名才能用
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
