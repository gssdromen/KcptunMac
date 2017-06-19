//
//  MenuLet.swift
//  KcptunMac
//
//  Created by Cedric Wu on 8/25/16.
//  Copyright © 2016 Cedric Wu. All rights reserved.
//

import Cocoa

class MenuLet: NSObject {
    var statusBar: NSStatusItem!
    var menu: NSMenu!
    var toggleItem: NSMenuItem!
    var startAtLogin: NSMenuItem!
    var preferenceItem: NSMenuItem!
    var quitItem: NSMenuItem!

    let preferencesWindow = PreferenceController()

    var isOn = false
    var autoStart = false

    static let shared = MenuLet()

    override init() {
        let userDefault = UserDefaults.standard
        autoStart = userDefault.bool(forKey: "LaunchAtLogin")
    }

    func showMenu() {
        self.statusBar = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        self.statusBar.highlightMode = true
        self.statusBar.title = "K"
        self.statusBar.isEnabled = true

        self.menu = NSMenu(title: "KK")
        self.menu.autoenablesItems = false

        self.toggleItem = NSMenuItem(title: "start kcp", action: #selector(MenuLet.toggleKcptun), keyEquivalent: "")
        self.toggleItem.target = self
        self.menu.addItem(self.toggleItem)

        self.menu.addItem(NSMenuItem.separator())

        self.startAtLogin = NSMenuItem(title: "StartAtLogin", action: #selector(MenuLet.triggerAutoStart), keyEquivalent: "")
        self.startAtLogin.target = self
        self.menu.addItem(self.startAtLogin)

        self.preferenceItem = NSMenuItem(title: "Preferences", action: #selector(MenuLet.setPreferences), keyEquivalent: "")
        self.preferenceItem.target = self
        self.menu.addItem(self.preferenceItem)

        self.quitItem = NSMenuItem(title: "Quit", action: #selector(MenuLet.quit), keyEquivalent: "")
        self.quitItem.target = self
        self.menu.addItem(self.quitItem)

        self.statusBar.menu = self.menu

        if PreferenceModel.sharedInstance.startKcptunWhenOpenApp {
            self.toggleKcptun()
        }
    }

    func toggleKcptun() {
        if self.isOn {
            // 关闭kcptun
            self.stopScript()
            self.isOn = false
            self.toggleItem.image = nil
        } else {
            // 开启kcptun
            self.runScript()
            self.isOn = true

            self.toggleItem.image = NSImage(named: "gou")
        }
    }

    func setPreferences() {
        self.preferencesWindow.showWindow(nil)
    }

    func triggerAutoStart() {
//        Command.triggerRunAtLogin(startup: true)

        if let clientPath = PreferenceModel.sharedInstance.clientPath {
            let params = PreferenceModel.sharedInstance.combine()
            let xml = Command.genLaunchAgentsPlist(kcptunPath: clientPath, params: params)
            let path = "\(NSHomeDirectory())/Library/LaunchAgents/com.cedric.KcptunMac.plist"
            Command.writeStringToFilePath(path: path, xmlString: xml.xml)
        }
    }

    func quit() {
        Command.stopKCPTUN()
        NSApplication.shared().terminate(self)
    }

    func runScript() {
        Command.runKCPTUN({
            DispatchQueue.main.async(execute: {
                let alert = NSAlert()
                alert.addButton(withTitle: "ok")
                alert.messageText = "need some more configurations"
                if (alert.runModal() == NSAlertFirstButtonReturn) {
                    // OK clicked, delete the record
                    alert.window.close()
                }
            })
        })
    }

    func stopScript() {
        Command.stopKCPTUN()
    }
}
