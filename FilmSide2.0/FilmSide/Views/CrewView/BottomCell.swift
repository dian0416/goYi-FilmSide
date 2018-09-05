//
//  BottomCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/10.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class BottomCell: UITableViewCell {
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    var model:InvitionModel? {
        didSet{
            shareBtn.setTitle("0", for: .normal)
            if let word = model?.forward {
                shareBtn.setTitle("\(word)", for: .normal)
            }
            agreeBtn.setTitle("0", for: .normal)
            if let word = model?.praise {
                agreeBtn.setTitle("\(word)", for: .normal)
            }
            commentBtn.setTitle("0", for: .normal)
            if let word = model?.commentCount {
                commentBtn.setTitle("\(word)", for: .normal)
            }
            if model?.praiseType > 0 {
                agreeBtn.isSelected = true
                agreeBtn.isUserInteractionEnabled = false
            } else {
                agreeBtn.isSelected = false
                agreeBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        agreeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commentBtn.isUserInteractionEnabled = false
        agreeBtn.setImage(UIImage(named: "agreengray"), for: .normal)
        agreeBtn.setImage(UIImage(named: "agreenred"), for: .selected)
        reportBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func tentClick(_ sender: UIButton) {
        
    }
    
    @IBAction func reportClick(_ sender: UIButton) {
        loadHUD()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) { 
            self.textHUD("举报成功")
        }
    }
    
    @IBAction func shareClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "forward", data: model)
    }
    
    @IBAction func agreeClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "agree", data: model?.id)
    }
}
