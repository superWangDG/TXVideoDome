//
//  VideoRootViewController.swift
//  TXVideoDome
//
//  Created by 98data on 2019/12/12.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit
import SwiftyJSON


// 额外参数  集成项目后删除
func yyIsIPhoneX() -> Bool {
    return UIScreen.main.bounds.size.width >= 375.0 && UIScreen.main.bounds.size.height >= 812.0 && yyIsIPhone()
}

func yyIsIPhone5S() -> Bool {
    return UIScreen.main.bounds.size.width <= 320.0 && UIScreen.main.bounds.size.height <= 568.0 && yyIsIPhone()
}

func yyIsIPhone() -> Bool {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
}

let kNavBarHAbove7 = {return yyIsIPhoneX() ? CGFloat(88) : CGFloat(64) }()

class VideoRootViewController: UIViewController,UITableViewDelegate {
    
    var scrollView = UIScrollView()
    
    // 播放器
    //    var playManager:SJBaseVideoPlayer?
    var rootMainView = UIView()
    // 播放器
    var mPlayer : WMPlayer?
    
    var oneRootImageView:WGVideoController?
    var twoRootImageView:WGVideoController?
    var threeRootImageView:WGVideoController?
    // 创建轮播的 图片视图
    var imageVs = [WGVideoController]()
    // 当前显示的视图
    var currentPlayerIV = WGVideoController()
    var currentPlayerId = 0
    var currentIndex = 0
    
    // 页面索引
    var page = 1
    var index = 0
    
    // 索引
    var current = 0
    // 最后的位置
    var lastContenOffset:CGFloat = 0
    
    var endDraggingOffset:CGFloat = 0
    var requestUrl = true
    
    var scrollViewOffsetYOnStartDrag :CGFloat = 0
    var currentImageView = UIImageView()
    
    var datas = [VideoEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        
        
        //        self.view.addSubview(self.playManager!)
        self.loadData(keyword: "")
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        self.scrollView.bounces = false
        self.scrollView.scrollsToTop = false
        self.scrollView.backgroundColor = UIColor.clear
        
        let fooder = MJRefreshAutoNormalFooter {
            self.page = self.page + 1
            self.loadData(keyword: "")
        }
        fooder.setTitle("上拉加载更多信息", for: .idle)
        fooder.setTitle("没有更多信息了", for: .noMoreData)
        self.scrollView.mj_footer = fooder
        
        self.view.addSubview(self.scrollView)
        
        let height = self.view.height
        
        if yyIsIPhoneX() {
            //            height = height + kNavBarHAbove7
            self.scrollView.frame = CGRect(x: 0, y: -0, width: self.view.frame.width, height: self.view.frame.height + 0)
            self.automaticallyAdjustsScrollViewInsets = false
            self.extendedLayoutIncludesOpaqueBars = true
            self.edgesForExtendedLayout = .top
            
        }else {
            self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
        
        if #available(iOS 11.0, *) {
            // iOS 11后 将安全区去除
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.height * 3.0)
        
        self.oneRootImageView = WGVideoController(frame: CGRect(x: 0, y: 0, width: self.scrollView.width, height: height))
        self.twoRootImageView = WGVideoController(frame: CGRect(x: 0, y: self.scrollView.height, width: self.scrollView.width, height: height))
        self.threeRootImageView = WGVideoController(frame: CGRect(x: 0, y: self.scrollView.height * 2.0, width: self.scrollView.width, height: height))
        
        self.scrollView.addSubview(self.oneRootImageView!)
        self.scrollView.addSubview(self.twoRootImageView!)
        self.scrollView.addSubview(self.threeRootImageView!)
        
        
        let btnLeft = UIButton(type: .custom)
        btnLeft.setImage(UIImage(named:"ty_back"), for: .normal)
        btnLeft.frame = CGRect(x: 0, y: 37, width: 45, height: 45)
        btnLeft.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(btnLeft)
        btnLeft.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        
        if !yyIsIPhoneX() {
            btnLeft.top = 27
        }
        
        //        self.rootMainView.backgroundColor = UIColor.yellow
        //        self.rootMainView.frame = self.oneRootImageView!.bounds
        //        self.view.addSubview(self.rootMainView)
    }
    
