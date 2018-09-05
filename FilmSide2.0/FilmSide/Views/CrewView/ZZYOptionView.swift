//
//  ZZYOptionView.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/7/26.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ZZYOptionView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!

    var models:[ActorModel]?{
        didSet{
            if models?.count == 0{
                self.isHidden = true
            }else{
                self.isHidden = false
            }
            collectionView.reloadData()
        }
    }
    
    var headView:ZZYHeadView{
        let head = Bundle.main.loadNibNamed("ZZYHeadView", owner: nil, options: nil)?.first as! ZZYHeadView
        head.charectorBtn.addTarget(self, action: #selector(clickChar), for: .touchUpInside)
        head.frame = CGRect(x:0,y:0,width:self.width,height:50)
        return head
    }
    func clickChar(){
        self.publicDelegate?.dataHandler(type: "popBIO", data: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIViewAutoresizing()
        // 注册Cell
        collectionView.register(UINib(nibName: "OptionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.addSubview(headView)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置collectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        
        
//        layout.itemSize = collectionView.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OptionCell
        cell.nameLabel.text = models?[indexPath.item].nickName
        cell.headImageView.loadImage(models?[indexPath.item].headImg)
        //        cell.cycleModel = cycleModels![(indexPath as NSIndexPath).item % cycleModels!.count]
        
        return cell
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
// MARK:- 提供一个快速创建View的类方法
extension ZZYOptionView {
    class func zzyOptionView() -> ZZYOptionView {
        return Bundle.main.loadNibNamed("ZZYOptionView", owner: nil, options: nil)?.first as! ZZYOptionView
    }
}
extension ZZYOptionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (AppWidth)/4, height: 100)
    }
}
