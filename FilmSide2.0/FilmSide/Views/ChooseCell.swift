//
//  ChooseCell.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ChooseCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    var indexPath:IndexPath!
    var model:ActorModel? {
        didSet{
            imgView.loadImage(model?.actorPhoto)
            nameLabel.text = model?.realName
            levelLabel.text = nil
            levelLabel.isHidden = false
            if model?.starType == 1 {
                levelLabel.text = "周冠军"
            } else if model?.starType == 2 {
                levelLabel.text = "月冠军"
            } else {
                levelLabel.isHidden = true
            }
            if model?.status == 1 {
                favBtn.setTitle("已收藏", for: .normal)
                favBtn.setTitleColor(skinColor, for: .normal)
                favBtn.layer.borderColor = skinColor.cgColor
            } else {
                favBtn.setTitle("收藏", for: .normal)
                favBtn.setTitleColor(titleColor, for: .normal)
                favBtn.layer.borderColor = titleColor.cgColor
            }
            descLabel.text = model?.remark
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        levelLabel.isHidden = true
        descLabel.numberOfLines = 0
        levelLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        levelLabel.layer.cornerRadius = 10
        levelLabel.clipsToBounds = true
        noteBtn.layer.cornerRadius = 15
        favBtn.layer.cornerRadius = 15
        favBtn.backgroundColor = UIColor.white
        favBtn.layer.borderColor = titleColor.cgColor
        favBtn.setTitleColor(titleColor, for: .normal)
        favBtn.layer.borderWidth = 0.5
        
        descLabel.preferredMaxLayoutWidth = AppWidth/5*3
        selectionStyle = .none
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        levelLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.font = UIFont.systemFont(ofSize: 15)
        noteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        favBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    @IBAction func favClick(_ sender: UIButton) {
        if model?.status == 0 {
            publicDelegate?.dataHandler(type: "fav", data: model)
        } else {
            
        }
    }
    
    @IBAction func noteClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "note", data: model)
    }
    
    func changeBoder(){
        
    }
    
}
