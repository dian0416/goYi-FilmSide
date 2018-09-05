//
//  PushedCrewCell.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/8/2.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class PushedCrewCell: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width:likeCollectionView.height, height:likeCollectionView.height)

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PraseCell
        cell.HeadImageView.loadImage(models?[indexPath.item].headImg)
        cell.HeadImageView.layer.cornerRadius = likeCollectionView.height / 2
        cell.HeadImageView.clipsToBounds = true
        return cell
    }
    
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var likeCollectionView: UICollectionView!
    
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var typeView: UIView!
    @IBOutlet var typeLabel: UILabel!
    
    var models:[PriseModel]?{
        didSet{
            likeCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        likeCollectionView.register(UINib(nibName: "PraseCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        likeCollectionView.dataSource = self
        likeCollectionView.delegate = self
        
        // Initialization code
    }

}
