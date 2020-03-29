//
//  RecordingViewController.swift
//  TXVideoDome
//
//  Created by 98data on 2019/9/29.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController,TXUGCRecordListener {

    // 显示的视图
    let showRecordingView = UIView()
    
    // 工具主视图
    let toolsMainView = UIView()
    // 关闭按钮
    let btnClose = UIButton(type: .custom)
    // 相机摄像头按钮
    let btnCameralens = UIButton(type: .custom)
    // 美化按钮
    let btnBeautify = UIButton(type: .custom)
    // 变声按钮
    let btnChangevoice = UIButton(type: .custom)
    // 闪光灯按钮
    let btnFlashlamp = UIButton(type: .custom)
    
    // 录制按钮
    let btnStart = UIButton(type: .custom)
    // 本地视频
    let btnLocaImages = UIButton(type: .custom)
    // 存在录制视频的主视图
    let editVideoMainView = UIView()
    // 删除一节视频
    let btnDelVideo = UIButton(type: .custom)
    // 完成视频按钮
    let btnDoneVideo = UIButton(type: .custom)
    
    // 参数设置
    var isCameraFront = true   // 初始使用前置摄像头
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRecordUI()
        
        self.setupToolsUI()
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        print("回收了资源")
    }
    
}

extension RecordingViewController {
    /// 加载工具视图
    func setupToolsUI() {
        
        
        self.toolsMainView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(self.toolsMainView)
        
        self.btnClose.frame = CGRect(x: 16, y: 40, width: 45, height: 45)
        self.btnClose.addTarget(self, action: #selector(colseAction), for: .touchUpInside)
        self.btnClose.setImage(UIImage(named:"close_logo"), for: .normal)
        self.toolsMainView.addSubview(self.btnClose)
        
        let right =  self.view.frame.width - 45 - 16
        
        self.btnCameralens.frame = CGRect(x: right, y: self.btnClose.frame.origin.y, width: 45, height: 45)
        self.btnCameralens.setImage(UIImage(named:"camera_lens_logo"), for: .normal)
        self.btnCameralens.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        self.toolsMainView.addSubview(self.btnCameralens)
        let labCameralens = UILabel(frame: CGRect(x: 0, y: self.btnCameralens.height / 2.0 + 12, width: self.btnCameralens.width, height: 15))
        labCameralens.textColor = UIColor.white
        labCameralens.text = "摄像头"
        labCameralens.font = UIFont.systemFont(ofSize: 13)
        labCameralens.textAlignment = .center
        self.btnCameralens.addSubview(labCameralens)
        
        self.btnBeautify.frame = self.btnCameralens.frame
        self.btnBeautify.top = self.btnCameralens.bottom + 16
        self.btnBeautify.setImage(UIImage(named:"beautify_logo"), for: .normal)
        self.btnBeautify.imageEdgeInsets = self.btnCameralens.imageEdgeInsets
        self.toolsMainView.addSubview(self.btnBeautify)
        let labBeautify = UILabel(frame: labCameralens.frame)
        labBeautify.textColor = UIColor.white
        labBeautify.text = "美颜"
        labBeautify.font = UIFont.systemFont(ofSize: 13)
        labBeautify.textAlignment = .center
        self.btnBeautify.addSubview(labBeautify)
        
        self.btnChangevoice.frame = self.btnCameralens.frame
        self.btnChangevoice.top = self.btnBeautify.bottom + 16
        self.btnChangevoice.setImage(UIImage(named:"change_voice_logo"), for: .normal)
        self.btnChangevoice.imageEdgeInsets = self.btnCameralens.imageEdgeInsets
        self.toolsMainView.addSubview(self.btnChangevoice)
        let labChangevoice = UILabel(frame: labCameralens.frame)
        labChangevoice.textColor = UIColor.white
        labChangevoice.text = "变声"
        labChangevoice.font = UIFont.systemFont(ofSize: 13)
        labChangevoice.textAlignment = .center
        self.btnChangevoice.addSubview(labChangevoice)
        
        self.btnFlashlamp.frame = self.btnCameralens.frame
        self.btnFlashlamp.top = self.btnChangevoice.bottom + 16
        self.btnFlashlamp.setImage(UIImage(named:"flash_lamp_close"), for: .normal)
        self.btnFlashlamp.setImage(UIImage(named:"flash_lamp_open"), for: .selected)
        self.btnFlashlamp.imageEdgeInsets = self.btnCameralens.imageEdgeInsets
        self.toolsMainView.addSubview(self.btnFlashlamp)
        let labFlashlamp = UILabel(frame: labCameralens.frame)
        labFlashlamp.textColor = UIColor.white
        labFlashlamp.text = "闪光灯"
        labFlashlamp.font = UIFont.systemFont(ofSize: 13)
        labFlashlamp.textAlignment = .center
        self.btnFlashlamp.addSubview(labFlashlamp)
        
        
        self.btnStart.frame = CGRect(x: self.view.width / 2.0 - 50, y: self.view.height - 140, width: 100, height: 100)
        self.btnStart.layer.borderColor = UIColor.white.cgColor
        self.btnStart.layer.borderWidth = 8
        self.btnStart.layer.cornerRadius = 50
        self.btnStart.layer.masksToBounds = true
        self.toolsMainView.addSubview(self.btnStart)
        let startBGView = UIView()
        startBGView.backgroundColor = UIColor.white
        startBGView.frame = CGRect(x: 12, y: 12, width: 76, height: 76)
        startBGView.layer.cornerRadius = 76/2.0
        startBGView.layer.masksToBounds = true
        self.btnStart.addSubview(startBGView)
       
        self.editVideoMainView.frame = CGRect(x: self.btnStart.right + 12, y: self.btnStart.top + 25, width: 110, height: 50)
        
        self.view.addSubview(self.editVideoMainView)
        self.btnDelVideo.frame = CGRect(x: 0, y: 0, width: self.editVideoMainView.height, height: self.editVideoMainView.height)
        self.btnDelVideo.setImage(UIImage(named:"video_del_logo"), for: .normal)
        self.editVideoMainView.addSubview(self.btnDelVideo)
        
        self.btnDoneVideo.frame = self.btnDelVideo.frame
        self.btnDoneVideo.right = self.editVideoMainView.width
        self.btnDoneVideo.setImage(UIImage(named:"video_done_logo"), for: .normal)
        self.editVideoMainView.addSubview(self.btnDoneVideo)
        
        self.btnLocaImages.frame = CGRect(x: self.editVideoMainView.left, y: self.editVideoMainView.top, width: self.editVideoMainView.height, height: self.editVideoMainView.height)
        self.btnLocaImages.setImage(UIImage(named:"video_open_logo"), for: .normal)
        self.btnLocaImages.imageEdgeInsets = self.btnCameralens.imageEdgeInsets
        self.toolsMainView.addSubview(self.btnLocaImages)
        let labLocaImages = UILabel(frame: labCameralens.frame)
        labLocaImages.top += 4
        labLocaImages.left += 1
        labLocaImages.textColor = UIColor.white
        labLocaImages.text = "上传"
        labLocaImages.font = UIFont.systemFont(ofSize: 13)
        labLocaImages.textAlignment = .center
        self.btnLocaImages.addSubview(labLocaImages)
        
//        self.btnLocaImages.isHidden = true
        self.editVideoMainView.isHidden = true
        
        // 添加事件
        self.btnDoneVideo.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        self.btnDelVideo.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        self.btnLocaImages.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        self.btnStart.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        self.btnCameralens.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        self.btnBeautify.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        self.btnChangevoice.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        self.btnFlashlamp.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
    
        // 隐藏闪光灯
        self.showFlashlamp(isShow: false)
        
    }
    
    
    func setupRecordUI() {
        self.showRecordingView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
        self.view.addSubview(self.showRecordingView)
        
        let config = TXUGCSimpleConfig()
        // 视频质量
        config.videoQuality = .VIDEO_QUALITY_HIGH
        config.minDuration = 3
        config.maxDuration = 120
        // 添加预览视图
        TXUGCRecord.shareInstance()?.startCameraSimple(config, preview: self.showRecordingView)
        // 录制回调设置
//        TXUGCRecord.shareInstance()?.recordDelegate = self
        // 摄像头设置
        TXUGCRecord.shareInstance()?.switchCamera(self.isCameraFront)
    }
    
    // MARK:- Actions
    @objc func colseAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonActions(button:UIButton ) {
        if button == self.btnStart {
            // 开始录制
            
        }else if button == self.btnDoneVideo {
            // 完成下一步
            
        }else if button == self.btnDelVideo {
            // 删除视频
            
        }else if button == self.btnLocaImages {
            // 打开本地视频
            
        }else if button == self.btnCameralens {
            // 翻转摄像头
            self.isCameraFront = !self.isCameraFront
            TXUGCRecord.shareInstance()?.switchCamera(self.isCameraFront)
            self.showFlashlamp(isShow: !self.isCameraFront)
            
        }else if button == self.btnBeautify {
            // 打开美颜
            print("显示了美颜视图")
            self.toolsMainView.isHidden = true
            
            BeautySetView.showBeauty(rootView: self.view) {
                // 隐藏后的回调
                self.toolsMainView.isHidden = false
                print("关闭视图")
            }
            
        }else if button == self.btnChangevoice {
            // 打开变声
            
        }else if button == self.btnFlashlamp {
            // 打开闪光灯
            self.btnFlashlamp.isSelected = !self.btnFlashlamp.isSelected
            
            TXUGCRecord.shareInstance()?.toggleTorch(self.btnFlashlamp.isSelected)
        }
    }
    
    /// 显示闪光灯的Logo
    func showFlashlamp(isShow:Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            if isShow {
                self.btnFlashlamp.top = self.btnChangevoice.bottom + 16
            }else {
                self.btnFlashlamp.top = self.btnChangevoice.top
                self.btnFlashlamp.isSelected = false
            }
        }) { (isOK) in
            self.btnFlashlamp.isHidden = !isShow
        }
    }
    
    // MARK:- RecordDelegate 录制回调
    func onRecordProgress(_ milliSecond: Int) {
        // 录制进度
        print("录制进度:\(milliSecond)")
    }
    
    func onRecordComplete(_ result: TXUGCRecordResult!) {
        // 录制成功
        print("录制结果:\(result.retCode)")
    }
}

