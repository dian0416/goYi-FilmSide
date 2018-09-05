//
//  CrewVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/19.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya


class CrewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    private let headerIdentifier = "CollectionReusableViewHeader"
    private let footerIdentifier = "CollectionReusableViewFooter"
    private let identifier = "cell"
    var models = [FilmInfoModel]()
    var secondChooseModels = [FilmInfoModel]()
    //初始化视图
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
//        collect.alwaysBounceVertical = true
        collect.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self!.identifier)
        collect.dataSource = self!
        collect.delegate = self!
        collect.backgroundColor = UIColor.white
        
        return collect
    }()
    private lazy var searchBar:UISearchBar = { [unowned self] in
        let view = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 44))
        
        let _searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 44))

        _searchBar.backgroundColor = skinColor
        _searchBar.delegate = self
        _searchBar.placeholder = "找剧组类型 片名"
        _searchBar.subviews[0].backgroundColor = skinColor
        _searchBar.subviews[0].subviews[0].removeFromSuperview()
        let searchField = _searchBar.value(forKey: "_searchField") as? UITextField
        searchField?.backgroundColor = UIColor.white
        //        searchField?.layer.cornerRadius = 15
        searchField?.font = UIFont.systemFont(ofSize: 12)
        searchField?.layer.borderWidth = 0.5
        searchField?.layer.borderColor = skinColor.cgColor
        if #available(iOS 11.0, *) {
            searchField?.heightAnchor.constraint(equalToConstant: 44)
        }
        view.addSubview(_searchBar)
        return _searchBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = searchBar

        navigationBarTintColor()
        collectView.register(UINib(nibName: "PushMovieCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        collectView.register(UINib(nibName: "ZZYCollectionHeaderView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        // Uncomment the following line to preserve selection between presentations
//        navigationItem.titleView = titleView
//        self.view.addSubview(titleView)

//        filmRequest()
        self.view.addSubview(collectView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        filmRequest()
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
            return models.count
        }
        return secondChooseModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PushMovieCell
        if indexPath.section == 0 {
            cell?.imageView.loadImage(models[indexPath.item].messageImg)
            cell?.nameLabel.text = models[indexPath.item].filmName
            cell?.readBtn.setTitle("\(models[indexPath.item].readCount)", for: .normal)
        }else{
            cell?.imageView.loadImage(secondChooseModels[indexPath.item].messageImg)
            cell?.nameLabel.text = secondChooseModels[indexPath.item].filmName
            cell?.readBtn.setTitle("\(secondChooseModels[indexPath.item].readCount )", for: .normal)

        }

//        cell?.model = models[indexPath.item]
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actorVC = ActorListVC()
        if indexPath.section == 0 {
            actorVC.model = models[indexPath.item]
        }else{
            actorVC.model = secondChooseModels[indexPath.item]
        }

        self.navigationController?.pushViewController(actorVC, animated: true)
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {[weak self] in
//            let section = self!.collectView.indexPath(for: self!.collectView.visibleCells.first!)!.section
//            self!.btnArray[section].addSubview(self!.undrLine)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: AppWidth - 10, height: (AppWidth - 10)/35*27 + 20)
        }
        return CGSize(width: (AppWidth - 15)/2, height: (AppWidth - 15)/2/35*27 + 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if section == 0{
            if models.count == 0{
                return CGSize(width: AppWidth, height: 0)
            }else{
                return CGSize(width: AppWidth, height: 50)
            }
        }
        return CGSize(width: AppWidth, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:ZZYCollectionHeaderView!
        
        if kind == UICollectionElementKindSectionHeader
        {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ZZYCollectionHeaderView

            reusableview.charectorBtn.isHidden = true
            if indexPath.section == 0{
                reusableview.headlabel.text = "新片·选角"
            }else{
                reusableview.headlabel.text = "猜你还想再选一次"
            }
            
//            (reusableview as! UICollectionReusableView).label.text = String(format: "第 %d 个页眉", arguments: [indexPath.section])
        }else if kind == UICollectionElementKindSectionFooter{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! ZZYCollectionHeaderView
            reusableview.backgroundColor = UIColor.brown
            
//            (reusableview as! UICollectionReusableView).label.text = String(format: "第 %d 个页脚", arguments: [indexPath.section])
        }
        
        
        return reusableview
    }
//    关键词搜索
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.length() > 0 {
            filmList(searchText: searchBar.text!)
        }
        
        textHUD("请输入搜索关键词")
    }
    func filmRequest() {
        loadHUD()
        var params = [String: Any]()
        params = ["id": AppConst.userid ?? 0 , "type": ""]
        MoyaProvider<User>().request(.roleList(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        if let models = [FilmInfoModel].deserialize(from: value, designatedPath: "pageBean.items") as? [FilmInfoModel] {
                            self.models = models
                        }
                        if let models = [FilmInfoModel].deserialize(from: value, designatedPath: "crewMessageList") as? [FilmInfoModel] {
                            self.secondChooseModels = models
                        }
                        self.hideHUD()
                        self.collectView.reloadData()
                    } else if let msg = status.msg {
                        self.textHUD(msg)
                    } else {
                        self.textHUD("网络错误，请重试")
                    }
                } else {
                    self.textHUD("网络错误，请重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    //搜索
    func filmList(searchText:String) {
        loadHUD()
        let params = ["crewId": AppConst.userid ?? 0,"filmName":searchText] as [String : Any]
        MoyaProvider<User>().request(.filmList(params:params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        if let models = [FilmInfoModel].deserialize(from: value, designatedPath: "crewMessageList") as? [FilmInfoModel] {
                            self.models = models
                        }
                        if self.models.count == 0 {
                            self.textHUD("暂无数据")
                        } else {
                            self.hideHUD()
                        }
                        self.collectView.reloadData()
                        self.hideKeyboard()
                    } else if let msg = status.msg {
                        self.textHUD(msg)
                    } else {
                        self.textHUD("网络错误, 请稍后重试")
                    }
                } else {
                    self.textHUD("网络错误, 请稍后重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }

}
