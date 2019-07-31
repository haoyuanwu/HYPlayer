//
//  AAudioPlayerModule.swift
//  Music
//
//  Created by 吴昊原 on 2018/8/27.
//  Copyright © 2018 吴昊原. All rights reserved.
//

import Cocoa
import AVFoundation

class AAudioPlayerModule: NSObject {
    
    private let defaultSampleRate:Double = 44100
    private let defaultChannels:AVAudioChannelCount = 2
    var volume: CGFloat = 0.0
    var _playIndex: Int = 0
    var _playerUrl: URL?
    private var _duration: Double = 0.0
    private var fileHandle_read: FileHandle = FileHandle()
    private var fileHandle_write: FileHandle = FileHandle()
    private var playLenght: UInt64 = 0
    private var _startTime: Double = 0.0
    var defaultFormat:AVAudioFormat?
    var musicArr: [Any] = []
    private var audioAsset: AVURLAsset?
    var reverb:AVAudioUnitReverb = AVAudioUnitReverb()
    var playerModel: MusicPlayerModel = .sequencePlayerModel
    weak var delegate: AAudioPlayerModuleDelegate?
    /**
     播放文件
     */
    private var internalAudioFile: AVAudioFile?
    /**
     均衡器
     */
    private var eq: AVAudioUnitEQ = AVAudioUnitEQ(numberOfBands: 10)
    /**
     节点
     */
    private var engine: AVAudioEngine = AVAudioEngine()
    /**
     播放器
     */
    var player: AVAudioPlayerNode = AVAudioPlayerNode()
    /**
     进度条计时器
     */
    var timer: Timer?
    var model: MusicModel?
    
    // MARK: - sharedInstance
    static let sharedInstance = AAudioPlayerModule();
    
    
    class func share() -> AAudioPlayerModule {
        return AAudioPlayerModule.sharedInstance;
    }
    
    
    // MARK: - engine设置
    ///将节点连接到engine上, 并启动engine
    public func startEngine() {
        //初始化eq均衡器的frequency数值, 参考qq音乐播放器
        let frequencys = [31.0, 62.0, 125.0, 250.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0, 16000.0]
        for i in 0...9 {
            let filterParams = eq.bands[i]
            filterParams.bandwidth = 1.0
            filterParams.bypass = false
            filterParams.frequency = Float(frequencys[i])
        }
        self.defaultFormat = AVAudioFormat(standardFormatWithSampleRate: self.defaultSampleRate, channels: self.defaultChannels)
        
        connectNode(format: self.defaultFormat)
        if !engine.isRunning {
            do {
                try engine.start()
            } catch let error as NSError {
                NSLog("couldn't start engine, Error: \(error)")
            }
        }
        
        _startTime = 0;
        volume = 1;
    }
    
    ///连接节点
    private func connectNode(format: AVAudioFormat?) {
        
        engine.attach(player)
        engine.attach(eq)
        engine.attach(reverb)
        
        engine.connect(player, to: eq, format: self.defaultFormat)
        engine.connect(eq, to: engine.mainMixerNode, format: self.defaultFormat)
    }
    
    func openEqulier(_ time: Double) {
        self.timerOut()
        
        engine.connect(player, to: eq, format: self.defaultFormat)
        engine.connect(eq, to: engine.mainMixerNode, format: self.defaultFormat)
        
        self.seekTotime(time)
    }
    
    func openEnvironment(_ time: Double) {
        
        self.timerOut()
        let mainMixer: AVAudioMixerNode = engine.mainMixerNode
        engine.connect(player, to: reverb, format: self.defaultFormat)
        engine.connect(reverb, to: mainMixer, fromBus: 0, toBus: 0, format: self.defaultFormat)
        self.seekTotime(time)
    }
    
    func changeEnvironment(format:AVAudioUnitReverbPreset) {
        self.reverb.loadFactoryPreset(format);
        
    }
    
    func player(withArr array: [Any], to index: Int, path: String?) {
        self.musicArr = array
        _playIndex = index
        if path == nil {
            self.model = array[index] as? MusicModel
            _startTime = 0
            
//            _playerUrl = URL(string: model!.savePath);
            var bookmarkDataIsStale = false
            _playerUrl = try! URL.init(resolvingBookmarkData: model!.urlData!, options: [.withSecurityScope, .withoutUI], relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale)
            // 开启权限
            let success = _playerUrl?.startAccessingSecurityScopedResource()
            if !success! {
                FuncTools.showAlertWarning(title: "Error", msg: "未获取沙盒权限")
            }
            self.audioAsset = AVURLAsset(url: _playerUrl!, options: nil)
        } else {
            _playerUrl = URL(string: path ?? "")
        }
        openPlayer()
    }
    
    func openPlayer() {
        if player.isPlaying {
            timerOut()
        }
        
        do {
            internalAudioFile = try AVAudioFile(forReading: _playerUrl!)
        } catch let error as NSError {
            FuncTools.showAlertWarning(title: "不能打开文件", msg: "Error: \(error)")
            return;
        }
        if (internalAudioFile?.length)! > 0 {
            player.scheduleFile(internalAudioFile!, at: nil, completionHandler: nil)
        }else{
            FuncTools.showAlertWarning(title: "Error", msg: "文件读取失败")
            return;
        }
        
        if !engine.isRunning {
            try? engine.start()
        }
        if engine.isRunning {
            player.play()
            
            NotificationCenter.default.post(name: NSNotification.Name("playeredNSNotification"), object: nil)
            timerUp()
        }
    }
    
