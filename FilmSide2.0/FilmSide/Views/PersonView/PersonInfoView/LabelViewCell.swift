//
//  LabelViewCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/31.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()

        return UILabel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = lineColor
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LabelViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var collectView: UICollectionView!
    private let identifier = "cell"
    private let identifierhead = "head"
    var dataModels:[[(id:Int, value:String, select:Bool)]]? {
        didSet{
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
        let layout = YMButtonFlowLayout()
        collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectView.backgroundColor = UIColor.white
        collectView.showsVerticalScrollIndicator = false
        collectView.showsHorizontalScrollIndicator = false
        collectView.register(UINib(nibName: "YMButtonCell", bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
        collectView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifierhead)
        collectView.delegate = self
        collectView.dataSource = self

        collectView.frame = self.bounds
        self.contentView.addSubview(collectView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectView.frame = self.bounds
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if dataModels?.count > 0 {
            return dataModels!.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataModels![section].count > 0 {
           return dataModels![section].count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YMButtonCell
        cell.layer.cornerRadius = 5
        let section = indexPath.section
        let item = indexPath.item
        
        let model = dataModels![section][item]
        cell.textLabel.text = model.value
        cell.isSelected = model.select
        cell.textLabel.font = UIFont.systemFont(ofSize: 15)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let item = indexPath.item
        
        let model = dataModels![section][item]
        let constraintRect = CGSize(width: AppWidth-20, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = model.value.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
        
        if boundingBox.width >= AppWidth-20 {
            return CGSize(width: AppWidth-20, height: 25)
        }
        return CGSize(width: boundingBox.width+20, height: boundingBox.height+4)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifierhead, for: indexPath) as! HeaderView
        header.titleLabel.frame = CGRect(x: 10, y: 0, width: header.frame.width-20, height: header.frame.height)
        header.titleLabel.textColor = subColor
        header.titleLabel.font = UIFont.systemFont(ofSize: 15)
        let section = indexPath.section
        
        if section == 0 {
            header.titleLabel.text = "愿意饰演角色"
        } else if section == 1 {
            header.titleLabel.text = "个性标签"
        } else {
            header.titleLabel.text = "特长标签"
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let item = indexPath.item
        let cell = collectView.cellForItem(at: indexPath)
        var select = cell!.isSelected
        if dataModels![section][item].select == cell!.isSelected {
            select = false
        }
        let data = (index:indexPath, mark:select)
        publicDelegate?.dataHandler(type: "label", data: data)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.collectView.reloadData()
        self.layoutIfNeeded()
        var size =  self.collectView.collectionViewLayout.collectionViewContentSize
        size.height += 1
        return size
    }
    
}
