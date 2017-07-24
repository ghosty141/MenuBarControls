//
//  EventMonitor.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

public class EventMonitor: NSObject {
    private var monitor: AnyObject?
    private let mask: NSEventMask
    private let handler: (NSEvent?) -> Void

    public init(mask: NSEventMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }

    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
    }

    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
