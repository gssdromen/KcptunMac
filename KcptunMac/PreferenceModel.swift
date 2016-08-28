//
//  PreferenceModel.swift
//  KcptunMac
//
//  Created by Cedric Wu on 8/27/16.
//  Copyright © 2016 Cedric Wu. All rights reserved.
//

import Cocoa
import Foundation
import Foundation

class PreferenceModel: NSObject {

    var localPort: String = ""
    var remoteAddress: String = ""
    var key: String = ""
    var otherArgs: String = ""
    var clientPath: String? = NSBundle.mainBundle().pathForResource("client_darwin_amd64", ofType: nil)
    var pid: Int32 = -1

    static let sharedInstance = PreferenceModel()

    override init() {
        super.init()
        self.load()
    }

    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()

        userDefaults.setObject(self.localPort, forKey: "localPort")
        userDefaults.setObject(self.remoteAddress, forKey: "remoteAddress")
        userDefaults.setObject(self.key, forKey: "key")
        userDefaults.setObject(self.otherArgs, forKey: "otherArgs")

        userDefaults.synchronize()
    }

    func load() {
        let userDefaults = NSUserDefaults.standardUserDefaults()

        self.localPort = userDefaults.stringForKey("localPort") ?? ""
        self.remoteAddress = userDefaults.stringForKey("remoteAddress") ?? ""
        self.key = userDefaults.stringForKey("key") ?? ""
        self.otherArgs = userDefaults.stringForKey("otherArgs") ?? ""
    }

    func combine() -> [String] {
        var list = [String]()
        if !self.localPort.isEmpty {
            list.append("-l")
            list.append(self.localPort.hasPrefix(":") ? self.localPort : ":\(self.localPort)")
        }
        if !self.remoteAddress.isEmpty {
            list.append("-r")
            list.append(self.remoteAddress)
        }
        if !self.key.isEmpty {
            list.append("-key")
            list.append(self.key)
        }
        if !self.otherArgs.isEmpty {
            let arr = self.otherArgs.componentsSeparatedByString(" ")
            list.appendContentsOf(arr)
        }
        return list
    }
}
