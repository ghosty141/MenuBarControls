//
//  Spotify.swift
//  MenuBarControls
//
//  Created by Ghosty on 30.01.18.
//  Copyright © 2018 Ghostly. All rights reserved.
//

import Foundation
import ScriptingBridge

let spotifyPlayer = SBApplication(bundleIdentifier: "com.spotify.client")! as SpotifyApplication


class Spotify: Player {
    var currentTrack: CurrentTrack = SpotifyCurrentTrack()
    
    func playPause() {
        spotifyPlayer.playpause!()
    }
    
    func nextTrack() {
        spotifyPlayer.nextTrack!()
    }
    
    func previousTrack() {
        spotifyPlayer.previousTrack!()
    }
    
    var volume: Int {
        get {
            return spotifyPlayer.soundVolume!
        }
        set(value) {
            spotifyPlayer.setSoundVolume!(value)
        }
    }
    
    var repeating: Bool {
        get {
            return spotifyPlayer.repeating!
        }
        set(value) {
            spotifyPlayer.setRepeating!(value)
        }
    }

    var shuffling: Bool {
        get {
            return spotifyPlayer.shuffling!
        }
        set(value) {
            spotifyPlayer.setShuffling!(value)
        }
    }
    
    var playerPosition: Double {
        get {
            return spotifyPlayer.playerPosition!
        }
        set (value) {
            spotifyPlayer.setPlayerPosition!(value)
        }
    }
    
    func isRunning() -> Bool {
        return spotifyPlayer.isRunning
    }
    
    func getPlayerState() -> String {
        switch spotifyPlayer.playerState {
        case .playing?:
            return "playing"
        case .paused?:
            return "paused"
        case .stopped?:
            return "stopped"
        default:
            return "null"
        }
    }
}

class SpotifyCurrentTrack: CurrentTrack {
 
    var name: String {
        return spotifyPlayer.currentTrack!.name!
    }
    
    var artist: String {
        return spotifyPlayer.currentTrack!.artist!
    }
    
    var album: String {
        return spotifyPlayer.currentTrack!.album!
    }
    
    var albumArtist: String {
        return spotifyPlayer.currentTrack!.albumArtist!
    }
    
    var duration: Double {
        return Double(spotifyPlayer.currentTrack!.duration!)
    }
    
    var tracknumber: Int {
        return spotifyPlayer.currentTrack!.trackNumber!
    }
    
    var artwork: Data {
        let dataURL = spotifyPlayer.currentTrack?.artworkUrl ?? ""
        let artworkdata = try? Data(contentsOf: URL(string: dataURL)!)
        return artworkdata ?? Data()
    }
    
    var discnumber: Int {
        return spotifyPlayer.currentTrack!.discNumber!
    }
}
