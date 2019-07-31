//
//  NSViewExpand.swift
//  WHPlayer
//
//  Created by 吴昊原 on 2019/4/22.
//  Copyright © 2019 HYPlayer. All rights reserved.
//

import Foundation
import Cocoa

extension NSView {
    
    func width() -> CGFloat {
        return self.frame.size.width
    }
    
    func height() -> CGFloat {
        return self.frame.size.height
    }
    
    func top() -> CGFloat {
        return self.frame.origin.y
    }
    
    func bottom() -> CGFloat {
        return self.frame.origin.y + self.height()
    }
    
    func left() -> CGFloat {
        return self.frame.origin.x
    }
    
    func right() -> CGFloat {
        return self.frame.origin.x + self.width()
    }
}
