//
//  CrewListCell.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/6/5.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class CrewListCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CrewCollectionCell
        cell?.model = models[indexPath.item]
        cell?.headImageView.layer.cornerRadius = (cell?.headImageView.height)!/2
        cell?.headImageView.clipsToBounds = true
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = IndividualVC()
        vc.actorid = models[indexPath.item].actorId
        self.viewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (AppWidth - 40)/4, height: (AppWidth - 40)/4 + 20)
    }

    @IBOutlet var crewListCollectionView: UICollectionView!
    var models = [UserBaseInfoModel](){
        didSet{
            crewListCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        crewListCollectionView.register(UINib(nibName: "CrewCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        crewListCollectionView.collectionViewLayout = layout
//        register(UINib(nibName: "CrewCollectionCell", bundle: nil), forCellReuseIdentifier: "cell")
        crewListCollectionView.dataSource = self
        crewListCollectionView.delegate = self
        crewListCollectionView.isScrollEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
