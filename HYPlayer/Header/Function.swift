//
//  Function.swift
//  HYPlayer
//
//  Created by 吴昊原 on 2019/5/13.
//  Copyright © 2019 HYPlayer. All rights reserved.
//

import Cocoa
import COCOAKit

class Function: NSObject {
    
    func getMusicInfoUrl(url:URL) -> MusicModel {
        
        var model:MusicModel = MusicModel()
        var date = NSDate()
        model.creatDate = date.string(withFormatter: "yyyy-MM-dd HH:mm:ss")
        
        var filePath = url.description.removingPercentEncoding
        
        var urlData: Data? = nil
        do {
            urlData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
        } catch {
           
        }
        model.urlData = urlData
        
        var fileAttributes: [FileAttributeKey : Any]? = nil
        do {
            fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
        } catch {
            
        }
        model.fileSize = String(format: "%.2fMB", CGFloat(fileAttributes?[FileAttributeKey.size] as! CGFloat ?? 0.0) / 1000 / 1000)
        
        var fileName = filePath?.components(separatedBy: "/").last
        var nameStr = fileName?.components(separatedBy: ".").first
        model.song = nameStr ?? ""
        
        //文件管理，取得文件属性
        
        var dictAtt: [FileAttributeKey : Any]? = nil
        do {
            dictAtt = try FileManager.default.attributesOfItem(atPath: url.path())
        } catch {
        }
        //取得音频数据
        var mp3Asset = AVURLAsset(url: url, options: nil)
        var singer = "" //歌手
        var song = "" //歌曲名
        //    NSImage *image;//图片
        var albumName = "" //专辑名
        var fileSize = "" //文件大小
        var voiceStyle = "" //音质类型
        var fileStyle = "" //文件类型
        var creatDate = "" //创建日期
        var savePath = "" //存储路径
        
        for (NSString *format in [mp3Asset availableMetadataFormats]) {
            for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
                if([metadataItem.commonKey isEqualToString:@"title"]){
                    song = (NSString *)metadataItem.value;//歌曲名
                    model.song = song;
                    NSLog(@"歌曲名称:%@",song);
                }else if ([metadataItem.commonKey isEqualToString:@"artist"]){
                    singer = (NSString *)metadataItem.value;//歌手
                    model.singer = singer;
                    NSLog(@"歌手:%@",singer);
                }
                    //            专辑名称
                else if ([metadataItem.commonKey isEqualToString:@"albumName"])
                {
                    albumName = (NSString *)metadataItem.value;
                    model.albumName = albumName;
                }else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                    
                    model.image = [((NSData *)metadataItem.value) base64EncodedStringWithOptions:(NSDataBase64EncodingEndLineWithLineFeed)];
                    
                }
                
                savePath = filePath;
                if (dictAtt != nil) {
                    float tempFlo = [[dictAtt objectForKey:@"NSFileSize"] floatValue]/(1024*1024);
                    fileSize = [NSString stringWithFormat:@"%.2fMB",[[dictAtt objectForKey:@"NSFileSize"] floatValue]/(1024*1024)];
                    model.fileSize = fileSize;
                    NSLog(@"文件大小：%@",fileSize);
                    NSString *tempStrr  = [NSString stringWithFormat:@"%@", [dictAtt objectForKey:@"NSFileCreationDate"]] ;
                    
                    creatDate = [tempStrr substringToIndex:19];
                    fileStyle = [filePath substringFromIndex:[filePath length]-3];
                    NSLog(@"文件格式：%@",fileStyle);
                    model.fileStyle = fileStyle;
                    if(tempFlo <= 2){
                        voiceStyle = @"普通";
                    }else if(tempFlo > 2 && tempFlo <= 5){
                        voiceStyle = @"良好";
                    }else if(tempFlo > 5 && tempFlo < 10){
                        voiceStyle = @"标准";
                    }else if(tempFlo > 10){
                        voiceStyle = @"高品质";
                    }
                    model.voiceStyle = voiceStyle;
                    NSLog(@"文件品质：%@",voiceStyle);
                    
                    if (![model.fileStyle isEqualToString:@"mp3"]) {
                        NSString *fileNames = [filePath componentsSeparatedByString:@"/"].lastObject;
                        model.singer = [fileNames componentsSeparatedByString:@" - "].firstObject;
                        NSString *songName = [fileNames componentsSeparatedByString:@" - "].lastObject;
                        model.song = [songName substringWithRange:(NSMakeRange(0, songName.length - 5))];
                    }
                }
            }
        }
        if (!model.fileStyle || [model.fileStyle isEqualToString:@""]) {
            model.fileStyle = @"mp3";
        }
        
        return model;
        
    }
}
