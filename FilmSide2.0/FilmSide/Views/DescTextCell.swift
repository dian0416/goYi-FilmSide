//
//  DescTextCell.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class DescTextCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLeding: NSLayoutConstraint!
    @IBOutlet weak var textLeft: NSLayoutConstraint!
    @IBOutlet weak var textTop: NSLayoutConstraint!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.separatorZero()
        self.selectionStyle = .none
        textView.textAlignment = .natural
        textView.textColor = subColor
        textView.textContainerInset = UIEdgeInsetsMake(0, -3, 0, 0)
        textView.font = UIFont.systemFont(ofSize: 15)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.font = UIFont.boldSystemFont(ofSize: 15)
        descLabel.textColor = subColor
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.markedTextRange == nil {
            publicDelegate?.dataHandler(type: nil, data: textView.text)
        }
    }
    
}
