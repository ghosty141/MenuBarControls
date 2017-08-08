//
//  SettingsWindowController.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController {

    var visibleTab: NSViewController?

    @IBAction func General(_ sender: NSToolbarItem) {
        visibleTab = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "General")) as? NSViewController
        window?.contentView = visibleTab?.view
    }

    @IBAction func CoverArt(_ sender: NSToolbarItem) {
        visibleTab = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "CoverArt")) as? NSViewController
        window?.contentView = visibleTab?.view
    }

    @IBAction func About(_ sender: NSToolbarItem) {
        visibleTab = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "About")) as? NSViewController
        window?.contentView = visibleTab?.view
    }

    @IBAction func Quit(_ sender: NSToolbarItem) {
        NSApplication.shared.terminate(self)
    }

}
