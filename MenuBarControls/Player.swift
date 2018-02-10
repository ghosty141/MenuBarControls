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
    func nextTrack()
    func previousTrack()

    func isRunning() -> Bool
    func getPlayerState() -> String
    
    var volume: Int { get set }
    var repeating: Bool { get set }
    var shuffling: Bool { get set }
    var playerPosition: Double { get set }
    
    var currentTrack: CurrentTrack { get set }
}
