//
//  MusicTableViewController.swift
//  HYPlayer
//
//  Created by 吴昊原 on 2019/5/13.
//  Copyright © 2019 HYPlayer. All rights reserved.
//

import Cocoa

class MusicTableViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource {
    
    var musicArr: [MusicModel] = []
    var row: Int = 0
    var menuBlock: ((_ tag: Int, _ array: [Any]?, _ index: Int) -> Void)?
    //    var musicListStyle: TableViewMusicListStyle?
    
    var item1: NSMenuItem?
    var item2: NSMenuItem?
    var item3: NSMenuItem?
    var item4: NSMenuItem?
    var item5: NSMenuItem?
    
    var _index: Int = 0
    var tmpIndex: Int = 0
    
    lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView(frame: self.view.frame)
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.focusRingType = .none
        scrollView.autohidesScrollers = true
        scrollView.borderType = .bezelBorder
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = tableView
        return scrollView
    }()
    
    lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.target = self
        
        tableView.doubleAction = #selector(self.tableDoubleAction)
        tableView.register(NSNib(nibNamed: "MusicTableViewCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier("Columnid"))
        tableView.register(NSNib(nibNamed: "MusicTableCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier("Coulumnid2"))
        tableView.registerForDraggedTypes([.fileURL])
        
        
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        let column2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("personName"))
        let column3 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("album"))
        let column4 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("size"))
        
        column1.title = "歌名"
        column2.title = "歌手"
        column3.title = "专辑名"
        column4.title = "大小"
        column1.width = 240
        column2.width = 180
        column3.width = 180
        column4.width = 80
        
        tableView.addTableColumn(column1)
        tableView.addTableColumn(column2)
        tableView.addTableColumn(column3)
        tableView.addTableColumn(column4)
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view.addSubview(scrollView)
        
        tmpIndex = INTPTR_MAX;
        
        menu = NSMenu()
        item1 = NSMenuItem(title: "播放", action: #selector(self.rightMenu(_:)), keyEquivalent: "")
        item2 = NSMenuItem(title: "从Finder打开", action: #selector(self.rightMenu(_:)), keyEquivalent: "")
        item3 = NSMenuItem(title: "复制链接", action: #selector(self.rightMenu(_:)), keyEquivalent: "")
        item4 = NSMenuItem(title: "上传", action: #selector(self.rightMenu(_:)), keyEquivalent: "")
        item5 = NSMenuItem(title: "删除", action: #selector(self.rightMenu(_:)), keyEquivalent: "")
        item1?.tag = 101
        item2?.tag = 102
        item3?.tag = 103
        item4?.tag = 104
        item5?.tag = 105
        menu?.addItem(item1!)
        item1!.keyEquivalentModifierMask = .shift
        menu?.addItem(item2!)
        menu?.addItem(item3!)
        menu?.addItem(item4!)
        menu?.addItem(item5!)

        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return musicArr.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return nil
    }
    
    func tableView(_ tableView: NSTableView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        
        var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("row"), owner: self) as? NSTableRowView
        if cell == nil {
            cell = NSTableRowView()
            cell?.selectionHighlightStyle = .none
            cell?.identifier = NSUserInterfaceItemIdentifier("row")
        }
        _index = 0
        return cell
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let musicModel: MusicModel? = musicArr[row] as? MusicModel
        let identfiter = tableColumn?.identifier ?? NSUserInterfaceItemIdentifier("identifier")
        var view: MusicTableCell?
        var columnView: MusicTableViewCell?
        if (identfiter.rawValue == "name") {
            view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Columnid"), owner: self) as? MusicTableCell
        } else {
            view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Coulumnid2"), owner: self) as? MusicTableCell
        }
        
        var textfield: NSTextField?
        textfield = view?.nameTextfield
        
        switch _index {
        case 0:
            textfield?.stringValue = musicModel?.song ?? "未知"
        case 1:
            textfield?.stringValue = musicModel?.singer ?? "未知"
        case 2:
            textfield?.stringValue = musicModel?.albumName ?? "未知"
        case 3:
            textfield?.stringValue = musicModel?.fileSize ?? ""
        default:
            break
        }
        _index += 1
        
        return view
    }

    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        return NSDragOperation.every
    }

    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        
        let pasteBoard: NSPasteboard = info.draggingPasteboard
        if pasteBoard.types?.contains(NSPasteboard.PasteboardType.fileURL) ?? false {
            
            let queue = DispatchQueue.global(qos: .default)
            queue.async(execute: {
                
                let arrayURL = pasteBoard.propertyList(forType: .fileURL) as? [Any]
                
                var array = [AnyHashable](repeating: 0, count: 1)
                for strURL in arrayURL as? [String] ?? [] {
                    let url = URL(fileURLWithPath: strURL)
                    array.append(url)
                }
                if pasteBoard.types?.contains(NSPasteboard.PasteboardType.fileURL) ?? false {
                    
                    var urlArr = array
                    for model:MusicModel in self.musicArr {
                        var index = 0
                        for url in array as? [URL] ?? [] {
                            if (model.savePath == url.description.removingPercentEncoding) {
                                array.remove(at: index)
                            }
                        }
                    }
                    for url in urlArr as? [URL] ?? [] {
                        self.musicArr.insert(Function.getMusicInfoUrl(url), at: row)
                    }
                    DispatchQueue.main.sync(execute: {
                        saveData()
                        if urlArr.count > 0 {
                            self.tableView.insertRows(at: NSIndexSet(index: row) as IndexSet, withAnimation: .slideUp)
                        }
                        self.tableView.reloadData()
                    })
                }
            })
            
            return true
        } else {
            return false
        }
        
    }

    
    func saveData() {
        let data = NSKeyedArchiver.archivedData(withRootObject: musicArr)
        UserDefaults.standard.set(data, forKey: musicData)
    }
    
    func rightMouseDown(with event: NSEvent) {
        window().makeFirstResponder(self)
        
        let tablePoint = tableView.convert(event.locationInWindow, from: nil) as? NSPoint
        row = tableView.row(at: tablePoint ?? NSPoint.zero)
        tableView.deselectRow(tableView.selectedRow)
        tableView.selectRowIndexes(NSIndexSet(index: row) as IndexSet, byExtendingSelection: true)
        if row >= 0 {
            menu.popUp(positioning: item1, at: tablePoint ?? NSPoint.zero, in: tableView)
        }
        
    }


    
    /**
     双击方法
     */
    @objc func tableDoubleAction() {
        if tableView.selectedRow >= 0 {
            AAudioPlayerModule.share().player(withArr: musicArr, to: tableView.selectedRow, path: nil)
        }
    }
    
    @objc func rightMenu(_ item: NSMenuItem?) {
        if (menuBlock != nil) {
            menuBlock!(item!.tag, musicArr, row)
        }
    }


}
