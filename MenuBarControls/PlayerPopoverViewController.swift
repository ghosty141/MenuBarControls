//
//  PlayerPopover.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa
import CoreImage
import ScriptingBridge

class PlayerPopoverViewController: NSViewController {

    let appDel = NSApplication.shared.delegate as? AppDelegate
    var lastURL: String?
    var mouseoverIsActive = false
    var updateTimer: Timer?
    var settingsController: NSWindowController?

    let player = Context()
    
    let spotify = SBApplication(bundleIdentifier: "com.spotify.client")! as SpotifyApplication

    @IBOutlet weak var coverImage: NSImageView!
    @IBOutlet weak var trackLabel: NSTextField!
    @IBOutlet weak var albumLabel: NSTextField!
    @IBOutlet weak var artistLabel: NSTextField!
    @IBOutlet weak var trackTimeLabel: NSTextField!

    @IBOutlet weak var cover: NSImageCell!
    @IBOutlet weak var playPauseButton: NSButtonCell!
    @IBOutlet weak var volumeSlider: NSSliderCell!
    @IBOutlet weak var shuffleButton: NSButtonCell!
    @IBOutlet weak var repeatButton: NSButtonCell!
    @IBOutlet weak var track: NSTextFieldCell!
    @IBOutlet weak var album: NSTextFieldCell!
    @IBOutlet weak var artist: NSTextFieldCell!
    @IBOutlet weak var playerSelection: NSSegmentedControl!
    
    private func startTimer() {
        if updateTimer == nil {
            updateTimer = Timer.scheduledTimer(
                timeInterval: UserDefaults.standard.double(forKey: "UpdateRate"),
                target: self,
                selector: #selector(self.checkAppStatus),
                userInfo: nil,
                repeats: true)
        }
    }

    private func stopTimer() {
        if updateTimer != nil {
            updateTimer?.invalidate()
            updateTimer = nil
        }
    }

    @objc func checkAppStatus() {
        if player.isRunning() == false {
            appDel?.closePopover(self)
        } else {
            if player.getPlayerState() == "playing" {
                if lastURL != spotify.currentTrack?.artworkUrl {
                    updateCover()
                }
                if mouseoverIsActive {
                    trackTimeLabel.stringValue =
"- \(formatTime(using: Int32(player.playerPosition))) / \(formatTime(using: Int32((player.currentTrack.duration)/1000))) -"
                }
                updateShuffleButton()
                updateRepeatButton()
                updatePlayPauseButton()
                volumeSlider.integerValue = player.volume
            } else {
                updatePlayPauseButton()
                if appDel?.popover.isShown == false {
                    stopTimer()
                }
            }
        }
    }

    func updatePlayPauseButton() {
        if playPauseButton.state == NSControl.StateValue.off && player.getPlayerState() == "playing" {
            playPauseButton.state = NSControl.StateValue.on
        } else if playPauseButton.state == NSControl.StateValue.on && player.getPlayerState() == "paused" {
            playPauseButton.state = NSControl.StateValue.off
        }
    }

    func updateShuffleButton() {
        if shuffleButton.state == NSControl.StateValue.off && player.shuffling == true {
            shuffleButton.state = NSControl.StateValue.on
        } else if shuffleButton.state == NSControl.StateValue.on && player.shuffling == false {
            shuffleButton.state = NSControl.StateValue.off
        }
    }

    func updateRepeatButton() {
        if repeatButton.state == NSControl.StateValue.off && player.repeating == true {
            repeatButton.state = NSControl.StateValue.on
        } else if shuffleButton.state == NSControl.StateValue.on && player.repeating == false {
            repeatButton.state = NSControl.StateValue.off
        }
    }

    private func updateCover() {
        imageGroup.original = NSImage(data: player.currentTrack.artwork)
        imageGroup.processed = blurImage(imageGroup.original!)
        cover.image = imageGroup.original
        if mouseoverIsActive {
            mouseOverOn()
        }
        lastURL = spotify.currentTrack?.artworkUrl
    }

    // CABasicAnimation / Core Animation is suited for this

    func blurImage(_ inputImage: NSImage) -> NSImage {
        let context = CIContext(options: nil)
        let image = CIImage(data: inputImage.tiffRepresentation!)

        // Extends the borders of the image to infinity to avoid a white lining

        let transform = AffineTransform.identity
        let extendImage = CIFilter(name: "CIAffineClamp")
        extendImage!.setValue(image, forKey: "inputImage")
        extendImage!.setValue(NSAffineTransform(transform: transform), forKey: "inputTransform")
        let extendedImage = extendImage?.outputImage

        // Generates a black image with 0.5 alpha

        let blackGenerator = CIFilter(name: "CIConstantColorGenerator")
        blackGenerator!.setValue(CIColor.init(red: 0,
                                              green: 0,
                                              blue: 0,
                                              alpha:
                                              CGFloat(UserDefaults.standard.double(forKey: "brightnessValue")) / 100),
                                              forKey: "inputColor")
        let black = blackGenerator!.outputImage

        // Crop the generated black image to the size of the input

        let cropBlack = CIFilter(name: "CISourceInCompositing")
        cropBlack!.setValue(black, forKey: "inputImage")
        cropBlack!.setValue(image, forKey: "inputBackgroundImage")
        let croppedBlack = cropBlack!.outputImage

        // Blurs the input

        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter!.setValue(extendedImage, forKey: kCIInputImageKey)
        blurFilter!.setValue(CGFloat(UserDefaults.standard.integer(forKey: "blurValue")), forKey: kCIInputRadiusKey)
        let blurredImage = blurFilter!.outputImage

        // Lays the black image ontop of the original

        let mixFilter = CIFilter(name: "CISourceAtopCompositing")
        mixFilter!.setValue(croppedBlack, forKey: "inputImage")
        mixFilter!.setValue(blurredImage, forKey: "inputBackgroundImage") //input change
        let mixed = mixFilter!.outputImage

        // Crops it again so there aren't any borders

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(mixed, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: image!.extent), forKey: "inputRectangle")
        let cropped = cropFilter!.outputImage

