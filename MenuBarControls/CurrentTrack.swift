//
//  CurrentTrack.swift
//  MenuBarControls
//
//  Created by Ghosty on 03.02.18.
//  Copyright © 2018 Ghostly. All rights reserved.
//

import Foundation

protocol CurrentTrack {
    var name: String { get }
    var artist: String { get }
    var album: String { get }
    var albumArtist: String { get }
    var duration: Double { get }
    var tracknumber: Int { get }
    var artwork: Data { get }
    var discnumber: Int { get }
}
