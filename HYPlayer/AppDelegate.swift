//
//  AppDelegate.swift
//  HYPlayer
//
//  Created by 吴昊原 on 2019/4/22.
//  Copyright © 2019 HYPlayer. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindow:NSWindow?
    let mainViewController = MainViewController(nibName: "MainViewController", bundle: Bundle.main)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        mainWindow = NSWindow(contentViewController: mainViewController)
        mainWindow?.title = ""
        mainWindow?.titlebarAppearsTransparent = true;
        mainWindow?.makeKeyAndOrderFront(nil)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

