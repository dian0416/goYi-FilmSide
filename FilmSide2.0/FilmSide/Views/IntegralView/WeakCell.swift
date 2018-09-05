//
//  WeakCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class WeakCell: UITableViewCell, YMCollectionViewDelegate {
    func collectionDidHeightItemAt(indexPath: IndexPath) {
        
    }
    
    func collectionUnhighlightItemAt(indexPath: IndexPath) {
        
    }

    var collectView: YMCollectionView!
    var column:CGFloat = 7
    var row:CGFloat = 1
    var dataModels:[(id:String?, title:String?, image:String?)]? {
        didSet{
            if dataModels != nil {
                collectView.itemColumn = CGFloat(dataModels!.count)
            } else {
                collectView.itemColumn = 0
            }
            
            collectView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
    }
    
    func setup(){
        collectView = YMCollectionView(frame: .zero, collectionViewLayout: YMFlowLayout())
        collectView.itemRow = row
        collectView.itemColumn = column
        collectView.itemWidth = (AppWidth-20)/column
        collectView.itemHeight = (AppWidth-20)/column+10
        collectView.backgroundColor = UIColor.white
        collectView.ymDelegate = self
        self.contentView.addSubview(collectView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsWidth = self.bounds.size.width
        let boundsHeight = self.bounds.size.height-10
        collectView.frame = CGRect(x: 10, y: 0, width: boundsWidth-20, height: boundsHeight)
    }
    
    func collectionViewCell(cell: ItemCell, indexPath: IndexPath) {
        let row = indexPath.row
        
        if let model = dataModels?[row] {
            cell.imageView.isHidden = true
            cell.titleLabel.text = model.title
            cell.titleLabel.font = UIFont.systemFont(ofSize: 13)
            cell.titleMaxH.constant = 20
            cell.titleTopSpace.constant = 0
            cell.imageViewTopSpace.constant = 5
            cell.titleBottomSpace.constant = 0
            cell.titleLabel.textColor = titleColor
            
            cell.textLabel.text = model.image
            cell.textLabel.textColor = skinColor
            cell.textLabel.clipsToBounds = true
            cell.textLabel.layer.borderWidth = 1
            cell.textLabel.layer.borderColor = skinColor.cgColor
            cell.layoutIfNeeded()
            cell.textLabel.layer.cornerRadius = cell.textLabel.frame.size.height/2
        }
    }
    
    func collectionDidSelectedItemAt(indexPath: IndexPath) {
        
    }
    
}
