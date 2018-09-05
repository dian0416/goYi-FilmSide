//
//  CardHeadView.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/10.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class CardHeadView: UIView {
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var userImgViw: UIImageView!
    @IBOutlet weak var winnerBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view = Bundle.main.loadNibNamed("CardHeadView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        userImgViw.layer.cornerRadius = 30
        userImgViw.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
