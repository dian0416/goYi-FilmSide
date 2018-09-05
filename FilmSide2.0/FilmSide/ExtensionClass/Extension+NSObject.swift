//
//  Extension+NSObject.swift
//  WineDealer
//
//  Created by 米翊米 on 2017/1/18.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

protocol ControlDelegate {
    func dataHandler(type: Any?, data:Any?)
}

extension NSObject {
    struct Object {
        static var insKey = "key"
    }
    
    var publicDelegate:ControlDelegate? {
        set(newVlue){
            objc_setAssociatedObject(self, &Object.insKey, newVlue, .OBJC_ASSOCIATION_RETAIN)
        }
        get{
            return objc_getAssociatedObject(self, &Object.insKey) as? ControlDelegate
        }
    }
    
    //颜色生成图片
    func imageWithColor(size: CGSize, color:UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.setFillColor(color.cgColor)
        ctx!.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //处理图片大小
    func imageWithSize(image:UIImage, size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //返回弱引用
    func weakSelf() -> AnyObject {
        weak var weakS = self
        
        return weakS as AnyObject
    }
    
    //文字提示
    func textHUD(_ string: String, timeval:CGFloat = 1.0){
        HUDNotice.clear()
        HUDNotice.showText(string, autoClearTime: timeval)
    }
    
    //加载提示
    func loadHUD(){
        HUDNotice.clear()
        HUDNotice.wait()
    }
    
    
    //隐藏提示
    func hideHUD(){
        HUDNotice.clear()
    }
    
    //获取当前时间
    func getDateTime(formart: String) -> String {
        let marter = DateFormatter()
        marter.dateFormat = formart
        
        return marter.string(from: Date())
    }
    
    //获取最近一周的日期
    func getWeakDay(formart: String) -> [String] {
        let ondDay = 24*60*60
        let today = Date()
        let marter = DateFormatter()
        marter.dateFormat = formart
        
        var days = [String]()
        for i in -6..<1 {
            let dateStrig = marter.string(from: today.addingTimeInterval(TimeInterval(i*ondDay)))
            days.append(dateStrig)
        }
        
        return days
    }
    
}

let SizeScale =  ((AppHeight > 568) ? AppHeight/568 : 1)

extension UIFont {
    
    class func exchangeFont() {
        let imp = class_getClassMethod(UIFont.classForCoder(), #selector(UIFont.systemFont(ofSize:)))
        let myImp = class_getClassMethod(UIFont.classForCoder(), #selector(UIFont.myFont(ofSize:)))
        method_exchangeImplementations(imp, myImp)
    }
    
    class func myFont(ofSize: CGFloat) -> UIFont {
        print(ofSize)
        let size = ofSize*SizeScale
        return UIFont.myFont(ofSize: size)
    }
}

