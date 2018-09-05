//
//  PushDetailCell.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/4/18.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class PushDetailCell: UICollectionViewCell {
    @IBOutlet var headImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var readLabel: UILabel!
    var model:FilmInfoModel?{
        didSet{
            headImageView.loadImage(model?.messageImg)
            titleLabel.text = model?.filmName
            readLabel.text = "\(model?.readCount ?? 0)人看过"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
