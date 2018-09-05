//
//  BrowseImageView.swift
//  Sound
//
//  Created by 米翊米 on 16/3/7.
//  Copyright © 2016年 米翊米. All rights reserved.
//

import UIKit
import Photos

protocol BrowseImageViewDlegate:NSObjectProtocol{
    func delClick(index:NSInteger)
    func hidenView()
}

class BrowseImageView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate{

    var dataArray = [AnyObject]()
    var toolView:UIButton!
    var index:NSInteger!
    var browDelegate:BrowseImageViewDlegate!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let browLayout = UICollectionViewFlowLayout()
        browLayout.itemSize = CGSize(width: AppWidth, height: AppHeight)
        browLayout.scrollDirection = .horizontal
        browLayout.minimumInteritemSpacing = 0
        browLayout.minimumLineSpacing = 0
        browLayout.sectionInset = UIEdgeInsets.zero
        super.init(frame: frame, collectionViewLayout: browLayout)
        
        self.dataSource = self
        self.delegate = self
        self.isPagingEnabled = true
        self.backgroundColor = backColor
        self.backgroundColor = titleColor
        //注册Cell，必须要有
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "browse")
        
        toolView = UIButton()
        toolView.frame = CGRect(x: AppWidth-50, y: 0, width: 40, height: 40)
        toolView.setBackgroundImage(UIImage(named: "bar_delete"), for: .normal)
        toolView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        toolView.setTitleColor(UIColor.white, for: .normal)
        toolView.addTarget(self, action: #selector(BrowseImageView.deleteClick), for: .touchUpInside)
        toolView.isHidden = true
        self.addSubview(toolView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CollectionViewcell个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    //定义展示的Section的个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 获取单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browse", for: indexPath as IndexPath)
        if (cell.backgroundView == nil) {//防止多次创建
            let imageView = UIImageView()
            cell.backgroundView = imageView;
        }
        
        (cell.backgroundView as! UIImageView).contentMode = .scaleAspectFit
        (cell.backgroundView as! UIImageView).clipsToBounds = true
        if dataArray[indexPath.item].isKind(of: ImageModel.classForCoder()) {
            //取高清图
            let myAsset = dataArray[indexPath.item] as! ImageModel
            PHImageManager.default().requestImage(for: myAsset.asset!, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                if image != nil {
                    (cell.backgroundView as! UIImageView).image = image
                }
            })
        }else if dataArray[indexPath.item].isKind(of: UIImage.classForCoder()) {
            (cell.backgroundView as! UIImageView).image = dataArray[indexPath.item] as? UIImage
        }else if let image:String = dataArray[indexPath.item] as? String{
            (cell.backgroundView as! UIImageView).loadImage(image)
        }
    
        return cell
    }
    
    // 单元格点击响应
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.removeFromSuperview()
        if browDelegate != nil {
            self.browDelegate.hidenView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        index = indexPath.item
        toolView.frame = CGRect(x: AppWidth*CGFloat(index+1)-50, y: 0, width: 40, height: 40)
    }
    
    func deleteClick(){
        if index < dataArray.count{
            self.browDelegate.delClick(index: index)
            dataArray.remove(at: index)
            self.reloadData()
            if dataArray.count == 0 {
                self.removeFromSuperview()
                self.browDelegate.hidenView()
            }
        }else{
            self.removeFromSuperview()
            if browDelegate != nil {
                self.browDelegate.hidenView()
            }
        }
    }
    
}
