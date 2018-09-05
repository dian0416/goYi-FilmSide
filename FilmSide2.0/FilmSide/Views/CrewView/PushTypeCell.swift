//
//  PushTypeCell.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/4/17.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class PushTypeCell: UITableViewCell {
    @IBOutlet var typeBtn: UIButton!
    @IBOutlet var typeLabel: UILabel!
    
    @IBAction func typeClick(_ sender: Any) {
        publicDelegate?.dataHandler(type: "pushType", data: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
