//
//  ToolCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/23.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ToolCell: UITableViewCell {
    @IBOutlet weak var markBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        markBtn.setImage(UIImage(named: "mark"), for: .normal)
        forwardBtn.setImage(UIImage(named: "forward"), for: .normal)
        
        markBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        forwardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        reportBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    @IBAction func markClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: nil, data: nil)
    }
    
    @IBAction func forwardClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "forward", data: nil)
    }
    
    @IBAction func reportClick(_ sender: UIButton) {
        loadHUD()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
            self.textHUD("举报成功")
        }
    }
}
