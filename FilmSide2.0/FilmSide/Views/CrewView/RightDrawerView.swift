//
//  RightDrawerView.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/9/3.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class RightDrawerView: UIView {
    @IBOutlet var movieName: UILabel!
    
    @IBOutlet var headImageview: UIImageView!
    @IBOutlet var biographyLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var backBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension RightDrawerView {
    class func rightDrawerView() -> RightDrawerView {
        return Bundle.main.loadNibNamed("RightDrawerView", owner: nil, options: nil)?.first as! RightDrawerView
    }
}
