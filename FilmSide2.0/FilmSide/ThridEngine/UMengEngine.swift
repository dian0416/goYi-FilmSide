//
//  UmengEngine.swift
//  WineDealer
//
//  Created by 米翊米 on 2017/2/14.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class UmengEngine:NSObject, UMSocialShareMenuViewDelegate {
    static let instance = UmengEngine()
    private var handlerBlock:(()->())?
    private var shareObject:UMShareWebpageObject?
    private let directUrl = "http://www.baidu.com"
    private let umengAppkey = "5861e5daf5ade41326001eab"
    
    private let wechatAppkey = "wx0f1b8d74ec74c237"
    private let wechatSecret = "29236cfd39cbd18985fba3045b299a9f"
    
    private let qqAppkey = "101399982"
    private let qqSecret = "c9ff7ca803908be4dae3a170b48100ac"
    
    private let sinaAppkey = "3921700954"
    private let sinaSecret = "04b48b094faeb16683c32669824ebdad"
    
    private lazy var shareView:ShareView = {
        let share = ShareView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: AppHeight))
        share.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        return share
    }()
    
    private override init() {
        super.init()
        
    }
    
    //umeng初始化
    func initSDK() {
        UMSocialManager.default().openLog(true)
        UMAnalyticsConfig.sharedInstance().appKey = umengAppkey
        UMAnalyticsConfig.sharedInstance().channelId = "App Store"
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        
        //初始化umeng分享
        UMSocialManager.default().umSocialAppkey = umengAppkey
        UMSocialManager.default().setPlaform(.wechatSession, appKey: wechatAppkey, appSecret: wechatSecret, redirectURL: directUrl)
        UMSocialManager.default().setPlaform(.QQ, appKey: qqAppkey, appSecret: "", redirectURL: directUrl)
        UMSocialManager.default().setPlaform(.sina, appKey: sinaAppkey, appSecret: sinaSecret, redirectURL: directUrl)
    }
    
    func getUserInfo(platformType: UMSocialPlatformType, resp:@escaping ((_ result: UMSocialUserInfoResponse)->())){
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: nil) { (result, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            resp(result as! UMSocialUserInfoResponse)
//            let resp =
//            debugPrint(resp.originalResponse)
//            print(resp.uid, resp.openid, resp.accessToken, resp.refreshToken, resp.expiration)
//            print(resp.name, resp.iconurl, resp.gender, resp.originalResponse)
        }
    }
    
    func showShareView(object:UMShareWebpageObject, complete: (()->())? = nil){
        handlerBlock = complete
        shareObject = object
        shareView.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(shareView)
    }
    
    func shareContent(platform: UMSocialPlatformType){
        let messageObject = UMSocialMessageObject()
        shareObject?.thumbImage = UIImage(named: "icon")
        messageObject.shareObject = shareObject
        
        UMSocialManager.default().share(to: platform, messageObject: messageObject, currentViewController: nil) { (result, error) in
            if error != nil {
                debugPrint(error.debugDescription)
            } else {
                debugPrint(result!)
                if self.handlerBlock != nil {
                    self.handlerBlock!()
                }
            }
        }
    }
    
}
