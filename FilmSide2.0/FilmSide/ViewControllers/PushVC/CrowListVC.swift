//
//  CrowListVC.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/8/2.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class CrowListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ControlDelegate {
    private let identifier = "cell"
    private let identifierDetail = "cell1"
    private let headerIdentifier = "CollectionReusableViewHeader"
    private let footerIdentifier = "CollectionReusableViewFooter"
    var models:[FilmInfoModel]?
    var allModels:[FilmInfoModel]?
    //movieId:Int? //1院线电影 2网络大电影 3电视剧 4网络剧 5商业活动 6综艺
    var type:Int?
    var typeArr:[String] = ["","院线电影","网络大电影","电视剧","网络剧","商业活动","综艺"]
    //初始化视图
    private var infoView:HeadInfoView{
        let view = Bundle.main.loadNibNamed("HeadInfoView", owner: nil, options: nil)?.first as! HeadInfoView
        view.frame = CGRect(x: 0, y: -100, width: AppWidth, height: 100)
//        let a = AppConst.headImage
        view.headImageView.loadImage(AppConst.headImage ?? "")
        view.titleLabel.text = "我所发布的\(typeArr[type ?? 0])"
        view.nameLabel.text = AppConst.realName ?? ""
        return view
    }
    private lazy var collectView:UICollectionView = { [weak self] in
        let browLayout = UICollectionViewFlowLayout()
        browLayout.itemSize = CGSize(width: AppWidth, height: NaviTabH)
        browLayout.scrollDirection = .vertical
        browLayout.minimumInteritemSpacing = 0
        browLayout.minimumLineSpacing = 0
        browLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        let collect = UICollectionView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NaviTabH), collectionViewLayout: browLayout)
        collect.showsHorizontalScrollIndicator = false
//        collect.isPagingEnabled = true
        collect.bounces = false
        collect.alwaysBounceVertical = true
        collect.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self!.identifier)
        collect.dataSource = self!
        collect.delegate = self!
        collect.backgroundColor = UIColor.white
        
        
        return collect
    }()
    private var shareView : ShareCrewView = {
        let rightView = Bundle.main.loadNibNamed("ShareCrewView", owner: nil, options: nil)?.first as! ShareCrewView
        rightView.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        return rightView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectView.register(UINib(nibName: "PushedCrewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        collectView.register(UINib(nibName: "PushDetailCell", bundle: nil), forCellWithReuseIdentifier: identifierDetail)
        collectView.register(UINib(nibName: "ZZYCollectionHeaderView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        collectView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        collectView.addSubview(infoView)
        self.view.addSubview(collectView)
        let right = UIBarButtonItem.init(customView: shareView)
        let space = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 0
        self.navigationItem.rightBarButtonItems = [space,right]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return models?.count ?? 0
        }
        return allModels?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PushedCrewCell
            cell?.movieImageView.loadImage(models?[indexPath.row].messageImg)
            cell?.nameLabel.text = models?[indexPath.row].filmName
            cell?.likeLabel.text = "\(models?[indexPath.row].readCount ?? 0)个人看过"
            cell?.typeView.isHidden = true
            //        cell?.model = models[indexPath.item]
            cell?.models = models?[indexPath.row].praseList
            return cell!
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierDetail, for: indexPath) as? PushDetailCell
        cell?.headImageView.loadImage(allModels?[indexPath.row].messageImg)
        cell?.titleLabel.text = allModels?[indexPath.row].filmName
        cell?.readLabel.text = "\(allModels?[indexPath.row].readCount ?? 0)个人看过"
        
        //        cell?.model = models[indexPath.item]        
        return cell!

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let pushVC = PushVC()
            pushVC.model = models?[indexPath.row]
            navigationController?.pushViewController(pushVC.hiddenTabBar(), animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: AppWidth - 10, height: (AppWidth - 10)/35*27)
        }
        return CGSize(width: (AppWidth - 15)/2, height: (AppWidth - 15)/2*4/5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if section == 1{
            return CGSize(width: AppWidth, height: 50)
        }
        return CGSize(width: AppWidth, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:ZZYCollectionHeaderView!
        
        if kind == UICollectionElementKindSectionHeader
        {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ZZYCollectionHeaderView
 
            reusableview.headlabel.text = "我的所有发布"
            reusableview.publicDelegate = self
            //            (reusableview as! UICollectionReusableView).label.text = String(format: "第 %d 个页眉", arguments: [indexPath.section])
        }else if kind == UICollectionElementKindSectionFooter{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! ZZYCollectionHeaderView
            reusableview.backgroundColor = UIColor.brown
            
            //            (reusableview as! UICollectionReusableView).label.text = String(format: "第 %d 个页脚", arguments: [indexPath.section])
        }
        
        
        return reusableview
    }
    func dataHandler(type: Any?, data: Any?) {
        if type as! String == "headerClick" {
            let allVC = AllCrewListVC()
            allVC.models = allModels
            self.navigationController?.pushViewController(allVC, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
