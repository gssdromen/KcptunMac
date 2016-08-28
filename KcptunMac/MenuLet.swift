//
//  MenuLet.swift
//  KcptunMac
//
//  Created by Cedric Wu on 8/25/16.
//  Copyright © 2016 Cedric Wu. All rights reserved.
//

import Cocoa

class MenuLet: NSObject {
    static var statusBar: NSStatusItem!
    static var menu: NSMenu!
    static var toggleItem: NSMenuItem!
    static var preferenceItem: NSMenuItem!
    static var quitItem: NSMenuItem!

    static let preferencesWindow = PreferenceController()

    static var isOn = false

    class func showMenu() {
        self.statusBar = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        self.statusBar.highlightMode = true
        self.statusBar.title = "K"
        self.statusBar.enabled = true

        self.menu = NSMenu(title: "KK")
        self.menu.autoenablesItems = false

        self.toggleItem = NSMenuItem(title: "open kcp", action: #selector(MenuLet.toggleKcptun), keyEquivalent: "")
        self.toggleItem.target = self
        self.menu.addItem(self.toggleItem)

        self.menu.addItem(NSMenuItem.separatorItem())

        self.preferenceItem = NSMenuItem(title: "Preferences", action: #selector(MenuLet.setPreferences), keyEquivalent: "")
        self.preferenceItem.target = self
        self.menu.addItem(self.preferenceItem)

        self.quitItem = NSMenuItem(title: "Quit", action: #selector(MenuLet.quit), keyEquivalent: "")
        self.quitItem.target = self
        self.menu.addItem(self.quitItem)

        self.statusBar.menu = self.menu
    }

    class func toggleKcptun() {
        if self.isOn {
            // 关闭kcptun
            print("to off")
            self.stopScript()
            self.isOn = false
            self.toggleItem.title = "open kcp"
        } else {
            // 开启kcptun
            print("to on")
            self.runScript()
            self.isOn = true
            self.toggleItem.title = "kill kcp"
        }
    }

    class func setPreferences() {
        self.preferencesWindow.showWindow(nil)
    }

    class func quit() {
        NSApplication.sharedApplication().terminate(self)
    }

    class func runScript() {
        Command.runKCPTUN({
            dispatch_async(dispatch_get_main_queue(), {
                let alert = NSAlert()
                alert.addButtonWithTitle("ok")
                alert.messageText = "need some more configurations"
                if (alert.runModal() == NSAlertFirstButtonReturn) {
                    // OK clicked, delete the record
                    alert.window.close()
                }
            })
        })
    }

    class func stopScript() {
        Command.stopKCPTUN()
    }

}
