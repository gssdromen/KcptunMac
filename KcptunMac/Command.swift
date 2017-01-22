//
//  Command.swift
//  KcptunMac
//
//  Created by Cedric Wu on 8/27/16.
//  Copyright © 2016 Cedric Wu. All rights reserved.
//

import Foundation

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

    class func enableRunAtLogin() {

    }

    class func disableRunAtLogin() {

    }
}
