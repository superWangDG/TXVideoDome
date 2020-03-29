
//
//  WGVideoViewModel.swift
//  TXVideoDome
//
//  Created by 98data on 2019/12/12.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit

class WGVideoViewModel: UIView {

//    var successBlock:((_ values:[VideoInfo])->Void)?
//
//    var failureBlock:((_ error:NSError)->Void)?
    
    var page = 1
    
    var has_more = false
    
    func refreshNewList(success:((_ values:[VideoEntity])->Void),failure:((_ error:NSError)->Void)) {
        // 获得 初始数据
        
    }
    
    func refreshMoreList(success:((_ values:[VideoEntity])->Void),failure:((_ error:NSError)->Void)) {
        // 加载更多数据
        self.page = self.page + 1
    }
    
    
    
    

}
