//
//  SettingsWindowController.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController, NSWindowDelegate {

    var visibleTab: NSViewController?

    @IBAction func general(_ sender: NSToolbarItem) {
         visibleTab = NSStoryboard(
            name: NSStoryboard.Name(rawValue: "Main"),
            bundle: nil)
            .instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "General")) as? NSViewController
        window?.contentView = visibleTab?.view
    }

    @IBAction func coverArt(_ sender: NSToolbarItem) {
        visibleTab = NSStoryboard(
            name: NSStoryboard.Name(rawValue: "Main"),
            bundle: nil)
            .instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "CoverArt")) as? NSViewController
        window?.contentView = visibleTab?.view
    }

    @IBAction func about(_ sender: NSToolbarItem) {
        visibleTab = NSStoryboard(
            name: NSStoryboard.Name(rawValue: "Main"),
            bundle: nil)
            .instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "About")) as? NSViewController
        window?.contentView = visibleTab?.view
    }

    @IBAction func quit(_ sender: NSToolbarItem) {
        NSApplication.shared.terminate(self)
    }

    override func windowDidLoad() {
        window?.level = NSWindow.Level(rawValue: NSWindow.Level.RawValue(kCGFloatingWindowLevel))
        
    }
}
