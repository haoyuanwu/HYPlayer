//
//  PlayView.swift
//  WHPlayer
//
//  Created by 吴昊原 on 2019/4/22.
//  Copyright © 2019 HYPlayer. All rights reserved.
//

import Cocoa

class PlayView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
    }
    
}
