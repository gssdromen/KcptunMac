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
    let clientPath = Bundle.main.path(forResource: "client_darwin_amd64", ofType: nil)

    var startKcptunWhenOpenApp = false

    static let sharedInstance = PreferenceModel()

    override init() {
        super.init()
        self.load()
    }

    func save() {
        let userDefaults = UserDefaults.standard

        userDefaults.set(self.localPort, forKey: "localPort")
        userDefaults.set(self.remoteAddress, forKey: "remoteAddress")
        userDefaults.set(self.key, forKey: "key")
        userDefaults.set(self.otherArgs, forKey: "otherArgs")
        userDefaults.set(self.startKcptunWhenOpenApp, forKey: "startKcptunWhenOpenApp")

        userDefaults.synchronize()
    }

    func load() {
        let userDefaults = UserDefaults.standard

        self.localPort = userDefaults.string(forKey: "localPort") ?? ""
        self.remoteAddress = userDefaults.string(forKey: "remoteAddress") ?? ""
        self.key = userDefaults.string(forKey: "key") ?? ""
        self.otherArgs = userDefaults.string(forKey: "otherArgs") ?? ""
        self.startKcptunWhenOpenApp = userDefaults.bool(forKey: "startKcptunWhenOpenApp")
    }

    func combine() -> [String] {
        var list = [String]()
        if !self.localPort.isEmpty {
            let port = self.localPort.hasPrefix(":") ? self.localPort : ":\(self.localPort)"
            list.append("-l")
            list.append(port)
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
            let arr = self.otherArgs.components(separatedBy: " ")
            list.append(contentsOf: arr)
        }
        return list
    }
}
