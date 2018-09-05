//
//  ZZYShouCangCell.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/6/12.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ZZYShouCangCell: UICollectionViewCell {

    @IBOutlet var headImageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    var model:UserBaseInfoModel?{
        didSet{
            headImageView.loadImage(model?.headImg)
            let sex = model?.sex == 0 ?"男":"女"
            messageLabel.text = model?.realName ?? "" + sex
            ageLabel.text = model?.birthday ?? "" + "\(model?.height ?? 1)" + "\(model?.weight ?? 1)"
            
//            messageLabel.text = model?.nickName
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
