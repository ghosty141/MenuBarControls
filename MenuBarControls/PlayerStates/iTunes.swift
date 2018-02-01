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
    
    let iTunes = SBApplication(bundleIdentifier: "com.apple.iTunes")! as iTunesApplication
    
    func playPause() {
        iTunes.playpause!()
    }
    
    func setVolume(value: Int) {
        iTunes.setSoundVolume!(value)
    }
    
    func nextTrack() {
        iTunes.nextTrack!()
    }
    
    func previousTrack() {
        iTunes.previousTrack!()
    }
    
    func setRepeat(value: Bool) {
        if (value) {
            iTunes.setSongRepeat!(iTunesERpt.one)
        } else {
            iTunes.setSongRepeat!(iTunesERpt.off)
        }
    }
    
    func setShuffle(value: Bool) {
        iTunes.setShuffleEnabled!(value)
    }
}
