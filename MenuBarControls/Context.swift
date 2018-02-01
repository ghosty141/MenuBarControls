//
//  Context.swift
//  MenuBarControls
//
//  Created by Ghosty on 30.01.18.
//  Copyright © 2018 Ghostly. All rights reserved.
//

import Foundation

class Context {
    
    private var player: Player = Initial()
    
    func playPause() {
        return player.playPause()
    }
    
    func setVolume(value: Int) {
        return player.setVolume(value: value)
    }
    
    func nextTrack() {
        return player.nextTrack()
    }
    
    func previousTrack() {
        return player.previousTrack()
    }
    
    func setRepeating(value: Bool) {
        return player.setRepeat(value: value)
    }
    
    func setShuffle(value: Bool) {
        return player.setShuffle(value: value)
    }
    
    func useInitial() {
        return player = Initial();
    }
    
    func useSpotify() {
        return player = Spotify();
    }
    
}

