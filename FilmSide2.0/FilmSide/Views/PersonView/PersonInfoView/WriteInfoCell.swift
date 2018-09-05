//
//  WriteInfoCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class WriteInfoCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var texitField: UITextField!
    var indexPath:IndexPath!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        texitField.delegate = self
        self.separatorZero(leftInset: 10)
        self.selectionStyle = .none
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        texitField.font = UIFont.systemFont(ofSize: 15)
        descLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideKeyboard()
        if textField.markedTextRange == nil {
            publicDelegate?.dataHandler(type: indexPath, data: textField.text!)
        }
    }
    
}
