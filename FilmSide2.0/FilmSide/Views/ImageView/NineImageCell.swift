//
//  NineImageCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/10.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class NineImageCell: BaseViewCell {
    lazy var browseView: BrowseImageView = {
        let view = BrowseImageView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: AppHeight), collectionViewLayout: UICollectionViewLayout())
        return view
    }()
    @IBOutlet var imgViews: [UIImageView]!
    override var images: [String?]? {
        didSet{
            if images != nil {
                for i in 0..<images!.count {
                    if i < imgViews.count {
                        imgViews[i].loadImage(images![i])
                    }
                }
            }
        }
    }
    override var isEnable: Bool {
        didSet{
            for i in 0..<imgViews.count {
                imgViews[i].isUserInteractionEnabled = isEnable
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        for i in 0..<imgViews.count {
            let imgView = imgViews[i]
            imgView.isUserInteractionEnabled = true
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.tag = 100+i
            let tapZer = UITapGestureRecognizer(target: self, action: #selector(imgClick(tap:)))
            tapZer.delaysTouchesBegan = true
            imgView.addGestureRecognizer(tapZer)
        }
    }
    
    func imgClick(tap: UITapGestureRecognizer){
        UIApplication.shared.keyWindow?.addSubview(browseView)
        let tag = tap.view!.tag - 100
        browseView.dataArray = images! as [AnyObject]
        browseView.reloadData()
        browseView.scrollToItem(at: IndexPath(item: tag, section: 0), at: .left, animated: false)
    }
    
}
