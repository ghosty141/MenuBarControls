//
//  SettingsWindowViewController.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

class SettingsWindowViewController: NSViewController {

    let onlyIntFormatter = TextFieldFormatter()

    // GENERAL

    @IBOutlet var updateRate: NSTextField!

    @IBOutlet weak var updateRateStepperOutlet: NSStepperCell!

    @IBAction func updateRateStepper(_ sender: NSStepper) {
        updateRate.integerValue = sender.integerValue
        UserDefaults.standard.set(updateRate.integerValue, forKey: "UpdateRate")
    }

    @IBAction func quitApplication(_ sender: NSButtonCell) {
        NSApplication.shared().terminate(self)
    }

    // COVER ART

    @IBOutlet weak var blurValue: NSTextField!
    @IBOutlet weak var brightnessValue: NSTextField!
    @IBOutlet weak var trackInfoDelayValue: NSTextField!

    @IBOutlet weak var blurValueStepperOutlet: NSStepperCell!
    @IBOutlet weak var brightnessValueStepperOutlet: NSStepperCell!
    @IBOutlet weak var trackInfoDelayValueStepperOutlet: NSStepper!

    @IBOutlet weak var displayTrackTitleOutlet: NSButton!
    @IBOutlet weak var displayAlbumTitleOutlet: NSButton!
    @IBOutlet weak var displayArtistNameOutlet: NSButton!
    @IBOutlet weak var displayTrackTimeOutlet: NSButton!

    @IBAction func blurStepper(_ sender: NSStepperCell) {
        blurValue.integerValue = sender.integerValue
        UserDefaults.standard.set(sender.integerValue, forKey: "blurValue")
    }

    @IBAction func brightnessStepper(_ sender: NSStepperCell) {
        brightnessValue.integerValue = sender.integerValue
        UserDefaults.standard.set(sender.integerValue, forKey: "brightnessValue")
    }

    @IBAction func trackInfoDelayStepper(_ sender: NSStepperCell) {
        trackInfoDelayValue.integerValue = sender.integerValue
        UserDefaults.standard.set(sender.integerValue, forKey: "trackInfoDelay")
    }

    @IBAction func blurValueInput(_ sender: NSTextField) {
        blurValue.integerValue = sender.integerValue
        blurValueStepperOutlet.integerValue = sender.integerValue
        UserDefaults.standard.set(sender.integerValue, forKey: "blurValue")
    }

    @IBAction func brightnessValueInput(_ sender: NSTextField) {
        brightnessValue.integerValue = sender.integerValue
        brightnessValueStepperOutlet.integerValue = sender.integerValue
        UserDefaults.standard.set(sender.integerValue, forKey: "brightnessValue")
    }

    @IBAction func trackInfoDelayValueInput(_ sender: NSTextField) {
        trackInfoDelayValue.integerValue = sender.integerValue
        trackInfoDelayValueStepperOutlet.integerValue = sender.integerValue
        UserDefaults.standard.set(sender.integerValue, forKey: "trackInfoDelay")
    }

    @IBAction func updateCoverButton(_ sender: NSButton) {
        let player = PlayerPopoverViewController()
        if imageGroup.original != nil {
            imageGroup.processed = player.blurImage(imageGroup.original!)
        }
    }

    @IBAction func displayTrackTitleButton(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: "displayTrackTitle")
    }

    @IBAction func displayAlbumTitleButton(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: "displayAlbumTitle")
    }

    @IBAction func displayArtistNameButton(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: "displayArtistName")
    }

    @IBAction func displayTrackTimeButton(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: "displayTrackTime")
    }

    // ABOUT

    @IBAction func openWebsite(_ sender: NSButton) {
        NSWorkspace.shared().open(URL(string: "https://github.com/Ghosty141/MenuBarControls")!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sets the objects to the stored values

        blurValue.formatter = onlyIntFormatter
        brightnessValue.formatter = onlyIntFormatter
        trackInfoDelayValue.formatter = onlyIntFormatter

        updateRate.integerValue = UserDefaults.standard.integer(forKey: "UpdateRate")
        updateRateStepperOutlet.integerValue = UserDefaults.standard.integer(forKey: "UpdateRate")

        blurValue.integerValue = UserDefaults.standard.integer(forKey: "blurValue")
        blurValueStepperOutlet.integerValue = UserDefaults.standard.integer(forKey: "blurValue")
        
        brightnessValue.integerValue = UserDefaults.standard.integer(forKey: "brightnessValue")
        brightnessValueStepperOutlet.integerValue = UserDefaults.standard.integer(forKey: "brightnessValue")

        trackInfoDelayValue.integerValue = UserDefaults.standard.integer(forKey: "trackInfoDelay")
        trackInfoDelayValueStepperOutlet.integerValue = UserDefaults.standard.integer(forKey: "trackInfoDelay")

        displayTrackTitleOutlet.state = UserDefaults.standard.integer(forKey: "displayTrackTitle")
        displayAlbumTitleOutlet.state = UserDefaults.standard.integer(forKey: "displayAlbumTitle")
        displayArtistNameOutlet.state = UserDefaults.standard.integer(forKey: "displayArtistName")
        displayTrackTimeOutlet.state = UserDefaults.standard.integer(forKey: "displayTrackTime")
    }
}
