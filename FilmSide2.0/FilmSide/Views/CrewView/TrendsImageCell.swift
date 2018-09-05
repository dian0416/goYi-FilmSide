//
//  TrendsImageCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/22.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class TrendsImageCell: UITableViewCell {
    private let space:CGFloat = 10
    private let cellHeight:CGFloat = 50
    
    lazy var tentLbl:UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: AppWidth-20, height: 20))
        label.textColor = titleColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "借记卡撒时间到了水立方的时刻v"
        
        return label
    }()
    lazy var btnArray: [UIButton] = {[weak self] in
        var btns = [UIButton]()
        let width = (AppWidth-4*self!.space)/3
        let preY = self!.tentLbl.frame.origin.y+30
        var offsetX = self!.space
        var offsetY = preY
        
        for i in 0..<9 {
            if i%3 == 0 {
                offsetX = self!.space
                offsetY = preY+ceil(CGFloat(i)/3)*(width+self!.space)
            }else{
                offsetX += width+self!.space
            }
            let btn = UIButton(frame: CGRect(x: offsetX, y: offsetY, width: width, height: width))
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.tag = 100+i
            btn.backgroundColor = skinColor
            btn.addTarget(self!, action: #selector(btnClick(sender:)), for: .touchUpInside)
            
            btns.append(btn)
            self!.addSubview(btn)
        }
        
        return btns
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorZero()
        self.separatorHidden()
        
        self.addSubview(tentLbl)
        btnArray[0].titleLabel?.textColor = skinColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnClick(sender: UIButton){
        
    }

}
