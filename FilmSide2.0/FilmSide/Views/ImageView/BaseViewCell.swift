//
//  BaseViewCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/25.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class BaseViewCell: UITableViewCell {
    var images:[String?]?
    var isEnable = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        separatorZero()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel?.frame = CGRect(x: 80, y: 15, width: AppWidth-90, height: 20)
        self.detailTextLabel?.frame = CGRect(x: 80, y: 45, width: AppWidth-90, height: 20)
        self.imageView?.frame = CGRect(x: 12, y: 10, width: 60, height: 60)
    }

}
