//
//  Extension+UIView.swift
//  CornPoppy
//
//  Created by 米翊米 on 2016/11/23.
//  Copyright © 2016年 GZX. All rights reserved.
//

import UIKit

extension UIView {
    private static var numLabel = UILabel()
    
    //关闭键盘
    func hideKeyboard() {
        self.endEditing(true)
    }
    
    //渐变色
    func layerDraw(colors:[CGColor], locals:[CGFloat] = [0.0, 1.0], frame:CGRect) {
        //创建CAGradientLayer实例并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locals as [NSNumber]?
        
        //设置其frame以及插入view的layer
        gradientLayer.frame = frame
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //创建角标
    func setBadge(numbel:UILabel, number: String) {
        if number.tirmSpace().length() == 0 || number == "0" {
            numbel.removeFromSuperview()
            return
        }
        let width = self.frame.width
        
        let size = number.sizeString(font: UIFont.systemFont(ofSize: 11), maxWidth: width)
        if size.width < size.height {
            numbel.frame = CGRect(x: width-size.width/2-5, y: 5, width: size.height, height: size.height)
            numbel.layer.cornerRadius = size.height/2
        }else{
            numbel.frame = CGRect(x: width-size.width/2-5, y: 5, width: size.width+5, height: size.height+2)
            numbel.layer.cornerRadius = size.height/2-1
        }
        numbel.clipsToBounds = true
        numbel.font = UIFont.systemFont(ofSize: 11)
        numbel.backgroundColor = yellowColor
        numbel.textAlignment = .center
        numbel.textColor = skinColor
        numbel.text = number
        
        self.addSubview(numbel)
    }
    
}
