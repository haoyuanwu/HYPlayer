//
//  FuncTools.swift
//  Music
//
//  Created by 吴昊原 on 2018/8/30.
//  Copyright © 2018 吴昊原. All rights reserved.
//

import Cocoa

class FuncTools: NSObject {

    class func showAlertWarning(title: String,msg:String) {
        let alert = NSAlert()
        alert.addButton(withTitle: "ok")
        alert.messageText = title
        alert.informativeText = msg
        alert.alertStyle = NSAlert.Style.warning
        let window:NSWindow = NSApp.windows.first!
        alert.beginSheetModal(for: window) { (returnCode :NSApplication.ModalResponse) in
            
        }
    }
    
    class func addEqulierAlert(name: String ,complete:((_ returncode :NSApplication.ModalResponse)->Void)?) {
        let alert = NSAlert()
        alert.addButton(withTitle: "取消")
        alert.addButton(withTitle: "ok")
        alert.messageText = "添加自定义音效"
        alert.alertStyle = NSAlert.Style.informational
        alert.alertStyle = NSAlert.Style.warning
        let window:NSWindow = NSApp.windows.first!
        alert.beginSheetModal(for: window) { (returnCode :NSApplication.ModalResponse) in
            complete!(returnCode);
        }
    }
}
