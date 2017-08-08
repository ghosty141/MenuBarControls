//
//  AppDelegate.swift
//  MBCHelper
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let mainAppIdentifier = "com.Ghostly.MenuBarControls"
        let running           = NSWorkspace.shared.runningApplications
        var alreadyRunning    = false

        for app in running where app.bundleIdentifier == mainAppIdentifier {
            alreadyRunning = true
            break
        }

        if !alreadyRunning {
            DistributedNotificationCenter.default().addObserver(self,
                                                                selector: #selector(self.terminate),
                                                                name: Notification.Name("killme"),
                                                                object: mainAppIdentifier)

            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("MenuBarControls")
            let newPath = NSString.path(withComponents: components)

            NSWorkspace.shared.launchApplication(newPath)
        } else {
            self.terminate()
        }
    }

    @objc func terminate() {
        NSApp.terminate(nil)
    }

}
