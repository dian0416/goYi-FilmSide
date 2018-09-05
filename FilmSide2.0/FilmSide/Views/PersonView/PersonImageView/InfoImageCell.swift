//
//  InfoImageCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/4.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class InfoImageCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ControlDelegate {
    private var collectView: UICollectionView!
    private let identifier = "cell"
    private let identifierhead = "head"
    var isShow = false
    var imageAarry:[(url:String?, image:UIImage?)]? {
        didSet{
            if !isShow {
                if imageAarry == nil {
                    imageAarry = [(nil, UIImage(named: "addimage")!)]
                } else {
                    imageAarry?.insert((nil, UIImage(named: "addimage")!), at: 0)
                }
            }
            self.collectView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
    }
    
    func setup(){
        let layout = ImageLayout()
        collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectView.delegate = self
        collectView.dataSource = self
        collectView.backgroundColor = UIColor.white
        collectView.showsVerticalScrollIndicator = false
        collectView.showsHorizontalScrollIndicator = false
        collectView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        collectView.bounces = true
        collectView.frame = self.bounds
        self.contentView.addSubview(collectView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectView.frame = self.bounds
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageAarry != nil {
            return imageAarry!.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ImageViewCell
        cell.closeBtn.tag = 100+item
        cell.publicDelegate = self
        
        if let image = imageAarry?[item].image {
            cell.imageView.loadImage(placeholder: image)
        } else if let urlstring = imageAarry?[item].url {
            cell.imageView.loadImage(urlstring)
        } else {
            cell.imageView.image = UIImage(named: "default")
        }
        
        if isShow {
            cell.closeBtn.isHidden = true
        } else {
            if item == 0 && imageAarry?.count < 10 {
                cell.closeBtn.isHidden = true
            } else {
                cell.closeBtn.isHidden = false
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = indexPath.item
        
        let width = (AppWidth-30)/2
        if item < 2 {
            return CGSize(width: width, height: width/3*2)
        } else if item%2 == 0 {
            return CGSize(width: width, height: width/3*2)
        } else {
            return CGSize(width: width, height: width/10*7)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        if imageAarry!.count == 10 {
            publicDelegate?.dataHandler(type: "showimage", data: item-1)
        } else if item == 0 && !isShow {
            publicDelegate?.dataHandler(type: "addimage", data: nil)
        } else {
            var index = item
            if !isShow {
                index = item-1
            }
            publicDelegate?.dataHandler(type: "showimage", data: index)
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.layoutIfNeeded()
        self.collectView.reloadData()
        
        var size = collectView.collectionViewLayout.collectionViewContentSize
        size.height += 1
        return size
    }

    func dataHandler(type: Any?, data: Any?) {
        let tag = data as! Int
        
        publicDelegate?.dataHandler(type: "close", data: tag-1)
    }

}
