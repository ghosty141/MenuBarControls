//
//  Spotify.swift
//  MenuBarControls
//
//  Created by Ghosty on 30.01.18.
//  Copyright © 2018 Ghostly. All rights reserved.
//

import Foundation
import ScriptingBridge

class Spotify: Player {
    
    let spotify = SBApplication(bundleIdentifier: "com.spotify.client")! as SpotifyApplication
    
    func playPause() {
        spotify.playpause!()
    }
    
    func setVolume(value: Int) {
        spotify.setSoundVolume!(value)
    }
    
    func nextTrack() {
        spotify.nextTrack!()
    }
    
    func previousTrack() {
        spotify.previousTrack!()
    }
    
    func setRepeat(value: Bool) {
        spotify.setRepeating!(value)
    }
    
    func setShuffle(value: Bool) {
        spotify.setShuffling!(value)
    }
}
