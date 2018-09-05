//
//  UnionFlowLayout.swift
//  SwiftDemo
//
//  Created by 米翊米 on 2017/3/28.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class YMButtonFlowLayout: UICollectionViewFlowLayout{
    private lazy var attrArray: [IndexPath:UICollectionViewLayoutAttributes] = {
        return [IndexPath: UICollectionViewLayoutAttributes]()
    }()
    
    override init() {
        super.init()
        
        self.scrollDirection = .vertical
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        self.headerReferenceSize = CGSize(width: AppWidth, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = indexPath.section
        let item = indexPath.item
        
        let curAttr = super.layoutAttributesForItem(at: indexPath)
        var offsetX = self.sectionInset.left
        let width = curAttr?.frame.size.width
        let height = curAttr?.frame.size.height
        var offsetY = self.sectionInset.top
        if item > 0 {
            let prePath = IndexPath(item: item-1, section: section)
            let preAttr = attrArray[prePath]!
            offsetX = preAttr.frame.origin.x+preAttr.frame.size.width+self.minimumInteritemSpacing
            offsetY = preAttr.frame.origin.y
            if offsetX + width! + self.minimumInteritemSpacing > self.collectionView!.frame.size.width {
                offsetX = self.sectionInset.left
                offsetY = preAttr.frame.origin.y+preAttr.frame.size.height+self.minimumLineSpacing
            }
            curAttr?.frame = CGRect(x: offsetX, y: offsetY, width: width!, height: height!)
        }
        
        attrArray[indexPath] = curAttr
        return curAttr
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = super.layoutAttributesForElements(in: rect)
        
        for attr in attrs! {
            if attr.representedElementCategory == .cell && attr.frame.intersects(rect){
                
                let curAttr = self.layoutAttributesForItem(at: attr.indexPath)
                
                attr.frame = curAttr!.frame
            }
        }
        
        return attrs
    }
    
}
