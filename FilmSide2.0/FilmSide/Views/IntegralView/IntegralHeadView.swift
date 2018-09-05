//
//  IntegralHeadView.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/26.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class IntegralHeadView: UIView, YMCollectionViewDelegate {
    func collectionDidHeightItemAt(indexPath: IndexPath) {
        
    }
    func collectionUnhighlightItemAt(indexPath: IndexPath) {
        
    }

    @IBOutlet weak var view:UIView!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var integralLbl: UILabel!
    @IBOutlet weak var levelView: YMCollectionView!
    @IBOutlet weak var integralBtn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var levelViewH: NSLayoutConstraint!
    @IBOutlet weak var progressWidth: NSLayoutConstraint!
    private let row:CGFloat = 1
    private let colmun:CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view = Bundle.main.loadNibNamed("IntegralHeadView", owner: self, options: nil)?.first as? UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        levelLbl.layer.cornerRadius = 12.5
        levelLbl.layer.borderColor = UIColor.white.cgColor
        levelLbl.layer.borderWidth = 1
        userImgView.layer.cornerRadius = 40
        userImgView.clipsToBounds = true
        integralBtn.layer.cornerRadius = 17.5
        
        levelView.collectionViewLayout = YMFlowLayout()
        levelView.itemColumn = 8
        levelView.itemRow = row
        levelView.itemWidth = AppWidth/colmun
        levelView.itemHeight = AppWidth/colmun+10
        levelViewH.constant = AppWidth/colmun+10
        levelView.ymDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressWidth.constant = levelView.contentSize.width
        progress.progress = 4.5/8
    }
    
    @IBAction private func integralClick(_ sender: UIButton) {
        self.publicDelegate?.dataHandler(type: "look", data: nil)
    }
    
    internal func collectionViewCell(cell: ItemCell, indexPath: IndexPath) {
        let row = indexPath.row
        
        cell.textLabel.isHidden = true
        cell.imageView.image = UIImage(named: "level\(row)")
        cell.titleLabel.text = "\(500*(row+1))"
        cell.titleMaxH.constant = 20
        cell.titleTopSpace.constant = 0
        cell.imageViewTopSpace.constant = 5
        cell.titleBottomSpace.constant = 0
        cell.titleLabel.textColor = skinColor
        cell.imageView.clipsToBounds = true
    }
    
    internal func collectionDidSelectedItemAt(indexPath: IndexPath) {
        
    }
    
}
