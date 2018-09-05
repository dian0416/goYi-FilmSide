//
//  GeTuiEngine.swift
//  WineDealer
//
//  Created by 米翊米 on 2017/3/8.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import UserNotifications

//推送
class GeTuiEngine: NSObject, UNUserNotificationCenterDelegate, GeTuiSdkDelegate {
    static let instance = GeTuiEngine()
    private let GTAPPID   = "DtElXW5pIk8TfjcrejzDm1"
    private let GTAPPKEY  = "9HZCPOZMIW51qldGgUVzqA"
    private let GTAPPSEC  = "rXTi2uVmmx6FAYHzkYObp6"
    
    private override init() {
        
    }
    
    func initSDK(){
        //注册推送
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                if granted {
                    debugPrint("注册成功")
                }else{
                    debugPrint(error ?? "")
                }
            })
        } else {
            let noticeSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(noticeSettings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        GeTuiSdk.start(withAppId: GTAPPID, appKey: GTAPPKEY, appSecret: GTAPPSEC, delegate: self)
    }
    
    //注册devicetoken
    func gtRemoteDeviceToken(deviceToken: Data) {
        var token: String = ""
        
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        
        GeTuiSdk.registerDeviceToken(token)
    }
    
    func gtDidReceiveRemoteNotification(userinfo: [AnyHashable: Any]){
        GeTuiSdk.handleRemoteNotification(userinfo)
        showAlertVC()
    }
    
    func gtApplicationDidBecomeActive(){
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        debugPrint(notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        GeTuiSdk.handleRemoteNotification(response.notification.request.content.userInfo)
        showAlertVC()
        completionHandler()
    }
    
    //#MARK: - 个推回调
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        debugPrint(clientId)
        //绑定别名
        if let userid = userDef.object(forKey: "userid") as? String {
            GeTuiSdk.bindAlias(userid, andSequenceNum: clientId)
        }
    }
    
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        debugPrint(String(bytes: payloadData, encoding: String.Encoding.utf8) ?? "23")
        
        if UIApplication.shared.applicationState == .active {
            showAlertVC()
        }
    }
    
    func geTuiSdkDidAliasAction(_ action: String!, result isSuccess: Bool, sequenceNum aSn: String!, error aError: Error!) {
        if aError != nil {
            debugPrint(aError)
        }
    }
    
    func showAlertVC(){
        let alertVC = UIAlertController(title: "您有一条信息", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (_) in
            self.currentVC()?.navigationController?.pushViewController(WD_SmsNoticeVC().hiddenTabBar(), animated: true)
        }))
        self.currentVC()?.present(alertVC, animated: true, completion: nil)
    }
    
    func currentVC() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        var curVC = window?.rootViewController
        
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.shared.windows
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin
                }
            }
        }
        
        let frontView = window?.subviews[0]
        if let responder = frontView?.next {
            if responder.isKind(of: UIViewController.classForCoder()) {
                curVC = responder as? UIViewController
            }
        }
        
        if let tmpvc = curVC as? UITabBarController {
            curVC = tmpvc.viewControllers?[tmpvc.selectedIndex]
        }
        if let tmpvc = curVC as? UINavigationController {
            curVC = tmpvc.viewControllers[0]
        }
        
        return curVC
    }
    
}
