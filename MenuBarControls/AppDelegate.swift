//
//  AppDelegate.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

let spotify = Spotify()

var imageGroup = ImageMemory(originalImage: nil, processedImage: nil)
var startedAtLogin = false

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {

    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    var popover: NSPopover?
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if launchedBefore  == false {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(1, forKey: "UpdateRate")
            UserDefaults.standard.set(10, forKey: "blurValue")
            UserDefaults.standard.set(50, forKey: "brightnessValue")
            UserDefaults.standard.set(0, forKey: "trackInfoDelay")
            UserDefaults.standard.set(0, forKey: "displayTrackTitle")
            UserDefaults.standard.set(0, forKey: "displayAlbumTitle")
            UserDefaults.standard.set(0, forKey: "displayArtistName")
            UserDefaults.standard.set(0, forKey: "displayTrackTime")
        }

        NSUserNotificationCenter.default.delegate = self

        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarIcon")
            button.action = #selector(AppDelegate.togglePopover(_:))
        }

        eventMonitor = EventMonitor(
        mask: [NSEventMask.leftMouseDown, NSEventMask.rightMouseDown]) { [weak weakself = self] event in
            if weakself?.popover?.isShown != nil {
                weakself?.closePopover(event)
            }
        }

        for app in NSWorkspace.shared().runningApplications where app.bundleIdentifier == "com.Ghostly.MBCLauncher" {
            startedAtLogin = true
        }

        if startedAtLogin {
            DistributedNotificationCenter.default().post(
                name: Notification.Name("killme"),
                object: Bundle.main.bundleIdentifier!)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        eventMonitor?.stop()
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func togglePopover(_ sender: AnyObject?) {
        if spotify.isRunning() == true {
            if popover == nil || popover?.isShown == false {
                popover = NSPopover()
                popover?.contentViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(
                    withIdentifier: "PlayerPopover") as? NSViewController
                showPopover(sender)
            } else {
                popover?.close()
            }
        } else {
            let notification = NSUserNotification()
            notification.title = "Error: Spotify is not running!"
            notification.informativeText = "Please start Spotify to continue"
            notification.soundName = NSUserNotificationDefaultSoundName
            let notificationCenter = NSUserNotificationCenter.default
            notificationCenter.deliver(notification)
        }
    }

    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover?.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }

    func closePopover(_ sender: AnyObject?) {
        popover?.performClose(sender)
        eventMonitor?.stop()
        popover = nil
    }

}
