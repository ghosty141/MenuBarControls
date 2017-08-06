//
//  SettingsWindowController.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController {

    weak var visibleTab: NSViewController?

    @IBAction func General(_ sender: NSToolbarItem) {
        visibleTab = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "General") as? NSViewController
        window?.contentView = visibleTab?.view
    }

    @IBAction func CoverArt(_ sender: NSToolbarItem) {
        visibleTab = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "CoverArt") as? NSViewController
        window?.contentView = visibleTab?.view
    }

    @IBAction func About(_ sender: NSToolbarItem) {
        visibleTab = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "About") as? NSViewController
        window?.contentView = visibleTab?.view
    }

    @IBAction func Quit(_ sender: NSToolbarItem) {
        NSApplication.shared().terminate(self)
    }
}
