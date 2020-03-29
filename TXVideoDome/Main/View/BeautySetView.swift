//  点击美颜弹出的视图
//  BeautySetView.swift
//  TXVideoDome
//
//  Created by 98data on 2019/10/9.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit

class BeautySetView: UIView {
    let disView = UIButton(type: .custom)
    var beautyMainView = UIView()
    var pro: UIProgressView?
    var slider:UISlider?
    var closeBlock:(()->Void)?
    
    static func showBeauty(rootView:UIView,_ block:(()->Void)?) {
        
        let view = BeautySetView(frame: rootView.bounds)
        view.closeBlock = block
        rootView.addSubview(view)
        
    
    }
//    // 关闭视图
//    static func hideBeauty() {
//
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        self.disView.frame = self.bounds
        self.disView.addTarget(self, action: #selector(hide), for: .touchUpInside)
        self.addSubview(self.disView)
        
        
        self.beautyMainView.frame = CGRect(x: 0, y: self.frame.size.height , width: self.frame.size.width, height: 150)
//        self.beautyMainView.backgroundColor = UIColor.orange
        self.addSubview(self.beautyMainView)
        
//        self.pro = UIProgressView(frame: CGRect(x: 16, y: 50, width: self.beautyMainView.frame.width - 32, height: 8))
//        self.pro?.trackTintColor = UIColor.white
//        self.pro?.progressTintColor = UIColor.yellow
//        self.pro?.progress = 0.3
//        self.beautyMainView.addSubview(self.pro!)
        
        self.slider = UISlider(frame: CGRect(x: 16, y: 50, width: self.beautyMainView.frame.width - 32, height: 8))
        self.slider?.value = 0.3
        self.slider?.minimumTrackTintColor = UIColor.yellow
        self.slider?.maximumTrackTintColor = UIColor.white
        self.beautyMainView.addSubview(self.slider!)
        
        UIView.animate(withDuration: 0.35, animations: {
            self.beautyMainView.frame = CGRect(x: 0, y: self.frame.size.height - 150, width: self.frame.size.width, height: 150)
        }) { (isok) in
            
        }
    }
    /// 隐藏视图
    @objc func hide() {
        
        UIView.animate(withDuration: 0.35, animations: {
            self.beautyMainView.frame = CGRect(x: 0, y: self.frame.size.height , width: self.frame.size.width, height: 150)
        }) { (isok) in
            self.removeFromSuperview()
            if self.closeBlock != nil {
                self.closeBlock!()
            }
        }
    }
    
}
