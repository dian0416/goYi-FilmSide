//
//  TrendsBottomCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/22.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class TrendsBottomCell: UITableViewCell {
    var space:CGFloat = 10
    var cellHeight:CGFloat = (AppWidth-160)/6+20
    lazy var agreeBtn:UIButton = { [weak self] in
        let btn = UIButton(frame: CGRect(x: 10, y: self!.cellHeight/2-15, width: 70, height: 30))
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = lineColor
        btn.layer.cornerRadius = 15
        btn.setImage(UIImage(named: "agree"), for: .normal)
        btn.setImage(UIImage(named: "agreered"), for: .selected)
        btn.setImage(UIImage(named: "agreered"), for: .highlighted)
        btn.setTitleColor(subColor, for: .normal)
        btn.setTitleColor(skinColor, for: .selected)
        btn.setTitleColor(skinColor, for: .highlighted)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        btn.addTarget(self!, action: #selector(agreeClick), for: .touchUpInside)
        
        return btn
    }()
    lazy var btnArray: [UIButton] = {[weak self] in
        var btns = [UIButton]()
        let width = (AppWidth-100-6*self!.space)/6
        var offsetX = self!.agreeBtn.frame.width+20
        let offsetY = (self!.cellHeight-width)/2
        
        for i in 0..<6 {
            let btn = UIButton(frame: CGRect(x: offsetX, y: offsetY, width: width, height: width))
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.layer.cornerRadius = width/2
            btn.tag = 100+i
            btn.clipsToBounds = true
            btn.imageView?.contentMode = .scaleAspectFill
            btn.addTarget(self!, action: #selector(btnClick(sender:)), for: .touchUpInside)
            
            offsetX += width+self!.space
            btns.append(btn)
            self!.addSubview(btn)
        }
        
        return btns
    }()
    var models:[AgreeModel]? {
        didSet{
            if models?.count > 0 {
                for i in 0..<btnArray.count {
                    btnArray[i].isUserInteractionEnabled = false
                    if i < models?.count && models?.count < 5 {
                        let btn = btnArray[i]
                        btn.loadImage(models![i].headImg)
                    } else if i < models!.count + 1 {
                        btnArray[i].loadImage(placeholder: UIImage(named: "more"))
                    } else {
                        btnArray[i].loadImage(placeholder: nil)
                    }
                }
            } else {
                for i in 0..<btnArray.count {
                    btnArray[i].isUserInteractionEnabled = false
                    btnArray[i].loadImage(placeholder: nil)
                }
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(agreeBtn)
        self.selectionStyle = .none
        self.separatorZero()
        agreeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func agreeClick(){
        publicDelegate?.dataHandler(type: "agree", data: nil)
    }
    
    func btnClick(sender: UIButton){
//        publicDelegate?.dataHandler(type: "agree", data: nil)
    }
    
}
