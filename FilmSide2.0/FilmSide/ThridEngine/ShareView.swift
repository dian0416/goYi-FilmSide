//
//  ShareView.swift
//  SwiftDemo
//
//  Created by 米翊米 on 2017/4/5.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ShareHeadView: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = subColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.frame = CGRect(x: 0, y: 40, width: AppWidth, height: 20)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShareView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    private let identifier = "cell"
    private let identifierHead = "head"
    private let platforms:[UMSocialPlatformType] = [.wechatSession, .wechatTimeLine, .wechatTimeLine]
    private lazy var dataModels: [(id:Int, title:String, image:String)] = { [weak self] in
        var models = [(id:Int, title:String, image:String)]()
        if UMSocialManager.default().isInstall(.wechatSession) {
            let type = UMSocialPlatformType.userDefine_Begin.rawValue + self!.platforms[0].rawValue
            UMSocialUIManager.addCustomPlatformWithoutFilted(UMSocialPlatformType(rawValue: type)!, withPlatformIcon: UIImage(named: "wechat"), withPlatformName: "微信")
            models.append((id:type, title:"微信", image:"wechat"))
        }
        if UMSocialManager.default().isInstall(.sina) {
            let type = UMSocialPlatformType.userDefine_Begin.rawValue + self!.platforms[1].rawValue
            UMSocialUIManager.addCustomPlatformWithoutFilted(UMSocialPlatformType(rawValue: type)!, withPlatformIcon: UIImage(named: "sina"), withPlatformName: "新浪")
            models.append((id:type, title:"新浪", image:"sina"))
        }
        if UMSocialManager.default().isInstall(.QQ) {
            let type = UMSocialPlatformType.userDefine_Begin.rawValue + self!.platforms[2].rawValue
            UMSocialUIManager.addCustomPlatformWithoutFilted(UMSocialPlatformType(rawValue: type)!, withPlatformIcon: UIImage(named: "pyq"), withPlatformName: "朋友圈")
            models.append((id:type, title:"朋友圈", image:"pyq"))
        }
        if models.count == 0 {
            self!.isHidden = true
        }
        return models
    }()
//    private let headerheight:CGFloat = 115
    private let sizeHeight:CGFloat = 130
    private let sizeWidth:CGFloat = 80
    private lazy var collectView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        let space = (AppWidth-CGFloat(self!.dataModels.count)*self!.sizeWidth)/CGFloat(self!.dataModels.count+1)
        layout.minimumInteritemSpacing = space
        layout.sectionInset = UIEdgeInsetsMake(0, space-1, 0, space-1)
//        layout.headerReferenceSize = CGSize(width: AppWidth, height: self!.headerheight)
        layout.itemSize = CGSize(width: self!.sizeWidth, height: self!.sizeHeight)
        
        let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect.delegate = self!
        collect.dataSource = self!
        collect.showsVerticalScrollIndicator = false
        collect.showsHorizontalScrollIndicator = false
        collect.backgroundColor = UIColor.white
        collect.frame = CGRect(x: 0, y: AppHeight-(self!.sizeHeight+50), width: AppWidth, height: self!.sizeHeight)
        
        return collect
    }()
    private lazy var bottomButton: UIButton = { [weak self] in
        let button = UIButton(frame: CGRect(x: 0, y: AppHeight-50, width: AppWidth, height: 50))
        button.backgroundColor = skinColor
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self!, action: #selector(cancelClick), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        collectView.register(ShareHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifierHead)
        
        self.addSubview(collectView)
        self.addSubview(bottomButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ItemCell
        cell.titleBottomSpace.constant = 40
        cell.imageViewTopSpace.constant = 40
        cell.titleTopSpace.constant = 10
        cell.titleMaxH.constant = 20
        cell.titleLabel.text = dataModels[item].title
        cell.imageView.image = UIImage(named: dataModels[item].image)
        cell.titleTopSpace.constant = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        let type = dataModels[item].id-UMSocialPlatformType.userDefine_Begin.rawValue
        for platform in platforms {
            if type == platform.rawValue {
                UmengEngine.instance.shareContent(platform: platform)
                break
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifierHead, for: indexPath) as! ShareHeadView
//        head.titleLabel.text = "通过以下方式邀请好友可获得200积分"
//        
//        return head
//    }
    
    func cancelClick(){
        self.isHidden = true
    }

}
