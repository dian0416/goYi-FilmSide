//
//  InfoViewCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/25.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class InfoViewCell: UITableViewCell {
    @IBOutlet weak var textLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
    }
    @IBAction func forwardClick(_ sender: UIButton) {
    }
}
