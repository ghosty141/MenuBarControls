//
//  Context.swift
//  MenuBarControls
//
//  Created by Ghosty on 30.01.18.
//  Copyright © 2018 Ghostly. All rights reserved.
//

import Foundation

class Context {
    
    private var player: Player = Spotify()
    
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
    
    func getCurrentCoverData() -> Data {
        return player.getCurrentCoverData()
    }
    
    func useSpotify() {
        return player = Spotify()
    }
    
    func useiTunes() {
        return player = iTunes()
    }
}

