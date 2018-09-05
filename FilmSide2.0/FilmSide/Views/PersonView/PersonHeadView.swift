//
//  PersonHead.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Kingfisher

class PersonHeadView: UIView {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var winnerButton: UIButton!
    @IBOutlet weak var backBottomH: NSLayoutConstraint!
    @IBOutlet weak var nameCenterY: NSLayoutConstraint!
    @IBOutlet weak var winnerBottomH: NSLayoutConstraint!
    @IBOutlet weak var userBottomH: NSLayoutConstraint!
    @IBOutlet weak var winnerTopH: NSLayoutConstraint!
    @IBOutlet weak var levelWidth: NSLayoutConstraint!
    @IBOutlet weak var favBtn: UIButton!
    
    var model:ActorModel? {
        didSet{
            if model?.starType == 0 {
                winnerButton.isHidden = true
            } else if model?.starType == 1 {
                winnerButton.setTitle("周冠军", for: .normal)
            } else {
                winnerButton.setTitle("月冠军", for: .normal)
            }
            let defImage = UIImage(named: "default")
            backImageView.image = defImage
            userButton.setImage(defImage, for: .normal)
            
            if headType == 0 {
                nameLabel.text = "点击修改头像"
            } else {
                nameLabel.text = model?.nickName
                levelLabel.text = model?.integralName
            }
        }
    }
    //0-标示资料编辑 1-标示别人看到 2-其他
    var headType:Int! {
        didSet{
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        headType = -1
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        headType = 0
        setup()
    }
    
    func setup(){
        if levelLabel.text != nil {
            let size = levelLabel.text!.sizeString(font: UIFont.systemFont(ofSize: 13), maxWidth: AppWidth)
            levelWidth.constant = size.width+10
        }
        favBtn.layer.cornerRadius = 8
        favBtn.backgroundColor = UIColor(white: 0, alpha: 0.5)
        favBtn.clipsToBounds = true
        userButton.layer.cornerRadius = 30
        userButton.clipsToBounds = true
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        winnerButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        levelLabel.font = UIFont.systemFont(ofSize: 13)

        switch headType {
        case 0:
            levelLabel.isHidden = true
            nameLabel.text = "点击修改头像"
            nameCenterY.constant = 15
//            winnerBottomH.priority = UILayoutPriorityDefaultLow
            winnerTopH.priority = UILayoutPriorityDefaultHigh
            backBottomH.constant = 40
            userBottomH.constant = 30
        case 1:
            levelLabel.isHidden = false
            levelLabel.layer.cornerRadius = 10
            levelLabel.backgroundColor = skinColor
            levelLabel.clipsToBounds = true
            nameCenterY.constant = 0
//            winnerBottomH.priority = UILayoutPriorityDefaultHigh
            winnerTopH.priority = UILayoutPriorityDefaultLow
            backBottomH.constant = 0
            userBottomH.constant = -10
        case 2:
            levelLabel.isHidden = true
            nameCenterY.constant = 0
//            winnerBottomH.priority = UILayoutPriorityDefaultHigh
            winnerTopH.priority = UILayoutPriorityDefaultLow
        default:
            break
        }
    }
    
    @IBAction func userClick(_ sender: UIButton) {
//        publicDelegate?.dataHandler(type: "head", data: nil)
    }
    @IBAction func favClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "fav", data: nil)
    }
    

    @IBAction func jubaoClick(_ sender: Any) {
        self.loadHUD()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: {
            self.textHUD("举报成功")
        })
        
    }
    
}
