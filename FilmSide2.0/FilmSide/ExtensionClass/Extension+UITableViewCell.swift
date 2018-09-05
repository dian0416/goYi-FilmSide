//
//  Extension+UITableViewCell.swift
//  WineDealer
//
//  Created by 米翊米 on 2016/12/19.
//  Copyright © 2016年 🐨🐨🐨. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    //左边距为0
    func separatorZero (leftInset:CGFloat = 0) {
        self.separatorInset = UIEdgeInsetsMake(0, leftInset, 0, 0)
        self.layoutMargins = UIEdgeInsetsMake(0, leftInset, 0, 0)
        self.preservesSuperviewLayoutMargins = false
    }
    
    func separatorHidden(){
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, AppWidth)
    }
    
}
