//
//  CrewCollectionCell.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/6/5.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class CrewCollectionCell: UICollectionViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var headImageView: UIImageView!
    var model:UserBaseInfoModel?{
        didSet{
            nameLabel.text = model?.realName
            headImageView.loadImage(model?.headImg)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        headImageView.layer.cornerRadius = headImageView.frame.size.width / 2
//        headImageView.layer.masksToBounds = true
//        headImageView.clipsToBounds = true
        // Initialization code
    }

}
