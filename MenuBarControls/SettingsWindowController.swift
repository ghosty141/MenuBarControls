//
//  SettingsWindowController.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController, NSWindowDelegate {

    let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
    var generalTab: NSViewController?
    var coverArtTab: NSViewController?
    var aboutTab: NSViewController?

    @IBAction func General(_ sender: NSToolbarItem) {
        window?.contentViewController = generalTab
    }

    @IBAction func CoverArt(_ sender: NSToolbarItem) {
        window?.contentViewController = coverArtTab
    }

    @IBAction func About(_ sender: NSToolbarItem) {
        window?.contentViewController = aboutTab
    }

    @IBAction func Quit(_ sender: NSToolbarItem) {
        NSApplication.shared().terminate(self)
    }
    
    override func windowWillLoad() {
        super.windowWillLoad()

        generalTab = mainStoryboard.instantiateController(withIdentifier: "General") as? NSViewController
        coverArtTab = mainStoryboard.instantiateController(withIdentifier: "CoverArt") as? NSViewController
        aboutTab = mainStoryboard.instantiateController(withIdentifier: "About") as? NSViewController
    }
    
    func windowWillClose(_ notification: Notification) {
        window?.contentViewController = nil
        generalTab = nil
        coverArtTab = nil
        aboutTab = nil
    }
}
