//
//  TabBarExtension.swift
//  N+Store
//
//  Created by 米翊米 on 16/8/3.
//  Copyright © 2016年 天宫. All rights reserved.
//

import UIKit

extension UITabBarController: UITabBarControllerDelegate {
    
    //设置相关属性
    func tabbarAttri(backColor: UIColor? = UIColor.white, backImage:UIImage? = UIImage()) -> UITabBarController{
        //去除阴影
        //UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        self.tabBar.backgroundColor = tabbarColor
        
        return self
    }
    
    //初始化TAB选项
    func addArray(_ array: [UIViewController]){
        self.delegate = self
        self.tabBar.backgroundImage = imageWithColor(size: CGSize(width: AppWidth, height: TabbarH), color: tabbarColor)
    
        self.viewControllers = array
        //设置图文
        self.tabImageTitle()
    }
    
    //初始化Tabbar图片文字
    func tabImageTitle(){
        let titleArray = ["艺人", "发布", "选角", "我的"]
        for i in 0 ..< self.childViewControllers.count{
            let imgdefStr:String = "TabbarDef_\(i)"
            let imgchkStr:String = "TabbarChk_\(i)"
            
            let barItem = self.childViewControllers[i].tabBarItem
            //文字位置
            barItem?.titlePositionAdjustment = UIOffsetMake(0, -3)
            //设置文字及颜色
            barItem?.title = titleArray[i]
            barItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .selected)
            barItem?.setTitleTextAttributes([NSForegroundColorAttributeName:subColor], for: .normal)
            //设置默认图片
            barItem?.image = UIImage(named: imgdefStr)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            //设置选中图片
            barItem?.selectedImage = UIImage(named: imgchkStr)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if AppConst.userid == nil {
            if !viewController.childViewControllers[0].isKind(of: LastVC.classForCoder()) {
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil).addNavigation()
                (self.viewControllers?[0].childViewControllers[0])?.present(loginVC, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
    }

}
