//
//  TwoTextFieldCell.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class TwoTextFieldCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftFiled: UITextField!
    @IBOutlet weak var rightField: UITextField!
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = subColor
        leftFiled.layer.cornerRadius = 15
        rightField.layer.cornerRadius = 15
        leftFiled.delegate = self
        rightField.delegate = self
        leftFiled.layer.borderWidth = 0.5
        leftFiled.textColor = subColor
        rightField.textColor = subColor
        titleLabel.textColor = subColor
        leftFiled.layer.borderColor = subColor.cgColor
        rightField.layer.borderWidth = 0.5
        rightField.layer.borderColor = subColor.cgColor
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        leftFiled.font = UIFont.systemFont(ofSize: 15)
        rightField.font = UIFont.systemFont(ofSize: 15)
        leftFiled.delegate = self
        rightField.delegate = self
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.markedTextRange == nil {
            if textField.text?.length() > 5 {
                textHUD("最多可输入5个字符")
                textField.text = ""
                return
            }
            var tmp = leftFiled.text
            if tmp != nil && rightField.text != nil {
                tmp! += ",\(rightField.text!)"
            } else {
                tmp! = ",\(rightField.text!)"
            }
            if textField == leftFiled {
                let data = (0, textField.text)
                publicDelegate?.dataHandler(type: indexPath, data: data)
            } else {
                let data = (1, textField.text)
                publicDelegate?.dataHandler(type: indexPath, data: data)
            }
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField.markedTextRange == nil {
//            if textField.text?.length() > 5 {
//                textHUD("最多可输入5个字符")
//                textField.text = ""
//                return true
//            }
//            var tmp = leftFiled.text
//            if tmp != nil && rightField.text != nil {
//                tmp! += ",\(rightField.text!)"
//            } else {
//                tmp! = ",\(rightField.text!)"
//            }
//            if textField == leftFiled {
//                let data = (0, textField.text)
//                publicDelegate?.dataHandler(type: indexPath, data: data)
//            } else {
//                let data = (1, textField.text)
//                publicDelegate?.dataHandler(type: indexPath, data: data)
//            }
//        }
//        
//        return true
//    }
}
 
