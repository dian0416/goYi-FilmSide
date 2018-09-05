//
//  RangeViewCell.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/5/14.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class RangeViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftField: UITextField!
    @IBOutlet weak var rightField: UITextField!
    @IBOutlet weak var descLabel: UILabel!
    var addIndex:Int = 0
    var indexPath:IndexPath? {
        didSet{
            let row = indexPath?.row
            
            if row! == 3+addIndex {
                leftField.placeholder = "最小年龄"
                rightField.placeholder = "最大年龄"
            } else if row! == 4+addIndex {
                leftField.placeholder = "最小身高"
                rightField.placeholder = "最大身高"
            } else if row! == 5+addIndex {
                leftField.placeholder = "最小体重"
                rightField.placeholder = "最大体重"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        leftField.font = UIFont.systemFont(ofSize: 15)
        leftField.textColor = subColor
        rightField.textColor = subColor
        leftField.delegate = self
        descLabel.font = UIFont.systemFont(ofSize: 15)
        rightField.font = UIFont.systemFont(ofSize: 15)
        rightField.delegate = self
        self.selectionStyle = .none
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideKeyboard()
        
        if textField.text?.length() > 0 {
            if textField == leftField {
                publicDelegate?.dataHandler(type: indexPath, data: (0, textField.text))
            } else {
                publicDelegate?.dataHandler(type: indexPath, data: (1, textField.text))
            }
        }
    }
    
}
