//
//  ProductCategoryCell.swift
//  WineDealer
//
//  Created by 米翊米 on 2016/7/16.
//  Copyright © 2016年 🐨🐨🐨. All rights reserved.
//

import UIKit

class BoxCell: UITableViewCell, YMCollectionViewDelegate {
    var collectView:YMCollectionView!
    var column:CGFloat = 4
    var row:CGFloat = 1
    //0-广场 1-积分
    var sourceType = 0
    var dataModels: [(id:String?, title:String?, image:String?)]? {
        didSet{
            if dataModels?.count > 0 {
                collectView.itemColumn = CGFloat(dataModels!.count)
            } else {
                collectView.itemColumn = 0
            }
            let layout = (collectView.collectionViewLayout as! UICollectionViewFlowLayout)
            if sourceType == 0 {
                collectView.itemWidth = (AppWidth-41)/column
                collectView.itemHeight = ((AppWidth-40)/9*4)/2
                layout.minimumInteritemSpacing = 10
                layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10)
            } else {
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                layout.sectionInset = UIEdgeInsets.zero
                collectView.itemWidth = AppWidth/column
                collectView.itemHeight = AppWidth/column-10
            }
            collectView.itemRow = row
            self.collectView.reloadData()
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
        //设置分割线左对齐
        self.separatorZero()
        self.selectionStyle = .none
        
        if sourceType == 1 {
            collectView = YMCollectionView(frame: .zero, collectionViewLayout: YMFlowLayout())
        } else {
            collectView = YMCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        }
        collectView.delaysContentTouches = false
        collectView.ymDelegate = self
        collectView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(collectView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectView.frame = self.bounds
    }
    
    func collectionViewCell(cell: ItemCell, indexPath: IndexPath) {
        let row = indexPath.row
        
        if let model = dataModels?[row] {
            cell.titleLabel.text = model.title
            if sourceType == 0 {
                cell.backgroundImageView.contentMode = .scaleAspectFill
                cell.imageView.image = nil
                if model.image?.length() > 0 {
                    cell.backgroundImageView.loadImage(model.image)
                } else {
                    cell.backgroundImageView.image = UIImage(named: "forwardback")
                }
                cell.titleBottomSpace.constant = 0
                cell.titleMaxH.constant = 20
                cell.titleMinH.constant = 20
                cell.titleLabel.textAlignment = .left
                cell.titleLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
                cell.titleLabel.textColor = UIColor.white
                cell.titleLabel.font = UIFont.systemFont(ofSize: 13)
            } else {
                cell.imageViewTopSpace.constant = 10
                cell.titleBottomSpace.constant = 10
                if AppHeight > 667 {
                    cell.imageViewTopSpace.constant = 17
                    cell.titleBottomSpace.constant = 17
                }
                if let image = model.image {
                    cell.imageView.image = UIImage(named: image)
                }
                cell.titleMaxH.constant = 20
                cell.titleTopSpace.constant = 10
                cell.titleLabel.font = UIFont.systemFont(ofSize: 12)
            }
        }
    }
    
    func collectionDidSelectedItemAt(indexPath: IndexPath) {
        let row = indexPath.row
        let model = dataModels?[row]
        
        if sourceType == 0 {
            if let id = model?.id {
                publicDelegate?.dataHandler(type: "hot", data: Int(id))
            }
        } else {
            publicDelegate?.dataHandler(type: "function", data:row)
        }
    }
    
    func collectionDidHeightItemAt(indexPath: IndexPath) {
        if sourceType == 1 {
            let images = ["actorred", "squarered", "alternativered", "favoritered"]
            let cell = collectView.cellForItem(at: indexPath) as? ItemCell
            cell?.imageView.image = UIImage(named: images[indexPath.row])
            cell?.titleLabel.textColor = skinColor
        }
    }
    
    func collectionUnhighlightItemAt(indexPath: IndexPath) {
        if sourceType == 1 {
            let images = ["actorred", "square", "alternative", "favorite"]
            let cell = collectView.cellForItem(at: indexPath) as? ItemCell
            cell?.imageView.image = UIImage(named: images[indexPath.row])
            cell?.titleLabel.textColor = titleColor
        }
    }
    
    func collectionNumberOfsection() -> Int {
        if dataModels != nil {
            return dataModels!.count
        }
        return 0
    }
    
}
