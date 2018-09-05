//
//  RoleActionCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/21.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class RoleActionCell: UITableViewCell {
    @IBOutlet weak var tentLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    var model:RoleModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.selectionStyle = .none
        tentLabel.font = UIFont.systemFont(ofSize: 14)
        submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "update", data: model)
    }
}
