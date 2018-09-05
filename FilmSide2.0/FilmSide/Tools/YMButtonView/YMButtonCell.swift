//
//  YMButtonCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/30.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class YMButtonCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textLeading: NSLayoutConstraint!
    @IBOutlet weak var textTop: NSLayoutConstraint!
    var selectColor = UIColor.red
    var defaultColor = UIColor.lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func setup(){
        self.layer.borderWidth = 1
        self.isSelected = false
        
        textTop.constant = 2
        textLeading.constant = 5
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.layer.cornerRadius = self.frame.size.height/2
//    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                self.textLabel.textColor = selectColor
                self.layer.borderColor = selectColor.cgColor
                
            } else {
                self.textLabel.textColor = defaultColor
                self.layer.borderColor = defaultColor.cgColor
            }
        }
    }
    
}
