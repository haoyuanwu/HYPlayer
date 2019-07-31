//
//  HYSliderView.swift
//  HYPlayer
//
//  Created by 吴昊原 on 2019/4/22.
//  Copyright © 2019 HYPlayer. All rights reserved.
//

import Cocoa

class HYSliderView: NSView {
    
    let imageView = NSImageView(frame: NSRect(x: 100, y: 0, width: 10, height: 10))
    var fullColor = NSColor.red.cgColor
    var progress = 0;
    var maxProgress = 1;
    var minProgress = 0;
    private let progressView = NSView()
    
    var isDown = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        //写这句话才会相应鼠标的进入和退出
        self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false)
        
        progressView.frame = CGRect(x: 0, y: self.height()/2-1.5, width: self.width(), height: 2)
        progressView.wantsLayer = true;
        progressView.layer?.backgroundColor = fullColor
        
        self.addSubview(progressView)
        
        imageView.wantsLayer = true
        imageView.layer?.backgroundColor = fullColor
        imageView.layer?.masksToBounds = true
        imageView.layer?.cornerRadius = 5;
        imageView.alphaValue = 0;
        self.addSubview(imageView)
        
    }
    
    override func mouseEntered(with event: NSEvent) {
        imageView.alphaValue = 1;
    }
    
    override func mouseExited(with event: NSEvent) {
        if !isDown {
            imageView.alphaValue = 0
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        imageView.alphaValue = 1;
        let mouseLoc = event.locationInWindow;
        let progress = mouseLoc.x/self.width();
        
        if progress >= 0.0 && mouseLoc.x <= self.width()-10{
            var rect = imageView.frame
            rect.origin.x = mouseLoc.x
            imageView.frame = rect;
        }else if (progress < 0){
            var rect = imageView.frame
            rect.origin.x = 0
            imageView.frame = rect;
        }else if (progress > 1) {
            var rect = imageView.frame
            rect.origin.x = self.width()-10
            imageView.frame = rect;
        }
        isDown = true
    }
    
    override func mouseUp(with event: NSEvent) {
        if !isDown {
            imageView.alphaValue = 0
        }
        isDown = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        let mouseLoc = event.locationInWindow;
        let progress = mouseLoc.x/self.width();
        
        if progress >= 0.0 && mouseLoc.x <= self.width()-10{
            var rect = imageView.frame
            rect.origin.x = mouseLoc.x
            imageView.frame = rect;
        }else if (progress < 0){
            var rect = imageView.frame
            rect.origin.x = 0
            imageView.frame = rect;
        }else if (progress > 1) {
            var rect = imageView.frame
            rect.origin.x = self.width()-10
            imageView.frame = rect;
        }
        
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        progressView.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.right.offset()(0)
            make?.left.offset()(0)
        }
        // Drawing code here.
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
}
