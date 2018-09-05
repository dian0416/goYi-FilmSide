//
//  DayCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/26.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    @IBOutlet weak var dayBtn: UIButton!

    @IBOutlet weak var descLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
    }
    
}
