//
//  ImageMemory.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

var imageGroup = ImageMemory(originalImage: nil, processedImage: nil)

struct ImageMemory {
    var original: NSImage?
    var processed: NSImage?

    init(originalImage: NSImage?, processedImage: NSImage?) {
        original = originalImage
        processed = processedImage
    }
}
