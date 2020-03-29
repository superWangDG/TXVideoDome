//
//  AppDelegate.swift
//  TXVideoDome
//
//  Created by 98data on 2019/9/28.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let License_Url  = "http://license.vod2.myqcloud.com/license/v1/10b5c66e4e7b7609e568a02e567800d9/TXUgcSDK.licence"
    let Video_Key  = "d08de4734a49bc3807abff720e851dbf"
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TXUGCBase.setLicenceURL(License_Url, key: Video_Key)
        return true
    }

}

