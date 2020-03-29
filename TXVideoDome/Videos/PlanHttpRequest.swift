//
//  PlanHttpRequest.swift
//  TRCarData
//
//  Created by 王德贵 on 2019/1/10.
//  Copyright © 2019 王德贵. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias httpBlock = (_ error : String,_ obj :Any?) -> Void

let sharedSessionManager: Alamofire.SessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    return Alamofire.SessionManager(configuration: configuration)
}()

class PlanHttpRequest {
    
    // 是否需要判断 Code 的状态
    //    static var isJudgeCode = false
    
    /// 网络请求
    static func wRequest(url:String,parameter:Parameters? ,block:@escaping httpBlock) {
        //        https://api2.98csj.cn:8082/post/like?id=307&userKey=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IjE1NzYxNjY0MTY1IiwicGFzc3dvcmQiOm51bGwsImV4cCI6MTU3NjYzOTY1MC4wfQ.XIPdMMG523cgj-7FeIha-qJHxrzYTUwufYx4TSLhuhY
        self.wRequest(url: url, false, parameter: parameter, block: block)
    }
    
    static func wRequest(url:String,_ isJudgeCode:Bool,parameter:Parameters? ,block:@escaping httpBlock) {
        sharedSessionManager.request(url, method: HTTPMethod.get, parameters: parameter, encoding:  URLEncoding.default, headers: nil).responseData { (response) in
            
            let url = response.request?.url?.absoluteString
            //            https://api2.98csj.cn:8082/user/info/?&userKey=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IjE1NzYxNjY0MTY1IiwicGFzc3dvcmQiOm51bGwsImV4cCI6MTU2OTg5NDYyMi4wfQ.h32y8wQI-cRVOvH8RVaGaHlB7AqWt4D2ckS7jjqCnJA
            let json = JSON(response.data!)
            if json.error == nil && json.type != .null {
                // 获取正常
                if json.type == .dictionary {
                    // 判断字典类型的错误 情况
                    if PlanHttpRequest().jsonResultStatus(json: json) == false && isJudgeCode == false {
                        let msg = PlanHttpRequest().jsonResultErrorMessage(json: json)
                        block(msg,[])
                        return
                    }
                    // 判断Code
                    if json.dictionaryValue["Code"]?.int == 0 {
                        var msg = json.dictionaryValue["Message"]?.string
                        
                        if msg == nil {
                            msg = "获取失败"
                        }
                        
                        print("出错地址:"+url!)
                        block(msg!,[])
                        return
                    }
                    // 添加服务器的错误
                    if json.dictionaryValue["ErrorId"] != nil {
                        var msg = json.dictionaryValue["Message"]?.string
                        if msg == nil {
                            msg = "获取失败"
                        }
                        print("出错地址:"+url!)
                        block(msg!,[])
                        return
                    }
                    
                }else if json.type == .array {
                    if json.arrayValue.count <= 0 {
                        block("没有获取到数据",[])
                        return
                    }
                }
                // 所有正常数据
                block("",json)
            }else {
                // 获取异常
                
                print("出错地址链接请求失效:"+url! + "\t原因" + response.response.debugDescription)
                block("链接请求失效",[])
            }
        }
    }
    
    /// 下载图片 或者 其他文件 后 存入本地
    static func downloadImageOrFile(url:String,resultBlock:((_ success : Bool ,_ error : String)->Void)?) {
        self.downloadImageOrFile(url: url, isPhoto: true, resultBlock: resultBlock)
    }
    
    static func downloadImageOrFile(url:String,isPhoto:Bool,resultBlock:((_ success : Bool ,_ error : String)->Void)?) {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, false).first!
        if isPhoto {
            
        }else {
            
        }
        
        let fileName = PlanHttpRequest().urlWithToFileName(url: url)
        
        
        let filePath = String(describing: path + fileName)
        
        download(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil) { (url, res) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            
            return (URL(fileURLWithPath:filePath ),[DownloadRequest.DownloadOptions.createIntermediateDirectories,DownloadRequest.DownloadOptions.removePreviousFile])
        }.downloadProgress { (pro) in
            
        }.responseJSON { (res) in
            switch res.result {
            case .success:
                if resultBlock != nil {
                    resultBlock!(true,filePath)
                }
                break
            case .failure:
                if resultBlock != nil {
                    resultBlock!(false,res.description)
                }
                break
            }
        }
    }
    
    func urlWithToFileName(url:String) -> String {
        let strS = url.components(separatedBy: #"/"#)
        if strS.count > 3 {
            
        }
        return ""
    }
    
    
    
    
    func jsonResultStatus(json:JSON) -> Bool {
        if json.dictionary!["code"] != nil {
            return (json.dictionary!["code"]?.boolValue)!
        }
        
        return true
    }
    
    func jsonResultErrorMessage(json:JSON) -> String {
        if json.dictionary!["message"] != nil {
            return (json.dictionary!["message"]?.string)!
        }
        else if json.dictionary!["Message"] != nil {
            return (json.dictionary!["Message"]?.string)!
        }
        else if json.dictionary!["Content"] != nil {
            return (json.dictionary!["Content"]?.string)!
        }
        else if json.dictionary!["content"] != nil {
            return (json.dictionary!["content"]?.string)!
        }
        return ""
    }
    
    /// 将url 与 请求的参数进行分装成为 String 类型
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - param: 请求的参数
    /// - Returns: 封装后的地址
    static func parameterAndUrlToString(url:String,param:[String:Any]) -> String {
        // 不存在参数
        if param.count == 0 {
            return ""
        }
        let array = NSMutableArray()
        for value  in param {
            
            array.add(value.key)
        }
        array.sort { (value1, value2) -> ComparisonResult in
            let val1:String = value1 as! String
            let val2:String = value2 as! String
            return val1.compare(val2)
        }
        
        var value:String = ""
        for dic in param {
            if value.isEmpty {
                value = String(dic.key)+"="+PlanHttpRequest().anyToString(any: dic.value)+"&"
            }else {
                value = value + String(dic.key)+"="+PlanHttpRequest().anyToString(any: dic.value)+"&"
            }
        }
        
        if value.hasSuffix("&") {
            let index = String.Index(encodedOffset:  value.count - 1)
            value = String(value.prefix(upTo: index))
        }
        return value
    }
    //    http://192.168.2.223:8081/Comment/Add?order_id=74&userKey=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IjE4Mzg1NzM0MTM0IiwicGFzc3dvcmQiOm51bGwsImV4cCI6MTU1NjE2MTkwMS4wfQ.71o6ETXoYyrzE18g9ePzd089vZ_pS6t37BvfiRk1FHM&for_id=1&score=5&content=不会的打瀵
    /// 把Any 参数转变为 String 类型
    ///
    /// - Parameter any: Any
    /// - Returns: String
    func anyToString(any:Any) -> String {
        var string = ""
        if any is Int {
            string = String(any as! Int)
        }else if any is Double {
            string = String(any as! Double)
        }else if any is Float {
            string = String(any as! Float)
        }else if any is Bool {
            string = String(any as! Bool)
        }else if any is String {
            string = String(any as! String)
        }
        return string
    }
    
}