    // MARK : - 初始化视频组件
    func setupPlayView() {
        
        if self.mPlayer != nil {
            self.mPlayer?.removeFromSuperview()
        }
        
        let wmPlayer = WMPlayer()
        //           self.rootMainView.addSubview(wmPlayer!)
        wmPlayer.frame = self.rootMainView.bounds
        //                   wmPlayer?.play()
        wmPlayer.loopPlay = true
        wmPlayer.backBtnStyle = .none
//        wmPlayer.playerLayerGravity = .resize
        self.mPlayer = wmPlayer
        //                   wmPlayer?.playerModel = pViewModel
        
        //        if self.playManager == nil {
        //            self.playManager = SJBaseVideoPlayer()
        //            // 显示 默认图片的时间
        //            self.playManager?.delayInSecondsForHiddenPlaceholderImageView = 0.3
        //            // 禁止旋转
        //            self.playManager?.rotationManager.isDisabledAutorotation = true
        //            // 手势控制
        //            //        self.playManager?.gestureControl.supportedGestureTypes
        //            // 是否禁用显示管理
        //            self.playManager?.controlLayerAppearManager.isDisabled = true
        //
        //            // 画面填充模式
        //            self.playManager?.videoGravity = .resizeAspectFill
        //            self.playManager?.view.backgroundColor = .clear
        //            self.playManager?.view.subviews.first?.backgroundColor = .clear
        //            // 播放控制改变的回调
        //            self.playManager?.playbackObserver.timeControlStatusDidChangeExeBlock = {
        //                player in
        //                print("播放控制改变的回调")
        //                self.changeVideoStatus()
        //            }
        //            // 资源状态改变回调
        //            self.playManager?.playbackObserver.assetStatusDidChangeExeBlock = {
        //                player in
        //                print("资源状态改变回调")
        //                self.changeVideoStatus()
        //            }
        //        }
        
        
        // 播放画面的显示层 默认图片
        //        self.playManager?.presentView.placeholderImageView.kf.setImage(with: URL(string: ""))
        // 设置显示的视频资源
        //        self.playManager?.urlAsset = SJVideoPlayerURLAsset(url: URL(string: ""))
    }
    
