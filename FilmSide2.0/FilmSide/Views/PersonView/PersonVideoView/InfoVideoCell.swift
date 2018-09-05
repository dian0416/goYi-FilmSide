//
//  InfoVideoCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/4.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class InfoVideoCell: UITableViewCell {
    @IBOutlet weak var videoImgView: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        separatorZero()
        playBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    @IBAction func closeClick(_ sender: UIButton) {
        let tag = sender.tag - 100
        publicDelegate?.dataHandler(type: "video_close", data: tag)
    }
    
    @IBAction func playClick(_ sender: UIButton) {
        let tag = closeBtn.tag - 100
        publicDelegate?.dataHandler(type: "video_play", data: tag)
    }
}
