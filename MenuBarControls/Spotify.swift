//
//  Spotify.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

class Spotify {

    //Properties

    var currentPlayerPosition: Int32 {
        get {
            let getCurrentPlayerPositionScript = "tell application \"Spotify\"\n player position \n end tell"
            if let scriptObject = NSAppleScript(source: getCurrentPlayerPositionScript) {
                let getCurrentPlayerPosition = scriptObject.executeAndReturnError(nil).int32Value
                return getCurrentPlayerPosition
            }
            return 0
        }
        set(time) {
            let setCurrentPlayerPositionScript =
                "tell application \"Spotify\"\n set player position to \(time) \n end tell"
            if let scriptObject = NSAppleScript(source: setCurrentPlayerPositionScript) {
                scriptObject.executeAndReturnError(nil)
            }
        }
    }

    var currentTrackDuration: Int32 {
        let getCurrentTrackDurationScript = "tell application \"Spotify\"\n duration of current track \n end tell"
        if let scriptObject = NSAppleScript(source: getCurrentTrackDurationScript) {
            let getCurrentTrackDuration = scriptObject.executeAndReturnError(nil).int32Value / 1000
            return getCurrentTrackDuration
        }
        return 0
    }

    var currentArtist: String {
        let getArtistScript = "tell application \"Spotify\"\n artist of current track \n end tell"
        if let scriptObject = NSAppleScript(source: getArtistScript) {
            let getArtist = scriptObject.executeAndReturnError(nil).stringValue ?? "error"
            return getArtist
        }
        return "Error: No Artist Information found"
    }

    var currentTrack: String {
        let getTrackScript = "tell application \"Spotify\"\n name of current track \n end tell"
        if let scriptObject = NSAppleScript(source: getTrackScript) {
            let getTrack = scriptObject.executeAndReturnError(nil).stringValue ?? "error"
            return getTrack
        }
        return "Error: No Track Information found"
    }

    var currentAlbum: String {
        let getAlbumScript = "tell application \"Spotify\"\n album of current track \n end tell"
        if let scriptObject = NSAppleScript(source: getAlbumScript) {
            let getAlbum = scriptObject.executeAndReturnError(nil).stringValue ?? "error"
            return getAlbum
        }
        return "Error: No Album Information found"
    }

    var currentCoverArt: NSImage {
        let urlContent = try? Data(contentsOf: spotify.getCoverURL())
        if let coverArt = urlContent {
            return NSImage(data: coverArt)!
        } else {
            return NSImage(named: "CoverError")!
        }
    }

    var volume: Double {
        get {
            let getVolumeScript = "tell application \"Spotify\"\n get sound volume \n end tell"
            if let scriptObject = NSAppleScript(source: getVolumeScript) {
                let currentVolume = scriptObject.executeAndReturnError(nil).doubleValue
                return currentVolume
            }
            return 0
        }
        set(value) {
            let setVolumeScript = "tell application \"Spotify\"\n set sound volume to \(value) \n end tell"
            if let scriptObject = NSAppleScript(source: setVolumeScript) {
                scriptObject.executeAndReturnError(nil)
            }
        }
    }

    var repeating: Bool {
        get {
            let repeatScript = "tell application \"Spotify\"\n repeating \n end tell"
            if let scriptObject = NSAppleScript(source: repeatScript) {
                return scriptObject.executeAndReturnError(nil).booleanValue
            }
            return false
        }
        set(isRepeating) {
            let repeatScript = "tell application \"Spotify\"\n set repeating to \(isRepeating) \n end tell"
            if let scriptObject = NSAppleScript(source: repeatScript) {
                scriptObject.executeAndReturnError(nil)
            }
        }
    }

    var shuffling: Bool {
        get {
            let shuffleScript = "tell application \"Spotify\"\n shuffling \n end tell"
            if let scriptObject = NSAppleScript(source: shuffleScript) {
                return scriptObject.executeAndReturnError(nil).booleanValue
            }
            return false
        }
        set(isShuffling) {
            let shuffleScript = "tell application \"Spotify\"\n set shuffling to \(isShuffling) \n end tell"
            if let scriptObject = NSAppleScript(source: shuffleScript) {
                scriptObject.executeAndReturnError(nil)
            }
        }
    }

    //Get functions

    func isRunning() -> Bool {
        let applications = NSWorkspace.shared().runningApplications
        for i in applications where i.localizedName! == "Spotify" {
            return true
        }
        return false
    }

    func isPlaying() -> Bool {
        if isRunning() == true {
            let isPlayingScript = "tell application \"Spotify\"\n return player state as text \n end tell"
            if let scriptObject = NSAppleScript(source: isPlayingScript) {
                if let playState = scriptObject.executeAndReturnError(nil).stringValue {
                    switch playState {
                    case "playing":
                        return true
                    case "paused":
                        return false
                    default:
                        return false
                    }
                }
            }
            return false
        }
        return false
    }

    func getCoverURL() -> URL {
        let ArtworkScript = "tell application \"Spotify\"\n artwork url of current track \n end tell"
        let ArtworkString = NSAppleScript(source: ArtworkScript)?.executeAndReturnError(nil)
        let ArtworkURL = URL(string: (ArtworkString?.stringValue ?? "error")!)
        return ArtworkURL!
    }

    //Actions

    func playPause() {
        let PlayPauseScript = "tell application \"Spotify\"\n playpause\n end tell"
        if let scriptObject = NSAppleScript(source: PlayPauseScript) {
            scriptObject.executeAndReturnError(nil)
        }
    }

    func nextTrack() {
        let nextTrackScript = "tell application \"Spotify\"\n next track \n end tell"
        if let scriptObject = NSAppleScript(source: nextTrackScript) {
            scriptObject.executeAndReturnError(nil)
        }
    }

    func previousTrack() {
        let previousTrackScript = "tell application \"Spotify\"\n previous track \n end tell"
        if let scriptObject = NSAppleScript(source: previousTrackScript) {
            scriptObject.executeAndReturnError(nil)
        }
    }
}
