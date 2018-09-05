//
//  LLCycleScrollViewCell.swift
//  LLCycleScrollView
//
//  Created by LvJianfeng on 2016/11/22.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

import UIKit

class LLCycleScrollViewCell: UICollectionViewCell {
    
    // 标题
    var title: String = "" {
        didSet {
            titleLabel.text = "\(title)"
            
            if title.count > 0 {
                titleBackView.isHidden = false
                titleLabel.isHidden = false
                winnerTitleLabel.isHidden = false
            }else{
                titleBackView.isHidden = true
                titleLabel.isHidden = true
            }
        }
    }
    // 冠军
    var winnerTitle:String = ""{
        didSet{
            winnerTitleLabel.text = "\(winnerTitle)"
            if title.count > 0 {
                titleBackView.isHidden = false
                titleLabel.isHidden = false
                winnerTitleLabel.isHidden = false
            }else{
                titleBackView.isHidden = true
                titleLabel.isHidden = true
            }
        }
        
    }
    
    // 标题颜色
    var titleLabelTextColor: UIColor = UIColor.white {
        didSet {
            titleLabel.textColor = titleLabelTextColor
        }
    }
    
    // 标题字体
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    // 文本行数
    var titleLines: NSInteger = 2 {
        didSet {
            titleLabel.numberOfLines = titleLines
        }
    }
    
    // 标题文本x轴间距
    var titleLabelLeading: CGFloat = 15 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // 标题背景色
    var titleBackViewBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            titleBackView.backgroundColor = titleBackViewBackgroundColor
        }
    }
    
    var titleBackView: UIView!
    
    // 标题Label高度
    var titleLabelHeight: CGFloat! = 56 {
        didSet {
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupLabelBackView()
        setupTitleLabel()
    }
    
    // 图片
    var imageView: UIImageView!
    fileprivate var titleLabel: UILabel!
    fileprivate var winnerTitleLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup ImageView
    fileprivate func setupImageView() {
        imageView = UIImageView.init()
        // 默认模式
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        self.contentView.addSubview(imageView)
    }
    
    // Setup Label BackView
    fileprivate func setupLabelBackView() {
        titleBackView = UIView.init()
        titleBackView.backgroundColor = titleBackViewBackgroundColor
        titleBackView.isHidden = true
//        self.contentView.addSubview(titleBackView)
    }
    
    // Setup Title
    fileprivate func setupTitleLabel() {
        titleLabel = UILabel.init()
        titleLabel.isHidden = true
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = titleLines
        titleLabel.font = titleFont
        titleLabel.backgroundColor = UIColor.clear
        self.contentView.addSubview(titleLabel)
        
        winnerTitleLabel = UILabel.init()
        winnerTitleLabel.isHidden = true
        winnerTitleLabel.textColor = UIColor.white
        winnerTitleLabel.numberOfLines = titleLines
        winnerTitleLabel.font = titleFont
        winnerTitleLabel.backgroundColor = UIColor.clear
        self.contentView.addSubview(winnerTitleLabel)
    }
    
    // MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
//        titleBackView.frame = CGRect.init(x: 0, y: self.ll_h - titleLabelHeight, width: self.ll_w, height: titleLabelHeight)
        titleLabel.frame = CGRect.init(x: titleLabelLeading, y: self.ll_h - titleLabelHeight - 30, width: self.ll_w - titleLabelLeading - 5, height: titleLabelHeight)
        winnerTitleLabel.frame = CGRect.init(x: titleLabelLeading, y: self.ll_h - titleLabelHeight, width: self.ll_w - titleLabelLeading - 5, height: titleLabelHeight)
    }
}
