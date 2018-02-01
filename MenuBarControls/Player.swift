//
//  Player.swift
//  MenuBarControls
//
//  Created by Ghosty on 30.01.18.
//  Copyright © 2018 Ghostly. All rights reserved.
//

import Foundation

protocol Player {
    func playPause()
    func setVolume(value: Int)
    func nextTrack()
    func previousTrack()
    func setRepeat(value: Bool)
    func setShuffle(value: Bool)
}
