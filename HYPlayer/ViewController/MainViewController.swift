//
//  MainViewController.swift
//  WHPlayer
//
//  Created by 吴昊原 on 2019/4/22.
//  Copyright © 2019 HYPlayer. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet var backgroundView: NSView!
    @IBOutlet weak var playView: PlayView!
    
    lazy var tableViewVC: MusicTableViewController = {
        let tableView = MusicTableViewController(nibName: "MusicTableViewController", bundle: Bundle.main);
        
        return tableView
    }()
    
    var sliderView : HYSliderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChild(tableViewVC)
        self.view.addSubview(tableViewVC.view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        sliderView = HYSliderView(frame: NSRect(x: 0, y: self.playView.height()-5, width: self.playView.width(), height: 10))
        backgroundView.addSubview(sliderView!)
        
        sliderView?.mas_makeConstraints({ (make:MASConstraintMaker?) in
            make?.right.offset()(0)
            make?.left.offset()(0)
            make?.height.offset()(10)
        })
    }

}
