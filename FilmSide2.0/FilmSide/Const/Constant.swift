//
//  STConstant.swift
//  N+Store
//
//  Created by 米翊米 on 2016/7/14.
//  Copyright © 2016年 天宫. All rights reserved.
//

import UIKit

struct AppConst {
    private static let userDef = UserDefaults.standard
//    static let FormalServer = "http://116.62.127.240:8888/ysq/"
    //测试服务器
    static let FormalServer = "http://61.130.8.25:8888/ysq"
    
    static var levels: [(title:String, score:Int, image:String)] {
        get{
            var titles = ["青铜龙套", "白银龙套", "黄金龙套", "青铜特约", "白银特约", "黄金特约", "青铜演员", "白银演员", "黄金演员", "青铜主演", "白银主演", "黄金主演", "青铜明星", "白银明星", "黄金明星"]
            var level = [(title:String, score:Int, image:String)]()
            for i in 0..<titles.count {
                if i%3 == 0 {
                    level.append((titles[i], (i+1)*500, "rank_\(i+1)_a"))
                } else if i%3 == 1 {
                    level.append((titles[i], (i+1)*500, "rank_\(i+1)_b"))
                } else {
                    level.append((titles[i], (i+1)*500, "rank_\(i+1)_c"))
                }
            }
            
            return level
        }
    }
    //本地headiamge
//    static var headImageL:UIImage? {
//        return AppConst.readVale(key: "headImage") as? UIImage
//    }
    
    static var userid:Int? {
        return AppConst.readVale(key: "id") as? Int
    }
    
    static var mobile:String? {
        return AppConst.readVale(key: "mobile") as? String
    }
    
    static var integralName:String? {
        return AppConst.readVale(key: "integralName") as? String
    }
    
    static var nickName:String? {
        return AppConst.readVale(key: "nickName") as? String
    }
    
    static var realName:String? {
        return AppConst.readVale(key: "realName") as? String
    }
    
    static var height:Int? {
        return AppConst.readVale(key: "height") as? Int
    }
    
    static var weight:Int? {
        return AppConst.readVale(key: "weight") as? Int
    }
    
    static var sex:String? {
        return AppConst.readVale(key: "sex") as? String
    }
    
    static var age:String? {
        return AppConst.readVale(key: "age") as? String
    }
    
    static var headImage:String? {
        return AppConst.readVale(key: "head") as? String
    }
    
    static var star:Int? {
        return AppConst.readVale(key: "star") as? Int
    }
    
    static var level:Int? {
        return AppConst.readVale(key: "level") as? Int
    }
    
    static var levelName:String? {
        return AppConst.readVale(key: "levelname") as? String
    }
    
    static var levelScore:Int? {
        return AppConst.readVale(key: "levelscore") as? Int
    }
    
    static var examine:Int? {
        return AppConst.readVale(key: "examine") as? Int
    }
    
    static var pass:String? {
        return AppConst.readVale(key: "pass") as? String
    }
    
    static func writeVale(key:String, value:Any?) {
        if value is NSNull {
            return
        }
        userDef.set(value, forKey: key)
    }
    
    static func readVale(key:String) -> Any? {
        return userDef.object(forKey: key)
    }
    
    static func removeKey(key:String) {
        return userDef.removeObject(forKey: key)
    }
}

//MARK: - 屏幕宽高
let AppWidth = UIScreen.main.bounds.width
let AppHeight = UIScreen.main.bounds.height

//MARK: - 导航栏和底部栏高度
let NaviStaH:CGFloat = 64.0 //导航栏+状态栏
let StatusH:CGFloat = 20.0 //状态栏高度
let TabbarH:CGFloat = 49.0 //底部栏高度
let NavigationH:CGFloat = 44.0 //导航栏高度

//MARK: - 加入底部栏或导航栏后视图高度
let NaviViewH = AppHeight - NaviStaH //有导航栏无底部栏
let NaviTabH = AppHeight - NaviStaH - TabbarH //有导航栏和底部栏
let TabbarViewH = AppHeight - TabbarH //有底部栏无导航栏

//MARK: - AppDelegate全局
let appGate = UIApplication.shared.delegate as! AppDelegate

//MARK: - NSUserDefaults全局
let userDef = UserDefaults.standard

//MARK: - 颜色
let tabbarColor = UIColor(red:0.17, green:0.18, blue:0.18, alpha:1.00)
let backColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
let skinColor = UIColor(red:0.79, green:0.11, blue:0.13, alpha:1.00)
let titleColor = UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.00)
let subColor = UIColor(red:0.49, green:0.49, blue:0.49, alpha:1.00)
let placeColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.00)
let pinkColor = UIColor(red:0.97, green:0.47, blue:0.48, alpha:1.00)
let greenColor = UIColor(red:0.45, green:0.88, blue:0.72, alpha:1.00)
let yellowColor = UIColor(red:1.00, green:0.97, blue:0.88, alpha:1.00)
let lineColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
let lightColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
let goldColor = UIColor(red:0.89, green:0.73, blue:0.56, alpha:1.00)

//MARK: - 获取方法
func allMethods(_ onwer: AnyObject) -> [String]{
    var nameArray = [String]()
    var numMthods:UInt32 = 0 //成员变量个数
    let meths = class_copyMethodList(onwer.classForCoder, &numMthods)
    
    for i in 0..<numMthods {
        let thisMthod = meths?[Int(i)]
        let name = String(cString: sel_getName(method_getName(thisMthod)))
        //调用方法
        
        //visiVC?.performSelector(method_getName(thisMthod))
        debugPrint(name)
        nameArray.append(name)
    }
    
    free(meths)
    return nameArray
}

//MARK: - 获取属性
func allIvars(_ onwer: AnyObject) -> [String]{
    var nameArray = [String]()
    var numIvars:UInt32 = 0 //成员变量个数
    let ivars = class_copyIvarList(onwer.classForCoder, &numIvars)
    
    for i in 0..<numIvars {
        let thisIvar = ivars?[Int(i)]
        let name = String(cString: ivar_getName(thisIvar))
        
        debugPrint(name)
        nameArray.append(name)
    }
    
    free(ivars)
    
    return nameArray
}

//MARK: - 客服电话
let service = "0572-6559909"

//购物车商品数量
func cartNum() -> Int {
    if let count = userDef.object(forKey: "cart") as? Int {
        return count
    }
    
    return 0
}

