//
//  File.swift
//  MenuBarControls
//
//  Created by Ghosty on 01.02.18.
//  Copyright © 2018 Ghostly. All rights reserved.
//

import Foundation
import ScriptingBridge

class iTunes: Player {
    
    let iTunesPlayer = SBApplication(bundleIdentifier: "com.apple.iTunes")! as iTunesApplication
    
    func playPause() {
        iTunesPlayer.playpause!()
    }
    
    func nextTrack() {
        iTunesPlayer.nextTrack!()
    }
    
    func previousTrack() {
        iTunesPlayer.previousTrack!()
    }
    
    var volume: Int {
        get {
            return iTunesPlayer.soundVolume!
        }
        set(value) {
            iTunesPlayer.setSoundVolume!(value)
        }
    }
    
    var repeating: Bool {
        get {
            if iTunesPlayer.songRepeat != .off {
                return true
            } else {
                return false
            }
        }
        set(value) {
            iTunesPlayer.setSongRepeat!(value ? .one : .off)
        }
    }
    
    var shuffling: Bool {
        get {
            return iTunesPlayer.shuffleEnabled!
        }
        set(value) {
            iTunesPlayer.setShuffleEnabled!(value)
        }
    }
    
    var playerPosition: Double {
        get {
            return iTunesPlayer.playerPosition!
        }
        set (value) {
            iTunesPlayer.setPlayerPosition!(value)
        }
    }

    func isRunning() -> Bool {
        return iTunesPlayer.isRunning
    }
    
    func getPlayerState() -> String {
        switch iTunesPlayer.playerState {
        case .playing?:
            return "playing"
        case .paused?:
            return "paused"
        case .stopped?:
            return "stopped"
        case .fastForwarding?:
            return "fastforwarding"
        case .rewinding?:
            return "rewinding"
        default:
            return "null"
        }
    }
    
    func getCurrentCoverData() -> Data {
        return Data()
    }
}
