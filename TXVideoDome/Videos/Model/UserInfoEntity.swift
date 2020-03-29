//
//  UserInfoEntity.swift
//  TXVideoDome
//
//  Created by 98data on 2019/12/13.
//  Copyright © 2019 98data. All rights reserved.
//

import Foundation

class UserInfoEntity {
    
    var nick_name = ""
    // 可以提现的x金额
    var money = 0.0
    var allMoney = 0.0
    // 不能提现 的金额
    var coldMoney = 0.0
    var integral = 0.0
    var bank_card = ""
    var avatar = ""
    var bank_name = ""
    var bank_address = ""
    var insurance_end_time = ""
    var car_reg_time = ""
    var car_end_time = ""
    var brands = ""
    var iDCard = ""
    var name = ""
    var id = 0
    var address = ""
    var username = ""
    var car_type = ""
//    var car_brands = CarBrandsEntity()
    var insuranceMileage = ""
    var sex = 0
    var birthday = ""
    var bank_holder = ""
    var level = ""
    var ipoIntegral = 0
    // 推荐码
    var recommendCode = ""
    
    static func initJsonWithEntity(jsonData:JSON) -> UserInfoEntity {
        let entity = UserInfoEntity()
        let jsonDic = jsonData.dictionaryValue
        
        GeneralObjects.jsondic = jsonDic
        
        if GeneralObjects().jsonValueToString(key: "NickName") != "" {
            entity.nick_name = GeneralObjects().jsonValueToString(key: "NickName")
        }else if GeneralObjects().jsonValueToString(key: "Nickname") != "" {
            entity.nick_name = GeneralObjects().jsonValueToString(key: "Nickname")
        }
        
//        if jsonDic["NickName"]?.string != nil {
//            entity.nick_name = jsonDic["NickName"]!.stringValue
//        }else {
//            entity.nick_name = jsonDic["Nickname"]!.stringValue
//        }
        entity.money = jsonDic["Money"]?.doubleValue == nil ? 0.0 : jsonDic["Money"]!.doubleValue
        
        entity.allMoney = jsonDic["MoneyAll"]?.doubleValue == nil ? 0.0 : jsonDic["MoneyAll"]!.doubleValue
        
        entity.coldMoney = jsonDic["ColdMoney"]?.doubleValue == nil ? 0.0 : jsonDic["ColdMoney"]!.doubleValue
        
        entity.integral = jsonDic["Integral"]?.double == nil ? 0.0 : jsonDic["Integral"]!.doubleValue
        
        entity.bank_card = jsonDic["BankCard"]?.string == nil ? "" : jsonDic["BankCard"]!.stringValue
        entity.bank_name = jsonDic["BankName"]?.string == nil ? "" : jsonDic["BankName"]!.stringValue
        entity.bank_address = jsonDic["BankAddress"]?.string == nil ? "" : jsonDic["BankAddress"]!.stringValue
        entity.avatar = jsonDic["Avatar"]?.string == nil ? "" : jsonDic["Avatar"]!.stringValue
        entity.insurance_end_time = jsonDic["InsuranceEndTime"]?.string == nil ? "" : jsonDic["InsuranceEndTime"]!.stringValue
        entity.car_reg_time = jsonDic["CarRegTime"]?.string == nil ? "" : jsonDic["CarRegTime"]!.stringValue
//        entity.car_end_time = jsonDic["CarEndTime"]!.stringValue
        entity.brands = jsonDic["Brands"]?.string == nil ? "" : jsonDic["Brands"]!.stringValue
        entity.iDCard = jsonDic["IDCard"]?.string == nil ? "" : jsonDic["IDCard"]!.stringValue
        entity.name = jsonDic["Name"]?.string == nil ? "" : jsonDic["Name"]!.stringValue
        entity.id = jsonDic["Id"]?.int == nil ? 0 : jsonDic["Id"]!.intValue
        entity.address = jsonDic["Address"]?.string == nil ? "" : jsonDic["Address"]!.stringValue
        entity.username = jsonDic["Username"]?.string == nil ? "" : jsonDic["Username"]!.stringValue
        entity.car_type = jsonDic["CarType"]?.string == nil ? "" : jsonDic["CarType"]!.stringValue
//        entity.car_brands = jsonDic["CarBrands"]!.stringValue
//        entity.car_brands = CarBrandsEntity.initJsonWithEntity(json: jsonDic["CarBrands"]?.dictionaryValue)
        
        entity.insuranceMileage = jsonDic["InsuranceMileage"]?.string == nil ? "" : jsonDic["InsuranceMileage"]!.stringValue
        
        entity.sex = jsonDic["Sex"]?.int == nil ? 0 : jsonDic["Sex"]!.intValue
        entity.birthday = jsonDic["Birthday"]?.string == nil ? "" : jsonDic["Birthday"]!.stringValue
        entity.bank_holder = jsonDic["BankHolder"]?.string == nil ? "" : jsonDic["BankHolder"]!.stringValue
        
        entity.recommendCode = jsonDic["RecommendCode"]?.string == nil ? "" : jsonDic["RecommendCode"]!.stringValue
        
        let levelCount = GeneralObjects().jsonValueToInt(key: "Level")
        if levelCount == 0 {
            entity.level = "下载用户"
        }else if levelCount == 1 {
            entity.level = "普通用户"
        }else if levelCount == 2 {
            entity.level = "业务员"
        }else if levelCount == 3 {
            entity.level = "经理"
        }
        
        entity.ipoIntegral = GeneralObjects().jsonValueToInt(key: "IPOIntegral")
        GeneralObjects().reMoveJsonInit()
        return entity
    }
}
