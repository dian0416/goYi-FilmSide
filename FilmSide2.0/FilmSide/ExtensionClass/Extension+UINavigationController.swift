//
//  NavigationExtension.swift
//  N+Store
//
//  Created by 米翊米 on 2016/7/14.
//  Copyright © 2016年 天宫. All rights reserved.
//

import UIKit


extension UINavigationController {
    
    //控制导航栏下的阴影显示与否
    func shadowHidden(flag: Bool) {
        for iview in navigationBar.subviews {
            for uview in iview.subviews {
                if uview.isKind(of: UIImageView.classForCoder()) {
                    uview.isHidden = flag
                    return
                }
            }
        }
    }
    
    //设置导航栏透明度
    func navigationAlpha(alpha: CGFloat){
        self.navigationBar.subviews[0].alpha = alpha
    }
    
    //导航栏手势是否禁止
    func forbidenBack(enabeled: Bool){
        self.interactivePopGestureRecognizer?.isEnabled = !enabeled
    }
    
}
