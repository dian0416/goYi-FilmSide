//
//  InfoListCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/25.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class InfoListCell: UITableViewCell {
    @IBOutlet weak var markImgView: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        markImgView.layer.cornerRadius = 2.5
        markImgView.clipsToBounds = true
    }
    
}
