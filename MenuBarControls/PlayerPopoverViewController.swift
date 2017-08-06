//
//  PlayerPopover.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa
import CoreImage

class PlayerPopoverViewController: NSViewController {

    let appDel = NSApplication.shared().delegate as? AppDelegate
    var lastURL: URL?
    let spotify = Spotify()
    var mouseoverIsActive = false
    var updateTimer: Timer?
    var settingsController: NSWindowController?

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

    func startTimer() {
        if updateTimer == nil {
            updateTimer = Timer.scheduledTimer(
                timeInterval: UserDefaults.standard.double(forKey: "UpdateRate"),
                target: self,
                selector: #selector(self.checkAppStatus),
                userInfo: nil,
                repeats: true)
        }
    }

    func stopTimer() {
        if updateTimer != nil {
            updateTimer?.invalidate()
            updateTimer = nil
        }
    }

    func checkAppStatus() {
        if spotify.isRunning() == false {
            appDel?.closePopover(self)
        } else {
            if spotify.isPlaying() {
                if lastURL != spotify.getCoverURL() {
                    updateCover()
                }
                if mouseoverIsActive {
                    trackTimeLabel.stringValue =
"- \(formatTime(using: spotify.currentPlayerPosition)) / \(formatTime(using: spotify.currentTrackDuration)) -"
                }
                updateShuffleButton()
                updateRepeatButton()
                updatePlayPauseButton()
                volumeSlider.doubleValue = spotify.volume
            } else {
                updatePlayPauseButton()
                if appDel?.popover?.isShown == false {
                    stopTimer()
                }
            }
        }
    }

    func updatePlayPauseButton() {
        if playPauseButton.state == NSOffState && spotify.isPlaying() == true {
            playPauseButton.state = NSOnState
        } else if playPauseButton.state == NSOnState && spotify.isPlaying() == false {
            playPauseButton.state = NSOffState
        }
    }

    func updateShuffleButton() {
        if shuffleButton.state == NSOffState && spotify.shuffling == true {
            shuffleButton.state = NSOnState
        } else if shuffleButton.state == NSOnState && spotify.shuffling == false {
            shuffleButton.state = NSOffState
        }
    }

    func updateRepeatButton() {
        if repeatButton.state == NSOffState && spotify.repeating == true {
            repeatButton.state = NSOnState
        } else if shuffleButton.state == NSOnState && spotify.repeating == false {
            repeatButton.state = NSOffState
        }
    }

    /*
     updateArtwork is more or less temporary (Controller should not handle this, should be moved to Model/Spotify)
     NEVER call updateArtwork too quickly, it WILL cause a memory leak
     (reason being finishTasksAndInvalidate() might not be called)
     */

    private func updateCover() {
        if spotify.getCoverURL() == URL(string: "error") {
            imageGroup = ImageMemory(originalImage: NSImage(named: "CoverError"),
                                     processedImage: self.blurImage(NSImage(named: "CoverError")!))
        } else {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let downloadArtwork =
                session.dataTask(with: spotify.getCoverURL()) { [unowned self] (data, _, error) in
                    if error != nil {
                        self.cover.image = NSImage(named: "CoverError")
                    } else {
                        if let imageData = data {
                            imageGroup = ImageMemory(originalImage: NSImage(data: imageData),
                                                     processedImage: self.blurImage(NSImage(data: imageData)!))
                            if self.mouseoverIsActive == false {
                                self.cover.image = imageGroup.original
                            } else {
                                self.mouseOverOn()
                            }
                        } else {
                            self.cover.image = NSImage(named: "CoverError")
                        }
                    }
            }
            lastURL = spotify.getCoverURL()
            downloadArtwork.resume()
            session.finishTasksAndInvalidate()
        }
    }

    // CABasicAnimation / Core Animation might be more suited for this

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
        track.stringValue = spotify.currentTrack
        album.stringValue = spotify.currentAlbum
        artist.stringValue = spotify.currentArtist
        trackTimeLabel.stringValue =
"- \(formatTime(using: spotify.currentPlayerPosition)) / \(formatTime(using: spotify.currentTrackDuration)) -"

        trackLabel.isHidden = !Bool(UserDefaults.standard.integer(forKey: "displayTrackTitle") as NSNumber)
        albumLabel.isHidden = !Bool(UserDefaults.standard.integer(forKey: "displayAlbumTitle") as NSNumber)
        artistLabel.isHidden = !Bool(UserDefaults.standard.integer(forKey: "displayArtistName") as NSNumber)
        trackTimeLabel.isHidden = !Bool(UserDefaults.standard.integer(forKey: "displayTrackTime") as NSNumber)
    }

    func mouseOverOff() {
        mouseoverIsActive = false
        coverImage.image = imageGroup.original ?? NSImage(named: "CoverError")
        trackLabel.isHidden = true
        albumLabel.isHidden = true
        artistLabel.isHidden = true
        trackTimeLabel.isHidden = true
    }

    // IBActions for the player-popover

    @IBAction func playPause(_ sender: Any) {
        spotify.playPause()
    }

    @IBAction func volumeSlider(_ sender: NSSlider) {
        spotify.volume = sender.doubleValue
    }

    @IBAction func next(_ sender: NSButton) {
        spotify.nextTrack()
        if UserDefaults.standard.integer(forKey: "trackInfoDelay") != 0 {
            mouseOverOn()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +
            UserDefaults.standard.double(forKey: "trackInfoDelay")) {
                self.mouseOverOff()
            }
        }
    }

    @IBAction func previous(_ sender: NSButton) {
        spotify.previousTrack()
    }

    @IBAction func repeats(_ sender: NSButtonCell) {
        spotify.repeating = Bool(sender.intValue as NSNumber)
    }

    @IBAction func shuffle(_ sender: NSButtonCell) {
        spotify.shuffling = Bool(sender.intValue as NSNumber)
    }

    @IBAction func openSettings(_ sender: NSButton) {
        settingsController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SettingsWindow") as? NSWindowController
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

        updateCover()
        startTimer()
        updatePlayPauseButton()
        updateShuffleButton()
        updateRepeatButton()
        volumeSlider.doubleValue = Double(spotify.volume)

        let trackingArea = NSTrackingArea(rect: coverImage.bounds,
                                          options: [NSTrackingAreaOptions.mouseEnteredAndExited,
                                                    NSTrackingAreaOptions.activeAlways],
                                          owner: self,
                                          userInfo: nil)
        coverImage.addTrackingArea(trackingArea)
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        updateTimer?.invalidate()
        updateTimer = nil
        settingsController = nil
        imageGroup = ImageMemory(originalImage: nil, processedImage: nil)
        lastURL = nil
    }
}
