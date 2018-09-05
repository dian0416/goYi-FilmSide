//
//  ZZYCollectionHeaderView.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/7/30.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ZZYCollectionHeaderView: UICollectionReusableView {
    @IBOutlet var charectorBtn: UIButton!
    @IBOutlet var headlabel: UILabel!
    

    @IBAction func headerClick(_ sender: Any) {
        publicDelegate?.dataHandler(type: "headerClick", data: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
