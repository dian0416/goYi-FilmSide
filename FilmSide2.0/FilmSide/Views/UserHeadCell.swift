//
//  UserHeadCell.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class UserHeadCell: UITableViewCell {
    @IBOutlet var imgViews: [UIButton]!
    @IBOutlet weak var descLabel: UILabel!
    var actors:[String]? {
        didSet{
            if actors != nil {
                for imageBtn in imgViews {
                    imageBtn.isHidden = true
                }
                for i in 0..<actors!.count {
                    if i < imgViews.count {
                        imgViews[i].isHidden = false
                        imgViews[i].loadImage(actors![i])
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        for i in 0..<imgViews.count {
            imgViews[i].tag = 100+i
            imgViews[i].layer.cornerRadius = imgViews[i].frame.height/2
            imgViews[i].clipsToBounds = true
        }
        separatorZero()
    }
    
    @IBAction func userClick(_ sender: UIButton) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for i in 0..<imgViews.count {
            imgViews[i].tag = 100+i
            imgViews[i].layer.cornerRadius = imgViews[i].frame.height/2
            imgViews[i].clipsToBounds = true
        }
    }
}
