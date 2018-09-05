//
//  InfoAworksCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/8.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class InfoAworksCell: UITableViewCell {
    @IBOutlet weak var addBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addBtn.layer.cornerRadius = 8
        addBtn.layer.borderColor = backColor.cgColor
        addBtn.layer.borderWidth = 1
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "addwork", data: nil)
    }
    
}
