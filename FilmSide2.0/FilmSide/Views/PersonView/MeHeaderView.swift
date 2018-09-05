//
//  MeHeaderView.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/8/8.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class MeHeaderView: UIView {

    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var headImageView: UIImageView!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var telLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var sexImageView: UIImageView!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        editBtn.layer.cornerRadius = 10
        editBtn.clipsToBounds = true
    }
 

}
