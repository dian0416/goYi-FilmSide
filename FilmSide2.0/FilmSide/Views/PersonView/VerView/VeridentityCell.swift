//
//  VeridentityCell.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/17.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class VeridentityCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cardField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameField.delegate = self
        cardField.delegate = self
        nameField.font = UIFont.systemFont(ofSize: 15)
        cardField.font = UIFont.systemFont(ofSize: 15)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideKeyboard()
        
        if textField == nameField {
            publicDelegate?.dataHandler(type: "name", data: textField.text)
        } else {
            publicDelegate?.dataHandler(type: "card", data: textField.text)
        }
    }
}
