//
//  GeneralObjects.swift
//  TXVideoDome
//
//  Created by 98data on 2019/12/13.
//  Copyright © 2019 98data. All rights reserved.
//

import Foundation

@_exported import Alamofire
@_exported import SwiftyJSON
@_exported import Kingfisher

class GeneralObjects {
    static var jsondic:[String:JSON]?
    
     func jsonValueToString(key:String) -> String {
            if GeneralObjects.jsondic == nil || GeneralObjects.jsondic![key]?.string == nil {
                return ""
            }

            return GeneralObjects.jsondic![key] == .null ? "" : (GeneralObjects.jsondic![key]?.string)!
        }
        func jsonValueToDouble(key:String) -> Double {
            if GeneralObjects.jsondic == nil {
                return 0.0
            }
            return GeneralObjects.jsondic![key] == .null ? 0 : (GeneralObjects.jsondic![key]?.doubleValue)!
        }
        
        
        func jsonValueToFloat(key:String) -> Float {
            if GeneralObjects.jsondic == nil {
                return 0
            }
            return GeneralObjects.jsondic![key] == .null ? 0 : (GeneralObjects.jsondic![key]?.floatValue)!
        }
           
        
        func jsonValueToInt(key:String) -> Int {
            
            if GeneralObjects.jsondic == nil {
                return 0
            }
            
            if GeneralObjects.jsondic![key] == nil{ return 0 }
            return GeneralObjects.jsondic![key] == .null ? 0 : (GeneralObjects.jsondic![key]?.intValue)!
        }
        func jsonValueToBool(key:String) -> Bool {
            if GeneralObjects.jsondic == nil {
                return false
            }
            let status = GeneralObjects.jsondic![key] == .null ? "" : GeneralObjects.jsondic![key]?.stringValue
            return NSString(string:status!).boolValue
        }
        
        /// 移除 json 的初始化
        func reMoveJsonInit() {
            GeneralObjects.jsondic = nil
        }
}
