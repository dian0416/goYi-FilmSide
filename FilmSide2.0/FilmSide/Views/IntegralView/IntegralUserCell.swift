//
//  IntegralUserCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/26.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class IntegralUserCell: UITableViewCell {
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var integarlLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
