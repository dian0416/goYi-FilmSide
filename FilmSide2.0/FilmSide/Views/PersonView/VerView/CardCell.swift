//
//  CardCell.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/17.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    @IBOutlet weak var imgView: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var section:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        if section == 2 {
            publicDelegate?.dataHandler(type: "up", data: nil)
        } else {
            publicDelegate?.dataHandler(type: "down", data: nil)
        }
    }
    
}
