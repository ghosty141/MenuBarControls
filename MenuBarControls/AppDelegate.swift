//
//  AppDelegate.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {

    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    let spotify = Spotify()
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if launchedBefore  == false {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(1, forKey: "UpdateRate")
            UserDefaults.standard.set(10, forKey: "blurValue")
            UserDefaults.standard.set(50, forKey: "brightnessValue")
            UserDefaults.standard.set(1, forKey: "displayTrackTitle")
            UserDefaults.standard.set(1, forKey: "displayAlbumTitle")
            UserDefaults.standard.set(1, forKey: "displayArtistName")
            UserDefaults.standard.set(1, forKey: "displayTrackTime")
        }

        NSUserNotificationCenter.default.delegate = self

        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarIcon")
            button.action = #selector(AppDelegate.togglePopover(_:))
        }

        eventMonitor = EventMonitor(
        mask: [NSEventMask.leftMouseDown, NSEventMask.rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(event)
            }
        }

        let storyboard = NSStoryboard(name: "Main", bundle: nil)

        popover.contentViewController = storyboard.instantiateController(
            withIdentifier: "PlayerPopover") as? NSViewController

    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func togglePopover(_ sender: AnyObject?) {
        if spotify.isRunning() == true {
            if popover.isShown {
                closePopover(sender)
            } else {
                showPopover(sender)
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
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        NotificationCenter.default.post(name: Notification.Name("ShowPopupNotification"), object: nil)
        eventMonitor?.start()
    }

    func closePopover(_ sender: AnyObject?) {
        NotificationCenter.default.post(name: Notification.Name("ClosePopupNotification"), object: nil)
        popover.performClose(sender)
        eventMonitor?.stop()
    }

}