    // MARK:- UIScrollView
    /// 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContenOffset = scrollView.contentOffset.y
        self.scrollViewOffsetYOnStartDrag = scrollView.contentOffset.y
    }
    
    /// 结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.endDraggingOffset = scrollView.contentOffset.y
        if decelerate == false {
            self.scrollViewDidEndScrolling()
        }
    }
    
    /// 开始减速
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //        scrollView.isScrollEnabled = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.currentIndex == 0 && scrollView.contentOffset.y < 0 {
            self.scrollView.contentOffset = CGPoint.zero
        }
        
        //        scrollView.isScrollEnabled = true
        if self.datas.count <= 3 {
            //            print("第一个拦截")
            return
        }
        
        // 回到第一个
        if self.index == 0 && scrollView.contentOffset.y <= self.scrollView.height {
            //            print("第二个拦截")
            return
        }
        
        // 抵达最后一个
        if (self.index > 0) && (self.index == self.datas.count - 1) && (scrollView.contentOffset.y > self.scrollView.height) {
            //            print("第三个拦截")
            return
        }
        
        //        print("当前索引:\(self.currentIndex)")
        // 判断是从中间视图上滑还是下滑
        if scrollView.contentOffset.y >= 2 * self.scrollView.height {
            print("上滑的状态")
            // 上滑
            // 移除 播放器
            if self.index == 0 {
                print("上滑的状态 index==0")
                self.index = self.index + 2
                scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.height) //  跳转到第二页
                // 将中间的 视图的模块 赋值到顶部
                self.oneRootImageView?.entity = self.twoRootImageView?.entity
                // 将底部的 视图模块 赋值到中间
                self.twoRootImageView?.entity = self.threeRootImageView?.entity
            } else {
                print("上滑的状态 index！=0")
                self.index = self.index + 1
                
                if self.index == self.datas.count - 1 {
                    // 设置中间部分的参数 （得到当前的数据参数）
                    self.twoRootImageView?.entity = self.datas[self.index - 1]
                }else {
                    scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.height)
                    // 将中间的 视图的模块 赋值到顶部
                    self.oneRootImageView?.entity = self.twoRootImageView?.entity
                    // 将底部的 视图模块 赋值到中间
                    self.twoRootImageView?.entity = self.threeRootImageView?.entity
                }
            }
            
            if self.index < self.datas.count - 1 && self.datas.count >= 3 {
                // 设置底部的视图 参数
                self.threeRootImageView?.entity = self.datas[self.index + 1]
            }
        } else if scrollView.contentOffset.y <= 0 {
            // 下滑
            // 移除 播放器
            if self.index == 1 {
                // 赋值 视图参数
                // 顶部视图 当前参数 - 1
                self.oneRootImageView?.entity = self.datas[self.index - 1]
                // 中间部分 当前参数
                self.twoRootImageView?.entity = self.datas[self.index]
                // 底部部分 当前参数 + 1
                self.threeRootImageView?.entity = self.datas[self.index + 1]
                // 参数索引 - 1
                self.index = self.index - 1
            } else {
                if self.index == self.datas.count - 1 {
                    self.index = self.index - 2
                } else {
                    self.index = self.index - 1
                }
                
                scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.height)
                
                // 将中间的 视图的模块 赋值到底部
                self.threeRootImageView?.entity = self.twoRootImageView?.entity
                // 将顶部的 视图模块 赋值到中间
                self.twoRootImageView?.entity = self.oneRootImageView?.entity
                if self.index > 0 {
                    // 获取顶部视图
                    self.oneRootImageView?.entity = self.datas[self.index - 1]
                }
            }
        }
        // 判断  是否 是 push 进入的页面如果是 push 进入的页面则 直接返回
        
        // 自动刷新功能
        if scrollView.contentOffset.y == self.scrollView.height {
            // 播放到 倒数第二个视频时 加载更多 视频
            if self.currentIndex == self.datas.count - 3 {
                // 加载
                print("触发第一个")
                self.page = self.page + 1
                self.loadData(keyword: "")
            }
        }
        
        // 最后一条显示位置 刷新数据
        if scrollView.contentOffset.y == self.scrollView.height * 2.0 {
            
            print("触发第二个")
            self.page = self.page + 1
            self.loadData(keyword: "")
        }
        //        print("当前索引:\(self.index)")
        
    }
    
    /// 结束减速 后播放视频
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            if self.currentPlayerId == self.oneRootImageView?.entity?.v_id {
                return
            }
            self.playVideo(palyView: self.oneRootImageView!)
            
        } else if scrollView.contentOffset.y == self.scrollView.height {
            
            if self.currentPlayerId == self.twoRootImageView?.entity?.v_id {
                return
            }
            self.playVideo(palyView: self.twoRootImageView!)
            
        } else if scrollView.contentOffset.y == self.scrollView.height * 2.0 {
            //            print("播放第三个视频")
            if self.currentPlayerId == self.threeRootImageView?.entity?.v_id {
                return
            }
            self.playVideo(palyView: self.threeRootImageView!)
        }
    }
    
    func scrollViewDidEndScrolling() {
        if self.scrollViewOffsetYOnStartDrag == self.scrollView.contentOffset.y && self.endDraggingOffset != self.scrollViewOffsetYOnStartDrag {
            return
        }
        //        self.changeRoom()
        
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension VideoRootViewController {
    func loadData(keyword:String) {
        
        let userKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IjE1NzYxNjY0MTY1IiwicGFzc3dvcmQiOm51bGwsImV4cCI6MTU3NzY2ODU5MS4wfQ.BdoMPpnTzG7pAXYX5BUEQd52XiiEmKocB4VoftE8NDA"
        let parame = ["page":self.page,"pageSize":"4","userKey":userKey,"authorId":"","all":"0","keyword":keyword] as [String:Any]
        
        let uVideo_List = "https://api2.98csj.cn:8082/post/list"
        
        print("当前页面:\(self.page)")
        
        PlanHttpRequest.wRequest(url: uVideo_List, parameter: parame) { (error, value) in
            if error.isEmpty {
                // 总数 与 数据区分
                let json = (value as! JSON)
                let jsonArray = json.dictionaryValue["Item2"]!
                
                if jsonArray.arrayValue.count > 0 {
                    //                    // 得到新数据
                    let videos = VideoEntity.initJsonArrayWithEntitys(jsonData: json.dictionaryValue["Item2"]!)
                    self.datas.append(contentsOf: videos)
                    self.setVideos(videos: self.datas, index: self.index)
                    
                    if self.scrollView.contentOffset.y > self.scrollView.height * 2.0 {
                        self.scrollView.contentOffset = CGPoint(x: 0, y: 2.0 * self.scrollView.height)
                    }
                    
                }else {
                    
                }
                
            }else {
            }
        }
    }
    
    func setVideos(videos:[VideoEntity],index : Int) {
        if self.datas.count == 0 { return }
        
        self.currentIndex = index
        self.index = index
        
        if self.datas.count == 1 {
            // 只存在一条数据的时候
            self.twoRootImageView?.removeFromSuperview()
            self.threeRootImageView?.removeFromSuperview()
            
            self.scrollView.contentSize = CGSize(width: 0, height: self.scrollView.height)
            
            self.oneRootImageView?.isHidden = false
            self.oneRootImageView?.entity = self.datas.first!
            // 播放第一条视频
            self.playVideo(palyView: self.oneRootImageView!)
        } else if self.datas.count == 2 {
            // 2条数据的时候
            self.threeRootImageView?.removeFromSuperview()
            
            self.scrollView.contentSize = CGSize(width: 0, height: self.scrollView.height * 2.0)
            
            self.oneRootImageView?.isHidden = false
            self.twoRootImageView?.isHidden = false
            
            self.oneRootImageView?.entity = self.datas.first!
            self.twoRootImageView?.entity = self.datas.last!
            
            if index == 1 {
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.height)
                // 播放中间的视频
                self.playVideo(palyView: self.twoRootImageView!)
            } else {
                // 播放顶部视频
                self.playVideo(palyView: self.oneRootImageView!)
            }
            
        } else {
            // 大于三条数据
            self.oneRootImageView?.isHidden = false
            self.twoRootImageView?.isHidden = false
            self.threeRootImageView?.isHidden = false
            
            if index == 0 {
                self.oneRootImageView?.entity = self.datas[index]
                self.twoRootImageView?.entity = self.datas[index + 1]
                self.threeRootImageView?.entity = self.datas[index + 2]
                // 播放第一个视频
                self.playVideo(palyView: self.oneRootImageView!)
            } else if index == self.datas.count - 1 {
                
                self.threeRootImageView?.entity = self.datas[index]
                self.twoRootImageView?.entity = self.datas[index - 1]
                self.oneRootImageView?.entity = self.datas[index - 2]
                
                // 显示最后一个
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.height * 2.0)
                
                // 播放最后一个视频
                self.playVideo(palyView: self.threeRootImageView!)
            } else {
                // 显示中间的视频 预加载 其他视频
                self.twoRootImageView?.entity = self.datas[index]
                self.oneRootImageView?.entity = self.datas[index - 1]
                self.threeRootImageView?.entity = self.datas[index + 1]
                
                // 显示中间的视图
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.height)
                
                // 播放中间的视图
                self.playVideo(palyView: self.twoRootImageView!)
            }
        }
    }
    
    func playVideo(palyView:WGVideoController) {
        
//        let test = PlanHttpRequest().urlWithToFileName(url: palyView.entity!.file_url)
        
        self.currentPlayerId = palyView.entity!.v_id
        self.currentPlayerIV = palyView
        
        self.currentIndex = self.indexOfEntity(entity: palyView.entity!)
        
//        print("当前显示的ID:\(self.currentPlayerId)")
//        print("当前显示\(self.currentIndex)")
//
        self.setupPlayView()
        
        if palyView.entity != nil {
            
//            print("开始播放")
            let path = palyView.entity!.file_url
            
            var pViewModel = WMPlayerModel()
            
            if self.mPlayer != nil {
                
                if palyView.entity?.playerItem == nil {
                    pViewModel.videoURL = URL(string:path)
                }else {
                    self.mPlayer?.resetWMPlayer()
                    pViewModel = palyView.entity!.playerItem!
                }
                // 设置封面
//                palyView.mainImageView.image = UIImage(named:"")
//                self.mPlayer?.imgCover.kf.setImage(with: URL(string:palyView.entity!.cover))
                self.mPlayer?.playerModel = pViewModel
                self.mPlayer?.frame = palyView.mainImageView.bounds
                palyView.mainImageView.insertSubview(self.mPlayer!, at: 0)
                self.mPlayer?.play()
                
                // 当视频完成了缓冲后得到 本地的 文件 进行存储 回放时不会 重新 缓冲
                self.mPlayer?.cacheDoneBlock = {
                    currentUrl,currentItem in
                    let entity = self.datas[self.currentIndex]
                    if entity.playerItem == nil && currentUrl == entity.file_url {
                        entity.playerItem = currentItem
                        self.datas[self.currentIndex] = entity
                    }
                }
            }
        }
    }
    
    // 获取当前显示内容的索引
    func indexOfEntity(entity:VideoEntity) -> Int {
        var current = 0
        for i in 0 ..< self.datas.count {
            let data = self.datas[i]
            //            print("获取索引:\(i)")
            if data.v_id == entity.v_id {
                current = i
                return current
            }
        }
        return 0
    }
    
    func changeVideoStatus() {
        
        
    }
    
}
