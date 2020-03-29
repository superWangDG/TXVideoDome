//
//  WGVideoPlayerViewController.swift
//  TXVideoDome
//
//  Created by 98data on 2019/12/12.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit

class WGVideoPlayerViewController: UIViewController {

    weak var delegate : WGVideoPlayerDelegate?
    
    var videoView:WGVideoView?
    
    // 组件视图
    var backBtn = UIButton(type : .custom)
    
    var infoModel = VideoEntity()
    var infoModels = [VideoEntity]()
    var playIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.videoView!)
    }
    
    // 播放单个视频
    init(videoModel : VideoEntity) {
        super.init(nibName: nil, bundle: nil)
        self.infoModel = videoModel
    }
    
    // 播放一组视频，并指定播放位置
    init(videos : [VideoEntity],index : Int) {
        super.init(nibName: nil, bundle: nil)
        self.infoModels = videos
        self.playIndex = index
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension WGVideoPlayerViewController {
    
}

protocol WGVideoPlayerDelegate : NSObjectProtocol {
    
    func playerVCDidClickShoot(_ vc:WGVideoPlayerViewController)
    
    func playerVC(_ vc:WGVideoPlayerViewController,_ controllerView:VideoSrcListViewController,_ isCritical:Bool)
    
}
