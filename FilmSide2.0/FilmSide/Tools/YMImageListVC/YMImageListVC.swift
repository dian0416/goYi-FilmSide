//
//  STImageListVC.swift
//  N+Store
//
//  Created by 米翊米 on 16/8/17.
//  Copyright © 2016年 天宫. All rights reserved.
//

import UIKit
import Photos

protocol YMImageListVCDelegate {
    func imageResult(result: [UIImage])
}

class ImageModel: NSObject {
    var asset:PHAsset?
    var isSelected:Bool = false
}

class VideoModel: NSObject {
    var asset:PHAsset?
    var isSelected:Bool = false
}

//uibutton传值key
var associatedkey = "btnkey"
//cell标识符
let cellIdentifier = "cell"

class YMImageListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver {
    var delegate:YMImageListVCDelegate?
    //资源库管理类
    let imageManager:PHCachingImageManager = {
        return PHCachingImageManager()
    }()
    //视频资源数组
    private lazy var videoArray: [VideoModel] = {
        return [VideoModel]()
    }()
    //图片资源数组
    private lazy var assetsFetchResults:[ImageModel] = {
        return [ImageModel]()
    }()
    //UICollectionView初始化
    lazy var collectView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 5, 0)
        flowLayout.itemSize = CGSize(width: (AppWidth-20)/3, height: (AppWidth-20)/3)
        
        let cView = UICollectionView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: AppHeight-NavigationH), collectionViewLayout: flowLayout)
        cView.alwaysBounceVertical = true
        cView.backgroundColor = UIColor.white
        
        // 注册cell
        cView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return cView
    }()
    //选择结果
    private lazy var imgArray:[UIImage] = {
        return [UIImage]()
    }()
    var maxCount = 1
    private var status = false
    private var rightBtn:UIButton!
    private var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "相册"
//        viewControllerDefault()
        
        collectView.dataSource = self
        collectView.delegate = self
        self.view.addSubview(collectView)
        
        //获取权限
        PHPhotoLibrary.requestAuthorization { (status) in
            if status != .authorized {
                let alertVC = UIAlertController(title: "无权限", message: "无法访问相册.请在'设置->隐私->照片设置为打开状态", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { (UIAlertAction) -> Void in
                    UIApplication.shared.openURL(NSURL(string: "prefs:root=Privacy&path=PHOTOS")! as URL)
                }))
                self.present(alertVC, animated: true, completion: nil)
            } else {
                self.performSelector(onMainThread: #selector(self.loadAssets), with: nil, waitUntilDone: true)
            }
        }
        
        rightBtn = addRightItem(title: "完成", color:UIColor.black)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        rightBtn.contentHorizontalAlignment = .right
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    //MARK: - 选择完成传递结果
    override func rightClick() {
        for model in assetsFetchResults {
            if model.isSelected {
                imageManager.requestImage(for: model.asset!, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    if image != nil {
                        self.imgArray.append(image!)
                    }
                    if self.imgArray.count == self.count {
                        _ = self.navigationController?.popViewController(animated: true)
                        self.delegate?.imageResult(result: self.imgArray)
                    }
                })
            }
        }
    }
    
    //MARK: - 获取相册改变结果
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.loadAssets()
        }
    }
    
    //MARK: 便利获取相册图片
    func loadAssets() {
        assetsFetchResults.removeAll()
        // 列出所有系统的智能相册
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: options)
        
        result.enumerateObjects({ (asset, index, true) in
            let model = ImageModel()
            model.isSelected = false
            model.asset = asset
            
            self.assetsFetchResults.append(model)
        })
        self.collectView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CollectionViewcell个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsFetchResults.count
    }
    
    //定义展示的Section的个数
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 获取单元格
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath)
        if (cell.backgroundView == nil) {//防止多次创建
            let imageView = UIImageView()
            cell.backgroundView = imageView
        }
        var selectBtn = cell.contentView.viewWithTag(100) as? UIButton
        if selectBtn == nil {
            let width = cell.bounds.size.width
            
            selectBtn = UIButton(frame: CGRect(x: width-40, y: 0, width: 40, height: 40))
            selectBtn?.imageEdgeInsets = UIEdgeInsetsMake(5, 15, 15, 5);
            selectBtn?.setImage(UIImage(named: "image_normal"), for: .normal)
            selectBtn?.setImage(UIImage(named: "image_seleted"), for: .selected)
            selectBtn?.addTarget(self, action: #selector(self.selectClick(sender:)), for: .touchUpInside)
            selectBtn?.tag = 100
            
            cell.contentView.addSubview(selectBtn!)
        }
    
        //取缩略图
        let options = PHImageRequestOptions()
        options.resizeMode = .none
        options.isNetworkAccessAllowed = true
        let myAsset = assetsFetchResults[indexPath.item]
        let size = CGSize(width: (cell.backgroundView?.frame.size.width)!*2, height: (cell.backgroundView?.frame.size.height)!*2)
        imageManager.requestImage(for: myAsset.asset!, targetSize: size, contentMode: .aspectFill, options: options) { (image, info) in
            ((cell.backgroundView) as? UIImageView)?.image = image
        }
        (cell.backgroundView as! UIImageView).contentMode = .scaleAspectFill
        (cell.backgroundView as! UIImageView).clipsToBounds = true
        
        //设置按钮点击关联值
        objc_setAssociatedObject(selectBtn, &associatedkey, myAsset, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return cell
    }
    
    // 单元格点击响应
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let myAsset = assetsFetchResults[indexPath.item]
//        var index = 0
        
    }
    
    //选择图片事件
    func selectClick(sender: UIButton) {
        let model = objc_getAssociatedObject(sender, &associatedkey) as! ImageModel
        let select = !sender.isSelected
        sender.isSelected = select
        model.isSelected = select
        
        count = 0
        for model in assetsFetchResults {
            if model.isSelected {
                if count >= maxCount {
                    model.isSelected = false
                    sender.isSelected = false
                }else {
                    count += 1
                }
            }
        }
        
        let attrStr = NSMutableAttributedString(string: "(\(count)/\(maxCount))完成")
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0, attrStr.length))
        attrStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, attrStr.length-2))
        rightBtn.setAttributedTitle(attrStr, for: .normal)
    }
    
}
