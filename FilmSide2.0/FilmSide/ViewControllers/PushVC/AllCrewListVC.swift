//
//  AllCrewListVC.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/8/2.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class AllCrewListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    private let identifier = "cell"
    var models:[FilmInfoModel]?
    var typeArr:[String] = ["","院线电影","网络大电影","电视剧","网络剧","商业活动","综艺"]
    private lazy var collectView:UICollectionView = { [weak self] in
        let browLayout = UICollectionViewFlowLayout()
        browLayout.itemSize = CGSize(width: AppWidth, height: NaviTabH)
        browLayout.scrollDirection = .vertical
        browLayout.minimumInteritemSpacing = 0
        browLayout.minimumLineSpacing = 0
        browLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        let collect = UICollectionView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NaviTabH), collectionViewLayout: browLayout)
        collect.showsHorizontalScrollIndicator = false
        collect.isPagingEnabled = true
        collect.bounces = false
        collect.alwaysBounceVertical = true
        collect.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self!.identifier)
        collect.dataSource = self!
        collect.delegate = self!
        collect.backgroundColor = UIColor.white
        
        return collect
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectView.register(UINib(nibName: "PushedCrewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        self.view.addSubview(collectView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PushedCrewCell
        cell?.movieImageView.loadImage(models?[indexPath.row].messageImg)

        cell?.nameLabel.text = models?[indexPath.row].filmName
        cell?.likeLabel.text = "\(models?[indexPath.row].readCount ?? 0)个人看过"

        cell?.typeLabel.text = typeArr[models?[indexPath.row].movieId ?? 0]
        //        cell?.model = models[indexPath.item]
        
        return cell!
        

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: AppWidth - 10, height: (AppWidth - 10)/35*27)

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
