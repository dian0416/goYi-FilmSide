//
//  TrendsHeadCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/22.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class TrendsHeadCell: UITableViewCell {
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var typeHeight: NSLayoutConstraint!
    @IBOutlet weak var typeWidth: NSLayoutConstraint!
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var descRight: NSLayoutConstraint!
    @IBOutlet weak var descLeft: NSLayoutConstraint!
    
    var model:InvitionModel? {
        didSet{
            imgBtn.loadImage(model?.headImg)
            nameLbl.text = model?.nickName
            levelLbl.text = model?.integralName
            if levelLbl.text != nil {
                let size = levelLbl.text!.sizeString(font: UIFont.systemFont(ofSize: 11), maxWidth: AppWidth)
                typeWidth.constant = size.width+5
                typeHeight.constant = size.height
                levelLbl.layer.cornerRadius = typeHeight.constant/2
            }
            timeLbl.text = nil
            if let time = model?.addTime {
//                if model?.imgList?.count > 0 {
//                    timeLbl.text = "\(time/1000)".stringFormartDate(formart: "yyyy-MM-dd")
//                } else {
                    timeLbl.text = "\(time/1000)".stringFormartDate(formart: "yyyy-MM-dd HH:mm:ss")
//                }
            }
            descLabel.text = model?.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.separatorZero()
        self.separatorHidden()
        levelLbl.layer.borderColor = skinColor.cgColor
        levelLbl.layer.borderWidth = 1
        levelLbl.layer.cornerRadius = 7.5
        levelLbl.clipsToBounds = true
        nameLbl.font = UIFont.systemFont(ofSize: 15)
        levelLbl.font = UIFont.systemFont(ofSize: 11)
        timeLbl.font = UIFont.systemFont(ofSize: 11)
        descLabel.font = UIFont.systemFont(ofSize: 15)
        imgBtn.imageView?.contentMode = .scaleAspectFill
    }
    
    @IBAction func userClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "user", data: model)
    }
    
    @IBAction func forwardClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "delete", data: model?.id)
    }
}
