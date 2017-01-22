//
//  PreferenceController.swift
//  KcptunMac
//
//  Created by Cedric Wu on 8/26/16.
//  Copyright © 2016 Cedric Wu. All rights reserved.
//

import Cocoa

class PreferenceController: NSWindowController {
    @IBOutlet weak var localPort: NSTextField!
    @IBOutlet weak var remoteAddress: NSTextField!
    @IBOutlet weak var key: NSTextField!
    @IBOutlet weak var otherArgs: NSTextField!
    @IBOutlet weak var save: NSButton!
    @IBOutlet weak var cancel: NSButton!

    @IBAction func saveButtonClick(_ sender: NSButton) {
        let model = PreferenceModel.sharedInstance
        model.localPort = self.localPort.stringValue
        model.remoteAddress = self.remoteAddress.stringValue
        model.key = self.key.stringValue
        model.otherArgs = self.otherArgs.stringValue

        model.save()
        self.close()
    }

    @IBAction func cancelButtonClick(_ sender: NSButton) {
        self.close()
    }

    override var windowNibName: String? {
        return "PreferenceController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        let model = PreferenceModel.sharedInstance
        self.localPort.stringValue = model.localPort
        self.remoteAddress.stringValue = model.remoteAddress
        self.key.stringValue = model.key
        self.otherArgs.stringValue = model.otherArgs
    }

}
