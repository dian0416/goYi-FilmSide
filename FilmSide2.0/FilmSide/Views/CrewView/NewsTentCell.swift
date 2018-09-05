//
//  NewsTentCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/23.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class NewsTentCell: UITableViewCell {
    @IBOutlet weak var tentLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var backView: UIImageView!
    
    @IBOutlet weak var descLeft: NSLayoutConstraint!
    
    @IBOutlet weak var descRight: NSLayoutConstraint!
    var model:InvitionModel? {
        didSet{
            tentLbl.text = model?.content
            timeLbl.text = nil
            if let time = model?.addTime {
//                if model?.imgList?.count > 0 {
//                    timeLbl.text = "\(time/1000)".stringFormartDate(formart: "yyyy-MM-dd")
//                } else {
                    timeLbl.text = "\(time/1000)".stringFormartDate(formart: "yyyy-MM-dd HH:mm:ss")
//                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.separatorHidden()
        tentLbl.font = UIFont.systemFont(ofSize: 15)
        timeLbl.font = UIFont.systemFont(ofSize: 13)
    }
    
}
