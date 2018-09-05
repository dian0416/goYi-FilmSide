//
//  InfoCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/20.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lookBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    var model:NewsModel? {
        didSet{
            imgView.loadImage(model?.imgUrl)
            lookBtn.setTitle("\(model!.readCount)", for: .normal)
            nameLbl.text = model?.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        separatorZero()
        lookBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        nameLbl.font = UIFont.systemFont(ofSize: 15)
    }    
}
