//
//  VideoEntity.swift
//  TRCarData
//
//  Created by 98data on 2019/9/4.
//  Copyright © 2019 王德贵. All rights reserved.
//

import Foundation
import SwiftyJSON

class VideoEntity : NSObject {
    var v_id = 0
    var user_id = 0
    var isLike = 0  
    var isFollow = 0
    var comment_count = 0
    var like_count = 0
    var share_count = 0
    var width = 0
    var height = 0
    var status = 0
    
    var cover = ""
    var file_url = ""
    var detail = ""
    var share_url = ""
    var addtime = ""

    // 临时添加的本地播放文件
    var playerItem : WMPlayerModel?
    
    var userInfo : UserInfoEntity?
    
    static func initJsonArrayWithEntitys(jsonData:JSON) -> Array<VideoEntity> {
        var array = Array<VideoEntity>()
        for obj in jsonData.arrayValue {
            let entity = self.initJsonWithEntity(jsonData: obj)
            array.append(entity)
        }
        return array
    }
    
    
    static func initJsonWithEntity(jsonData:JSON) -> VideoEntity {
        GeneralObjects.jsondic = jsonData.dictionaryValue
        let entity = VideoEntity()
        
        entity.v_id = GeneralObjects().jsonValueToInt(key: "id")
        entity.user_id = GeneralObjects().jsonValueToInt(key: "user_id")
        entity.isLike = GeneralObjects().jsonValueToInt(key: "isLike")
        entity.isFollow = GeneralObjects().jsonValueToInt(key: "isFollow")
        entity.comment_count = GeneralObjects().jsonValueToInt(key: "comment_count")
        entity.like_count = GeneralObjects().jsonValueToInt(key: "like_count")
        entity.share_count = GeneralObjects().jsonValueToInt(key: "share_count")
        entity.width = GeneralObjects().jsonValueToInt(key: "width")
        entity.height = GeneralObjects().jsonValueToInt(key: "height")
        
        entity.status = GeneralObjects().jsonValueToInt(key: "status")
        

        entity.cover = GeneralObjects().jsonValueToString(key: "cover")
        entity.file_url = GeneralObjects().jsonValueToString(key: "file_url")
        entity.detail = GeneralObjects().jsonValueToString(key: "detail")
        entity.share_url = GeneralObjects().jsonValueToString(key: "share_url")
        entity.addtime = GeneralObjects().jsonValueToString(key: "addtime")

        if jsonData.dictionaryValue["user"] != nil {
            entity.userInfo = UserInfoEntity.initJsonWithEntity(jsonData: jsonData.dictionaryValue["user"]!)
        }
        return entity
    }
}
