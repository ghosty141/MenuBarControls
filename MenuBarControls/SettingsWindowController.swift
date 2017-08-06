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
        window?.contentView = generalTab?.view
    }

    @IBAction func CoverArt(_ sender: NSToolbarItem) {
        window?.contentView = coverArtTab?.view
    }

    @IBAction func About(_ sender: NSToolbarItem) {
        window?.contentView = aboutTab?.view
    }

    @IBAction func Quit(_ sender: NSToolbarItem) {
        NSApplication.shared().terminate(self)
    }

    func windowShouldClose(_ sender: Any) -> Bool {
        print(generalTab ?? "nil")
        print(coverArtTab ?? "nil")
        print(aboutTab ?? "nil")
        generalTab = nil
        coverArtTab = nil
        aboutTab = nil
        print(generalTab ?? "nil")
        print(coverArtTab ?? "nil")
        print(aboutTab ?? "nil")
        return true
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        window?.delegate = self

        generalTab = mainStoryboard.instantiateController(withIdentifier: "General") as? NSViewController
        coverArtTab = mainStoryboard.instantiateController(withIdentifier: "CoverArt") as? NSViewController
        aboutTab = mainStoryboard.instantiateController(withIdentifier: "About") as? NSViewController
    }
}
