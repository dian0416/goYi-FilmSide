//
//  ItemCell.swift
//  SwiftDemo
//
//  Created by 米翊米 on 2017/3/28.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var imageViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTopSpace: NSLayoutConstraint!
    @IBOutlet weak var titleBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var titleMaxH: NSLayoutConstraint!
    @IBOutlet weak var titleMinH: NSLayoutConstraint!
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//     
////        if textLabelisCorner {
////            let height = 
////        }
//    }

}
