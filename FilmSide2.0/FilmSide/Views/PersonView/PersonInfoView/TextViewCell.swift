//
//  TextViewCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/2.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 15)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.length() > 0 {
            placeLabel.isHidden = true
        } else {
            placeLabel.isHidden = false
        }
        if textView.markedTextRange == nil {
            publicDelegate?.dataHandler(type: "text", data: textView.text)
        }
    }
    
}
