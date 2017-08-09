//
//  ImageMemory.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

class ImageMemory {
    var original: NSImage?
    var processed: NSImage?

    init(originalImage: NSImage?, processedImage: NSImage?) {
        original = originalImage
        processed = processedImage
    }

    deinit {
        original = nil
        processed = nil
    }
}
