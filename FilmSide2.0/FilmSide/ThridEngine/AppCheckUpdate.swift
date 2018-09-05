//
//  AppCheckUpdate.swift
//  WineDealer
//
//  Created by 米翊米 on 2017/3/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Alamofire

class AppCheckUpdate: NSObject {
    static let AppStoreID = "1233046101"
    static func check(){
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        // AppStore地址(字符串)
        let path = "http://itunes.apple.com/cn/lookup?id=\(AppStoreID)"
        request(path, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (result) in
            let dict = try? JSONSerialization.jsonObject(with: result.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
            if dict?["resultCount"] as? Int > 0 {
                if let results = dict?["results"] as? [[String: Any?]] {
                    if let version = results.first?["version"] as? String {
                        if currentVersion.compare(version) == ComparisonResult.orderedAscending {
                            let alertVC = UIAlertController(title: "版本升级", message: "有新版本更新了", preferredStyle: .alert)
                            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                            alertVC.addAction(UIAlertAction(title: "去升级", style: .destructive, handler: { (_) in
                                UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/cn/app/%E7%99%BE%E7%9B%8A%E6%9D%A5%E8%AE%A2%E8%B4%AD/id\(AppStoreID)?mt=8")!)
                            }))
                            UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
        }
    }
    
}
