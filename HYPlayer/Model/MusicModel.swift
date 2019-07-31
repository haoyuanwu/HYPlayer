//
//  MusicModel.swift
//  WHPlayer
//
//  Created by 吴昊原 on 2019/4/17.
//  Copyright © 2019 HYPlayer. All rights reserved.
//

import Cocoa

class MusicModel: NSObject {
    static let sharedInstance = MusicModel();
    
    var musicId = ""
    /*  歌曲id */
    var singer = ""
    /*歌手 */
    var song = ""
    /*歌曲名 */
    var image = ""
    /*图片 */
    var albumName = ""
    /*专辑名 */
    var fileSize = ""
    /*文件大小 */
    var voiceStyle = ""
    /*音质类型 */
    var fileStyle = ""
    /*文件类型 */
    var creatDate = ""
    /*创建日期 */
    var savePath = ""
    /*存储路径 */
    var url = ""
    /*文件路径 */
    var createTime = ""
    /* 上传的时间 */
    var urlData: Data?
    /* 沙盒授权数据 */
    var isUpdata: Int = 0
    /*是否上传 */
    var isDownloaded: Int = 0
    /*是否已下载 */
    var musicArray: [AnyHashable] = []
    var downloadArray: [AnyHashable] = []
    
}
