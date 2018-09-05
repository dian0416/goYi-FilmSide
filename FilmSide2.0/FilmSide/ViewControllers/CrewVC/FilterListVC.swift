//
//  FilterListVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/13.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class FilterListVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let identifier = "label"
    private let identifierhead = "head"
    private lazy var dataModels:[(key:String?, value:String?)] = {
        return [(key:String?, value:String?)]()
    }()
    var films:[FilmInfoModel]?
    //0-备选艺人 1-选角
    var sourceType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        navigationBarTintColor()
        navigationItem.title = "筛选"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(UINib(nibName: "YMButtonCell", bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
        collectionView?.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifierhead)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        filmList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if dataModels.count > 0 {
            return 1
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! YMButtonCell
        cell.layer.cornerRadius = cell.frame.height/2
        let item = indexPath.item
        
        let model = dataModels[item]
        cell.textLabel.text = model.value
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = indexPath.item
        
        let model = dataModels[item]
        let constraintRect = CGSize(width: AppWidth-20, height: CGFloat.greatestFiniteMagnitude)
        if model.value != nil {
            let boundingBox = model.value!.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
            
            if boundingBox.width >= AppWidth-20 {
                return CGSize(width: AppWidth-20, height: 25)
            }
            
            return CGSize(width: boundingBox.width+20, height: boundingBox.height+4)
        }
        
        return CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifierhead, for: indexPath) as! HeaderView
        header.titleLabel.frame = CGRect(x: 10, y: 0, width: header.frame.width-20, height: header.frame.height)
        header.titleLabel.textColor = subColor
        header.titleLabel.font = UIFont.systemFont(ofSize: 15)
        let section = indexPath.section
        
        if section == 0 {
            header.titleLabel.text = "片名搜索"
        } else if section == 1 {
            header.titleLabel.text = "角色搜索"
        }
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        
        if sourceType == 0 {
            let actVC = LastVC()
//            actVC.sourceType = 2
            if let id = Int(dataModels[item].key!) {
                actVC.filmId = id
            }
            actVC.navigationItem.title = dataModels[item].value
            navigationController?.pushViewController(actVC, animated: true)
        } else {
            let swarVC = ChooseVC(style: .plain)
            swarVC.sourceType = 1
            if let id = Int(dataModels[item].key!) {
                swarVC.filmId = id
            }
            swarVC.navigationItem.title = dataModels[item].value
            navigationController?.pushViewController(swarVC, animated: true)
        }
    }
    
    func filmList(){
        loadHUD()
        
        MoyaProvider<User>().request(.filmsGet()) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value, designatedPath:"result")
                if status?.status == 0 {
                    self.films = [FilmInfoModel].deserialize(from: value, designatedPath: "crewMessageWrapperList") as? [FilmInfoModel]
                    self.dataModels.removeAll()
                    if self.films != nil {
                        for film in self.films! {
                            var tid = ""
                            if let id = film.id {
                                tid = "\(id)"
                            }
                            self.dataModels.append((tid, film.filmName))
                        }
                    }
                    self.collectionView?.reloadData()
                    self.hideHUD()
                } else if let msg = status?.msg {
                    self.textHUD(msg)
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