        // Converts the CGImage to NSImage and returns it

        let cgimg = context.createCGImage(cropped!, from: cropped!.extent)
        let processedImage = NSImage(cgImage: cgimg!, size: NSSize(width: 0, height: 0))

        return processedImage
    }

    func formatTime(using time: Int32) -> String {
        let zeroPrefixFormatter = NumberFormatter()
        zeroPrefixFormatter.minimumIntegerDigits = 2
        return "\(time/60):\(zeroPrefixFormatter.string(from: NSNumber(value: (time-(time/60)*60)))!)"
    }

    func mouseOverOn() {
        mouseoverIsActive = true
        cover.image = imageGroup.processed
        track.stringValue = player.currentTrack.name
        album.stringValue = player.currentTrack.album
        artist.stringValue = player.currentTrack.artist
        trackTimeLabel.stringValue =
"- \(formatTime(using: Int32(player.playerPosition))) / \(formatTime(using: Int32((player.currentTrack.duration)/1000))) -"

        trackLabel.isHidden = !Bool(truncating: UserDefaults.standard.integer(forKey: "displayTrackTitle") as NSNumber)
        albumLabel.isHidden = !Bool(truncating: UserDefaults.standard.integer(forKey: "displayAlbumTitle") as NSNumber)
        artistLabel.isHidden = !Bool(truncating: UserDefaults.standard.integer(forKey: "displayArtistName") as NSNumber)
        trackTimeLabel.isHidden = !Bool(truncating: UserDefaults.standard.integer(forKey: "displayTrackTime") as NSNumber)
        playerSelection.isHidden = !Bool(truncating: UserDefaults.standard.integer(forKey: "displayPlayerSelection") as NSNumber)
    }

    func mouseOverOff() {
        mouseoverIsActive = false
        coverImage.image = imageGroup.original ?? NSImage(named: NSImage.Name("CoverError"))
        trackLabel.isHidden = true
        albumLabel.isHidden = true
        artistLabel.isHidden = true
        trackTimeLabel.isHidden = true
    }

    // IBActions for the player-popover

    @IBAction func playPause(_ sender: Any) {
        player.playPause()
    }

    @IBAction func volumeSlider(_ sender: NSSlider) {
        player.volume = sender.integerValue
    }

    @IBAction func next(_ sender: NSButton) {
        player.nextTrack()
        if UserDefaults.standard.integer(forKey: "trackInfoDelay") != 0 {
            mouseOverOn()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +
            UserDefaults.standard.double(forKey: "trackInfoDelay")) {
                self.mouseOverOff()
            }
        }
    }

    @IBAction func previous(_ sender: NSButton) {
        player.previousTrack()
    }

    @IBAction func repeats(_ sender: NSButtonCell) {
        player.repeating = Bool(truncating: sender.intValue as NSNumber)
    }

    @IBAction func shuffle(_ sender: NSButtonCell) {
        player.shuffling = Bool(truncating: sender.intValue as NSNumber)
    }
    
    @IBAction func playerSelection(_ sender: NSSegmentedControl) {
        if sender.intValue == 0 {
            print(sender.intValue)
            player.useiTunes()
        } else if sender.intValue == 1 {
            player.useSpotify()
        }
    }
    
    @IBAction func openSettings(_ sender: NSButton) {
        settingsController = NSStoryboard(
            name: NSStoryboard.Name(rawValue: "Main"),
            bundle: nil)
            .instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SettingsWindow")) as? NSWindowController
        settingsController?.showWindow(self)
    }

    // Overrides

    override func mouseEntered(with event: NSEvent) {
        mouseOverOn()
    }

    override func mouseExited(with event: NSEvent) {
        mouseOverOff()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        startTimer()
        updatePlayPauseButton()
        updateShuffleButton()
        updateRepeatButton()
        updateCover()
        volumeSlider.integerValue = player.volume

        let trackingArea = NSTrackingArea(rect: coverImage.bounds,
                                          options: [NSTrackingArea.Options.mouseEnteredAndExited,
                                                    NSTrackingArea.Options.activeAlways],
                                          owner: self,
                                          userInfo: nil)
        coverImage.addTrackingArea(trackingArea)
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        updateTimer?.invalidate()
        imageGroup = ImageMemory(originalImage: nil, processedImage: nil)
    }
}
