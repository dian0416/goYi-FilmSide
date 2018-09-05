//
//  SelectInfoCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class SelectInfoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftButton.isSelected = true
        leftButton.layer.borderColor = skinColor.cgColor
        leftButton.layer.cornerRadius = 5
        rightButton.layer.cornerRadius = 5
        rightButton.layer.borderColor = lineColor.cgColor
        leftButton.layer.borderWidth = 1
        rightButton.layer.borderWidth = 1
        self.selectionStyle = .none
        self.separatorZero(leftInset: 10)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        descLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    @IBAction func leftClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "left", data: indexPath)
        change(button: sender)
    }
    
    @IBAction func rightClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "right", data: indexPath)
        change(button: sender)
    }
    
    func change(button: UIButton){
        if button == leftButton {
            leftButton.layer.borderColor = skinColor.cgColor
            leftButton.isSelected = true
            rightButton.layer.borderColor = lineColor.cgColor
            rightButton.isSelected = false
        } else {
            leftButton.layer.borderColor = lineColor.cgColor
            leftButton.isSelected = false
            rightButton.layer.borderColor = skinColor.cgColor
            rightButton.isSelected = true
        }
    }

}
