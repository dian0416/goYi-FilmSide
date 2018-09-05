//
//  YMImageCell.swift
//  Producer
//
//  Created by 张嘉懿 on 2017/9/26.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Photos
class YMImageCell: UICollectionViewCell {
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    let imageManager:PHCachingImageManager = {
        return PHCachingImageManager()
    }()
    var type = 0
    var model = ImageModel(){
        didSet{
            let options = PHImageRequestOptions()
            options.resizeMode = .none
            options.isNetworkAccessAllowed = true
            let size = CGSize(width: (self.frame.size.width)*2, height: (self.frame.size.height)*2)
            imageManager.requestImage(for: model.asset!, targetSize: size, contentMode: .aspectFill, options: options) { (image, info) in
                self.photoImageView.image = image
            }
            selectBtn.isSelected = model.isSelected
            selectBtn?.setImage(UIImage(named: "normal1"), for: .normal)
            selectBtn?.setImage(UIImage(named: "select"), for: .selected)
            if type == 1{
                selectBtn?.setImage(UIImage(named: "del"), for: .selected)
            }
            
        }
    }
    @IBAction func selectClick(_ sender: Any) {
        self.publicDelegate?.dataHandler(type: "selectPhoto", data: model)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
