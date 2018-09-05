//
//  UnionCollectionView.swift
//  SwiftDemo
//
//  Created by 米翊米 on 2017/3/28.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

protocol YMCollectionViewDelegate {
    func collectionViewCell(cell: ItemCell, indexPath: IndexPath)
    func collectionDidSelectedItemAt(indexPath: IndexPath)
    func collectionDidHeightItemAt(indexPath: IndexPath)
    func collectionUnhighlightItemAt(indexPath: IndexPath)
}

class YMCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //私有属性
    private let identifier = "cell"
    
    //外部引用属性
    var itemRow:CGFloat = 0
    var itemColumn:CGFloat = 0
    var itemWidth:CGFloat = 0
    var itemHeight:CGFloat = 0
    var ymDelegate:YMCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    func setup(){
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.register(UINib(nibName: "ItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(itemRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(itemColumn)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ItemCell
        ymDelegate?.collectionViewCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ymDelegate?.collectionDidSelectedItemAt(indexPath: indexPath)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0, 0, 0, 0)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        ymDelegate?.collectionDidHeightItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        ymDelegate?.collectionUnhighlightItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
}
