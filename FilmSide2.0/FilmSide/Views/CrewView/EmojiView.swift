//
//  EmojiView.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/24.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class EmojiFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.itemSize = CGSize(width: AppWidth/7, height: AppWidth/7)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.layoutAttributesForItem(at: indexPath)?.copy() as! UICollectionViewLayoutAttributes
        let itemy = floor(CGFloat(indexPath.item/7))
        let itemx = indexPath.item%7
        attr.frame.origin.y = itemy * AppWidth/7
        attr.frame.origin.x = CGFloat(indexPath.section)*AppWidth+CGFloat(itemx)*AppWidth/7
        
        if Int(round(attr.frame.origin.x*10))%5 <= 5 {
            attr.frame.origin.x = CGFloat(Int(attr.frame.origin.x))
            attr.frame.size.width = attr.frame.size.width+1
        } else if Int(round(attr.frame.origin.x*10))%5 > 5 {
            attr.frame.origin.x = CGFloat(Int(attr.frame.origin.x))+1
            attr.frame.size.width = attr.frame.size.width
        }
        if Int(round(attr.frame.origin.y*10))%5 <= 5 {
            attr.frame.origin.y = CGFloat(Int(attr.frame.origin.y))
            attr.frame.size.height = attr.frame.size.height+1
        } else if Int(round(attr.frame.origin.y*10))%5 > 5 {
            attr.frame.origin.y = CGFloat(Int(attr.frame.origin.y))+1
            attr.frame.size.height = attr.frame.size.height
        }
        
        return attr
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

class EmojiView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    private let identifier = "item"
    //初始化视图
    private lazy var collectView:UICollectionView = { [weak self] in
        let rect = CGRect(x: 0, y: 0, width: AppWidth, height: AppWidth/7*3)
        let collect = UICollectionView(frame: rect, collectionViewLayout: EmojiFlowLayout())
        collect.showsHorizontalScrollIndicator = false
        collect.bounces = false
        collect.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self!.identifier)
        collect.dataSource = self!
        collect.delegate = self!
        collect.backgroundColor = UIColor.white
        collect.isPagingEnabled = true
        
        return collect
    }()
    private lazy var pageContrl: UIPageControl = {
        let control = UIPageControl(frame: CGRect(x: 0, y: AppWidth/7*3, width: AppWidth, height: AppWidth/7))
        control.pageIndicatorTintColor = lineColor
        control.currentPageIndicatorTintColor = skinColor
        control.currentPage = 0
        
        return control
    }()
    private lazy var sendBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: AppWidth-60, y: AppWidth/7*3+(AppWidth/7-30)/2, width: 50, height: 30))
        btn.setTitle("发送", for: .normal)
        btn.layer.cornerRadius = 5.0
        btn.backgroundColor = backColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(titleColor, for: .normal)
        btn.addTarget(self, action: #selector(btnClcik), for: .touchUpInside)
        
        return btn
    }()
    private lazy var emojiArray = emojiPics
    private lazy var textArray = emojiTexts
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(collectView)
        self.addSubview(pageContrl)
        self.addSubview(sendBtn)
        
        let count = (emojiArray.count/21+emojiArray.count)/21
        for i in 0..<count {
            emojiArray.insert("face_delete", at: (i+1)*21-1)
            textArray.insert("delete", at: (i+1)*21-1)
            print(i, Int(emojiArray.count/21))
        }
        
        if emojiArray[emojiArray.count-1] != "face_delete" && emojiArray.count%21 != 0  {
            for _ in 0..<(21-emojiArray.count%21)-1 {
                emojiArray.insert("", at: emojiArray.count)
                textArray.insert("", at: textArray.count)
            }
            emojiArray.insert("face_delete", at: emojiArray.count)
            textArray.insert("delete", at: textArray.count)
        }
        pageContrl.numberOfPages = Int(ceil(CGFloat(emojiArray.count)/21))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil(CGFloat(emojiArray.count)/21))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section*21 < emojiArray.count {
            return 21
        }
        return emojiArray.count%21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        cell.isHighlighted = true
        
        var imgView = cell.contentView.viewWithTag(100) as? UIImageView
        if imgView == nil {
            imgView = UIImageView(frame: CGRect(x: (AppWidth/7-30)/2, y: (AppWidth/7-30)/2, width: 30, height: 30))
            imgView?.tag = 100
            imgView?.contentMode = .scaleAspectFit
            
            cell.contentView.addSubview(imgView!)
        }
        
        if section*21+row < emojiArray.count {
            let text = emojiArray[section*21+row]
            if !text.isEmpty {
                imgView?.image = UIImage(named: text)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let emojiStr = textArray[section*21+row]
        if emojiStr == "delete" {
            self.publicDelegate?.dataHandler(type: "delete", data: "")
        } else if emojiStr.length() > 0 {
            self.publicDelegate?.dataHandler(type: "emoji", data: emojiStr)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageContrl.currentPage = self.collectView.indexPath(for: self.collectView.visibleCells.last!)!.section
    }
    
    func btnClcik(){
        self.publicDelegate?.dataHandler(type: "comment_send", data: nil)
    }

}
