//
//  InfoWorksCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/8.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class InfoWorksCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var personLabel: UILabel!
    var index:IndexPath!
    var model:UserWorkModel? {
        didSet {
            nameLabel.text = "【\(model!.movieName!)】饰演角色：\(model!.roleName!)"
            if let director = model?.directorName {
                personLabel.text = "导演：\(director)"
                if let cooperationActor = model?.cooperationActor {
                    personLabel.text = "导演：\(director), \(cooperationActor)"
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.numberOfLines = 0
        personLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        personLabel.font = UIFont.systemFont(ofSize: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "editwork", data: index)
    }
}
