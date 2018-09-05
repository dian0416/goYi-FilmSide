//
//  PushCrewCell.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/4/18.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class PushCrewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PushDetailCell
        cell?.model = models?[indexPath.item]
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (AppWidth-62)/3, height: (AppWidth-62)/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.viewController() as! PushListVC
        let ad = CrowListVC()
        //movieId:Int? //1院线电影 2网络大电影 3电视剧 4网络剧 5商业活动 6综艺
        ad.models = self.models
        ad.type = models?[indexPath.item].movieId
        ad.allModels = vc.models
        vc.navigationController?.pushViewController(ad, animated: true)
    }
    @IBOutlet var movieCollectionView: UICollectionView!
    var models:[FilmInfoModel]?{
        didSet{
            movieCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        movieCollectionView.register(UINib(nibName: "PushDetailCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        movieCollectionView.collectionViewLayout = layout
        movieCollectionView.showsVerticalScrollIndicator = false
        movieCollectionView.showsHorizontalScrollIndicator = false
        movieCollectionView.bounces = false
        
        movieCollectionView.contentInset = UIEdgeInsets(top:0, left:10, bottom:0, right:10)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
