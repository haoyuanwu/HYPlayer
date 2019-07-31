//
//  Interface.swift
//  WHPlayer
//
//  Created by 吴昊原 on 2019/4/17.
//  Copyright © 2019 HYPlayer. All rights reserved.
//

import Foundation
import AppKit

let mainWindow = NSApp.windows.last
let SCREEN_WIDTH = NSScreen.main?.frame.size.width
let SCREEN_HEIGHT = NSScreen.main?.frame.size.height

enum MusicPlayerModel {
    case sequencePlayerModel
    case randomPlayerModel
    case circulationPlayerModel
}



