//
//  UnionFlowLayout.swift
//  SwiftDemo
//
//  Created by 米翊米 on 2017/3/28.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class YMFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElements(in: rect)
        let attrs = Array(array!)
        for attr in attrs {
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
        }
        
        return array
    }
    
}
