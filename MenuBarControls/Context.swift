//
//  Context.swift
//  MenuBarControls
//
//  Created by Ghosty on 30.01.18.
//  Copyright © 2018 Ghostly. All rights reserved.
//

import Foundation

var player: Player = iTunes()

class Context {
    var currentTrack = ContextCurrentTrack()
    
    func playPause() {
        return player.playPause()
    }
    
    func nextTrack() {
        return player.nextTrack()
    }
    
    func previousTrack() {
        return player.previousTrack()
    }
    
    var volume: Int {
        get {
            return player.volume
        }
        set(value) {
            player.volume = value
        }
    }
    
    var repeating: Bool {
        get {
            return player.repeating
        }
        set(value) {
            player.repeating = value
        }
    }
    
    var shuffling: Bool {
        get {
            return player.shuffling
        }
        set(value) {
            player.shuffling = value
        }
    }
    
    var playerPosition: Double {
        get {
            return player.playerPosition
        }
        set(value) {
            player.playerPosition = value
        }
    }
    
    func isRunning() -> Bool {
        return player.isRunning()
    }
    
    func getPlayerState() -> String {
        return player.getPlayerState()
    }
    
    func useSpotify() {
        return player = Spotify()
    }
    
    func useiTunes() {
        return player = iTunes()
    }
}

class ContextCurrentTrack {
    
    var name: String {
        return player.currentTrack.name
    }
    
    var artist: String {
        return player.currentTrack.artist
    }
    
    var album: String {
        return player.currentTrack.album
    }
    
    var albumArtist: String {
        return player.currentTrack.albumArtist
    }
    
    var duration: Double {
        return player.currentTrack.duration
    }
    
    var tracknumber: Int {
        return player.currentTrack.tracknumber
    }
    
    var artwork: Data {
        return player.currentTrack.artwork
    }
    
    var discnumber: Int {
        return player.currentTrack.discnumber
    }
}
