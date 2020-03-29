//  视频播放视图
//  WGVideoView.swift
//  TXVideoDome
//
//  Created by 98data on 2019/12/12.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit

class WGVideoView: UIView {
    
    // 回调方法
    var didClickAvater : ((_ videoView:WGVideoView,_ info:VideoEntity)->Void)?
    var didClickLike : ((_ videoView:WGVideoView,_ info:VideoEntity)->Void)?
    var didClickComment : ((_ videoView:WGVideoView,_ info:VideoEntity)->Void)?
    var didClickShare : ((_ videoView:WGVideoView,_ info:VideoEntity)->Void)?
    var didClickFollew : ((_ videoView:WGVideoView,_ info:VideoEntity)->Void)?
    
    // 数据源
    var videos = [VideoEntity]()
    
    // 当前播放内容的索引
    var currentPlayIndex = 0
    // 控制播放的索引，不完全等于当前播放内容的索引
    var index = 0
    // 是否push 当前页面
    var isPushed = false
    // 记录滑动前的播放状态
    var isPlaying_beforeScroll = false
    // 是否在刷新状态
    var isRefreshMore = false
    // 交流沟通
    var interacting = false
    // 记录播放内容
    var currentPlayId = ""
    
    var vc:UIViewController?
    var scrollView:UIScrollView?
    
    // 开始移动时的位置
    var startLocationY:Float = 0.0
    var startLocation = CGPoint.zero
    var startFrame = CGRect.zero
    
    var topView:WGVideoController?  // 顶部
    var ctrView:WGVideoController?  // 中部
    var btmView:WGVideoController?  // 底部
    
    // 创建方式
    static func initWithCreate(vc:UIViewController,isPushed:Bool) -> WGVideoView {
        let view = WGVideoView()
        view.vc = vc
        view.isPushed = isPushed
        
        view.createUI(videoView: view)
        
        return view
    }
    

    
}

extension WGVideoView {

    func createUI(videoView:WGVideoView) {
        self.scrollView = UIScrollView()
        self.addSubview(self.scrollView!)
        
        self.scrollView?.mas_makeConstraints({ (make) in
            make!.edges.equalTo()
        })
        
        if !self.isPushed {
            
        } else {
            
        }
    }
    
    // 暂停
    func pause() {
        
    }
    
    // 继续播放
    func resume() {
        
    }
    
    // 回收播放
    func destoryPlayer() {
        
    }
}




