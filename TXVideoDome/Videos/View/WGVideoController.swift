//  显示的视图
//  WGVideoController.swift
//  TXVideoDome
//
//  Created by 98data on 2019/12/12.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit

class WGVideoController: UIView {

    // 回调方法
    var didClickAvater : ((_ videoView:WGVideoController,_ info:VideoEntity)->Void)?
    var didClickLike : ((_ videoView:WGVideoController,_ info:VideoEntity)->Void)?
    var didClickComment : ((_ videoView:WGVideoController,_ info:VideoEntity)->Void)?
    var didClickShare : ((_ videoView:WGVideoController,_ info:VideoEntity)->Void)?
    var didClickFollew : ((_ videoView:WGVideoController,_ info:VideoEntity)->Void)?
    
    var mainImageView = UIImageView()
    var imgAvater = UIImageView()
    
    var btnAvater = UIButton(type: .custom)
    var btnFollow = UIButton(type: .custom)
    
    var btnLike = UIButton(type: .custom)
    var btnComment = UIButton(type: .custom)
    var btnShare = UIButton(type: .custom)
    
    var mLabLike = UILabel()
    var mLabComment = UILabel()
    
    var labContent = UILabel()
    
    var entity : VideoEntity? {
        didSet {
            // 开始设置参数
            self.mLabLike.text = "\(self.entity!.like_count)"
            self.mLabComment.text = "\(self.entity!.comment_count)"
            
            self.btnFollow.isSelected = self.entity!.isFollow == 0 ? false : true
            
            self.imgAvater.kf.setImage(with: URL(string:self.entity!.userInfo!.avatar))
            
            var userNick = self.entity!.userInfo!.nick_name
            if userNick == "" {
                // 隐藏部分
                userNick = self.entity!.userInfo!.username.stringWithEncryption()
            }
            self.btnAvater.setTitle(userNick, for: .normal)
            
            let asContent = NSMutableAttributedString(string: self.entity!.detail)
            asContent.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: asContent.length))
            asContent.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: asContent.length))
            self.labContent.attributedText = asContent
            
            let url = URL(string:self.entity!.cover)
            
            self.mainImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: { (cur, sum) in
                
            }) { (image, error, type, url) in
                
            }
        }
    }
    
    fileprivate var mFrame = CGRect.zero
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.mFrame = frame
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.mainImageView.frame = CGRect(x: 0, y: 0, width: self.mFrame.size.width, height: self.mFrame.size.height)
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.isUserInteractionEnabled = true
//        self.mainImageView.backgroundColor = UIColor.lightGray
        self.mainImageView.clipsToBounds = true
        self.addSubview(self.mainImageView)
        
        self.btnAvater.frame = CGRect(x: 50, y: 50, width: 200, height: 40)
        self.btnAvater.titleEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        self.btnAvater.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.btnAvater.contentHorizontalAlignment = .left
        self.addSubview(self.btnAvater)
        
        self.imgAvater.frame = CGRect(x: 0, y: 6, width: 28, height: 28)
        self.imgAvater.layer.cornerRadius = 14
        self.imgAvater.layer.masksToBounds = true
        self.imgAvater.layer.borderColor = UIColor.white.cgColor
        self.imgAvater.layer.borderWidth = 1
        self.btnAvater.addSubview(self.imgAvater)
        
        self.btnFollow.frame = CGRect(x: self.mFrame.size.width - 96, y: self.btnAvater.top, width: 80, height: 30)
        self.btnFollow.setTitle("关注", for: .normal)
        self.btnFollow.setTitle("已关注", for: .selected)
        self.btnFollow.layer.cornerRadius = 15
        self.btnFollow.layer.masksToBounds = true
        self.btnFollow.layer.borderColor = UIColor.white.cgColor
        self.btnFollow.layer.borderWidth = 1
        self.btnFollow.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.mainImageView.addSubview(self.btnFollow)
        
        self.btnShare.frame = CGRect(x: self.mFrame.size.width - 70, y: self.mFrame.size.height - 220, width: 70, height: 70)
        self.btnShare.setImage(UIImage(named:"video_share_w_logo"), for: .normal)
        self.btnShare.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.mainImageView.addSubview(self.btnShare)
        
        self.btnComment.frame = self.btnShare.frame
        self.btnComment.bottom = self.btnShare.top - 16
        self.btnComment.setImage(UIImage(named:"video_comment_w_logo"), for: .normal)
        self.btnComment.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.mainImageView.addSubview(self.btnComment)
        
        self.btnLike.frame = self.btnShare.frame
        self.btnLike.bottom = self.btnComment.top - 16
        self.btnLike.setImage(UIImage(named:"video_like_nor_logo"), for: .normal)
        self.btnLike.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.mainImageView.addSubview(self.btnLike)
        
        let labShare = UILabel(frame: CGRect(x: 0, y: self.btnShare.height - 30, width: self.btnShare.width, height: 30))
        labShare.text = "分享"
        labShare.font = UIFont.systemFont(ofSize: 12.0)
        labShare.textColor = UIColor.white
        labShare.textAlignment = .center
        self.btnShare.addSubview(labShare)
    
        let labLike = UILabel(frame: labShare.frame)
        labLike.text = "0"
        labShare.font = UIFont.systemFont(ofSize: 12.0)
        labLike.textColor = UIColor.white
        labLike.textAlignment = .center
        self.btnLike.addSubview(labLike)
    
        let labComment = UILabel(frame: labShare.frame)
        labComment.text = "0"
        labComment.font = UIFont.systemFont(ofSize: 12.0)
        labComment.textColor = UIColor.white
        labComment.textAlignment = .center
        self.btnComment.addSubview(labComment)
        
        self.labContent.frame = CGRect(x: 16, y: self.mFrame.height - 70, width: self.mFrame.width - 32, height: 20)
        self.labContent.numberOfLines = 0
        self.mainImageView.addSubview(self.labContent)
        
        self.mLabLike = labLike
        self.mLabComment = labComment
        
        self.btnAvater.addTarget(self, action: #selector(avaterAction), for: .touchUpInside)
        self.btnLike.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        self.btnComment.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        self.btnShare.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        self.btnFollow.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        
    }
    
    override func layoutSubviews() {
        if yyIsIPhoneX() {
            self.btnAvater.top = 40
//            self.btnFollow.top = self.btnAvater.top
            
            
            self.btnShare.bottom = self.mFrame.size.height - 180
           self.btnComment.bottom = self.btnShare.top - 16
           self.btnLike.bottom = self.btnComment.top - 16
        }else {
            self.btnAvater.top = 30
            self.btnFollow.center.y = self.btnAvater.center.y
        }
        
       
    }
    
    @objc func likeAction() {
        
    }
    @objc func commentAction() {
        
    }
    @objc func shareAction() {
        
    }
    @objc func followAction() {
        
    }
    @objc func avaterAction() {
        
    }
    
}
