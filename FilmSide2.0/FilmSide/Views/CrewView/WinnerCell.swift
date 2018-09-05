//
//  WinnerCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/20.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class WinnerCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var honourBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var typeWidth: NSLayoutConstraint!
    @IBOutlet weak var typeHeight: NSLayoutConstraint!
    @IBOutlet weak var favBtn: UIButton!
    
    var model:UserBaseInfoModel? {
        didSet{
            nameLbl.text = model?.actor?.realName
            if nameLbl.text == nil {
                nameLbl.text = model?.actor?.nickName
            }
            if nameLbl.text == nil {
                nameLbl.text = model?.realName
            }
            if nameLbl.text == nil {
                nameLbl.text = model?.nickName
            }
            if model?.actor?.broker == 1 {
                typeLbl.text = "有经纪公司"
            } else {
                typeLbl.text = "无经纪公司"
            }

            if model?.actor?.headImg != nil {
                imgView.loadImage(model?.actor?.headImg)
            } else {
                imgView.loadImage(model?.actorPhoto)
            }
            if souceType == 0 {
                if let type = model?.actor?.starType {
                    if souceType == 0 {
                        honourBtn.setImage(UIImage(named: "crown"), for: .normal)
                        honourBtn.setTitle(nil, for: .normal)
                        honourBtn.setTitle(type == 1 ? "周冠军":"月冠军", for: .normal)
                    }
                }
            } else {
                if model?.status == 0 {
                    honourBtn.isHidden = false
                    honourBtn.setTitle("收藏", for: .normal)
                    honourBtn.setImage(UIImage(named: "favgray"), for: .normal)
                } else if model?.status == 1 && souceType != 6 {
                    honourBtn.isHidden = true
                }
            }
        }
    }
    var souceType:Int = 0 {
        didSet{
            if souceType > 0 {
                favBtn.isHidden = true
                honourBtn.isHidden = false
                if souceType == 6 {
                    honourBtn.setTitle("取消收藏", for: .normal)
                    honourBtn.setImage(UIImage(named: "favred"), for: .normal)
                } else {
                    if model?.status > 0 {
                        honourBtn.isHidden = true
                    } else {
                        honourBtn.isHidden = false
                        honourBtn.setTitle("收藏", for: .normal)
                        honourBtn.setImage(UIImage(named: "favgray"), for: .normal)
                    }
                }
            } else {
                favBtn.isHidden = false
                honourBtn.setImage(UIImage(named: "crown"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        separatorZero()
        separatorHidden()
        backgroundColor = UIColor.white
        imgView.clipsToBounds = true
        nameLbl.font = UIFont.systemFont(ofSize: 15)
        typeLbl.font = UIFont.systemFont(ofSize: 11)
        honourBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        let size = typeLbl.text!.sizeString(font: UIFont.systemFont(ofSize: 11), maxWidth: AppWidth)
        typeWidth.constant = size.width+20
        typeHeight.constant = size.height+5
        typeLbl.layer.cornerRadius = (size.height+5)/2
        
        favBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        favBtn.backgroundColor = UIColor(white: 0, alpha: 0.5)
        favBtn.layer.cornerRadius = 5
        favBtn.clipsToBounds = true
    }
    
    @IBAction func headClick(_ sender: UIButton) {
        if souceType == 6 {
            publicDelegate?.dataHandler(type: "disfav", data: model)
        } else {
            if model?.status > 0 {
                publicDelegate?.dataHandler(type: "disfav", data: model)
                return
            }
            publicDelegate?.dataHandler(type: "fav", data: model)
        }
    }
    

    @IBAction func favClick(_ sender: UIButton) {
        if model?.status > 0 {
            publicDelegate?.dataHandler(type: "disfav", data: model)
            return
        }
        publicDelegate?.dataHandler(type: "fav", data: model)
    }
}
