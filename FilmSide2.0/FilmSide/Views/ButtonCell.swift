//
//  ButtonCell.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    @IBOutlet weak var addBtn: UIButton!
    var type:String = ""
    @IBOutlet weak var swarmBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "role", data: nil)
    }
    
    @IBAction func swarmClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "qunyan", data: nil)
    }
    
}
