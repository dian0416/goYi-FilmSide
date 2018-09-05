//
//  UserDescCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/10.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class UserDescCell: UITableViewCell {
    @IBOutlet var personalitys: [UILabel]!
    @IBOutlet var specialty: [UILabel]!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var special2Top: NSLayoutConstraint!
    @IBOutlet weak var person2Top: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
