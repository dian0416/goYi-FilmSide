//
//  SwarmCell.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class SwarmCell: UITableViewCell {
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var countBtn: UIButton!
    @IBOutlet weak var addrBtn: UIButton!
    var model:SwarmModel? {
        didSet{
            timeBtn.setTitle(nil, for: .normal)
            if let time = model?.byTime {
                let ss = "\(time/1000)".stringFormartDate(formart: "yyyy-MM-dd HH:mm")
                 timeBtn.setTitle(ss, for: .normal)
            }
           
            countBtn.setTitle("0", for: .normal)
            if let count = model?.personCount {
                countBtn.setTitle("\(count)", for: .normal)
            }
            addrBtn.setTitle(model?.city, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addrBtn.titleLabel?.numberOfLines = 0
        selectionStyle = .none
        timeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        countBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addrBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }

}