    func seekTotime(_ time: Double) {
        timerOut()
        _startTime = time * CMTimeGetSeconds(self.audioAsset!.duration)
        // 开启权限
        var bookmarkDataIsStale = true
        _playerUrl = try! URL.init(resolvingBookmarkData: model!.urlData!, options: [.withSecurityScope, .withoutUI], relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale)
        let success = _playerUrl?.startAccessingSecurityScopedResource()
        if !success! {
            FuncTools.showAlertWarning(title: "Error", msg: "未获取沙盒权限")
        }
        playLenght = uint64((getMusicSize(_playerUrl!.path)) * time)
        fileHandle_read = FileHandle(forReadingAtPath: _playerUrl!.path)!
        let path = NSHomeDirectory() + ("/Documents/play.\(model!.fileStyle)")
        let manager = FileManager.default
        var isDir:ObjCBool = false
        let isExists: Bool = manager.fileExists(atPath: path, isDirectory: &isDir)
        if isExists {
            try? manager.removeItem(atPath: path)
        }
        manager.createFile(atPath: path, contents: nil, attributes: nil)
        fileHandle_write = FileHandle(forWritingAtPath: path)!
        let fileSize: uint64 = uint64(getMusicSize(_playerUrl!.path))
        while playLenght != fileSize {
            fileHandle_read.seek(toFileOffset: playLenght)
            let data = fileHandle_read.readData(ofLength: 10485760)
            fileHandle_write.seekToEndOfFile()
            fileHandle_write.write(data)
            playLenght = playLenght + UInt64((data.count))
        }
        player(withArr: self.musicArr, to: _playIndex, path: path)
    }
    
    func getMusicSize(_ path: String?) -> Double {
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: path ?? "")
        return fileAttributes?[FileAttributeKey.init("NSFileSize")] as! Double
    }

    /**
     关闭定时
     */
    func timerOut() {
        engine.stop()
        player.stop()
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    /**
     启动定时
     */
    func timerUp() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            let nodeTime: AVAudioTime? = self.player.lastRenderTime
            if nodeTime != nil {
                var playerTime: AVAudioTime? = nil
                if let aTime = nodeTime {
                    playerTime = self.player.playerTime(forNodeTime: aTime)
                }
                let audioDuration: CMTime = self.audioAsset!.duration
                let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
                let current = Double(playerTime?.sampleTime ?? AVAudioFramePosition(0.0)) / (playerTime?.sampleRate ?? 0.0) + self._startTime
                let total: Double = audioDurationSeconds
                let obj = String(format: "%d:%02d/%d:%02d", Int(current) / 60, Int(current) % 60, Int(total) / 60, Int(total) % 60)
                let value = Float64(current / audioDurationSeconds)
                if (self.delegate != nil && (self.delegate?.responds(to: #selector(self.delegate?.playerModuleChangeProgress(_:volume:current:total:progressTitle:))))!)  {
                    self.delegate?.playerModuleChangeProgress!(self, volume: value, current: current, total: total, progressTitle: obj)
                }
                if value >= 1 {
                    self.timerOut()
                    self.nextAction()
                }
            }
        })
    }
    
    func updateEQ(withBandIndex BandIndex: Int, gain: Float) {
        let filterParams: AVAudioUnitEQFilterParameters? = eq.bands[BandIndex]
        filterParams?.gain = gain
    }
    
    func updateEQgains(_ gains: [String]?) {
        for i in 0..<9 {
            let filterParams: AVAudioUnitEQFilterParameters? = eq.bands[i]
            filterParams?.gain = Float(gains![i])!
        }
    }
        
    func prevAction() {
        timerOut()
        if _playIndex > 0 {
            _playIndex -= 1
        } else {
            _playIndex = musicArr.count - 1
        }
        if (self.delegate != nil && (self.delegate?.responds(to: #selector(self.delegate?.playerModuleNextAction(_:dataSource:index:))))!) {
            self.delegate?.playerModuleNextAction!(self, dataSource: self.musicArr, index: _playIndex)
        }
        player(withArr: musicArr, to: _playIndex, path: nil)
    }
    
    func nextAction() {
        timerOut()
        if playerModel == .randomPlayerModel {
            _playIndex = Int(arc4random() % uint32(musicArr.count))
        } else if playerModel == .sequencePlayerModel {
            if _playIndex < musicArr.count - 1 {
                _playIndex += 1
            } else {
                _playIndex = 0
            }
        }
        if self.delegate != nil && (self.delegate?.responds(to: #selector(self.delegate?.playerModuleNextAction(_:dataSource:index:))))! {
            self.delegate?.playerModuleNextAction!(self, dataSource: self.musicArr, index: _playIndex)
        }
        player(withArr: musicArr, to: _playIndex, path: nil)
    }
    
    func playAction() {
        NotificationCenter.default.post(name: NSNotification.Name("playeredNSNotification"), object: nil)
        if player.isPlaying {
            player.pause()
            timer?.invalidate()
        } else {
            player.play()
            timerUp()
        }
        if self.delegate != nil {
            self.delegate?.playerModulePlayAction!(self, player: player)
        }
    }
    
    func getdbPower() {
        
    }
}

@objc protocol AAudioPlayerModuleDelegate: NSObjectProtocol {
    
    @objc optional func playerModulePlayAction(_ PlayerModule: AAudioPlayerModule, player: AVAudioPlayerNode?)
    
    @objc optional func playerModulePreviousAction(_ PlayerModule: AAudioPlayerModule, dataSource: [Any]?, index: Int)
    
    @objc optional func playerModuleNextAction(_ PlayerModule: AAudioPlayerModule, dataSource: [Any]?, index: Int)
    
    @objc optional func playerModuleChangeProgress(_ PlayerModule: AAudioPlayerModule, volume: Double, current: Float64, total: Float64, progressTitle ProgressTitle: String?)
}

