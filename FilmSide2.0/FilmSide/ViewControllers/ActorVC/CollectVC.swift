//
//  CollectVC.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/6/12.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya
class CollectVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var current = 1
    var filmId:Int?
    var lineId:Int?
    var roleId:Int?
    var sex:Int = -1
    private var isEnd = false
    var starModels : [UserBaseInfoModel]?

    private var menu:ZZYMenuListView{
        let menuView = ZZYMenuListView(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:44))
        menuView.delegate = self
        return menuView
    }
    private lazy var childCollectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 44, width: AppWidth, height: NaviTabH-44), collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = backColor
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "收藏的艺人"
        self.navigationController?.isNavigationBarHidden = false
        navigationBarTintColor()
        WOWDropMenuSetting.columnTitles = ["综合排序","筛选"]
        WOWDropMenuSetting.rowTitles =  [
            ["销量","价格","信誉","性价比高","口碑超赞"],
            ["热销的咯","推荐","进口保证","美国"]
        ]
        WOWDropMenuSetting.maxShowCellNumber = 4
        WOWDropMenuSetting.columnEqualWidth = true
        WOWDropMenuSetting.cellTextLabelSelectColoror = UIColor.red
        WOWDropMenuSetting.showDuration = 0.2
        childCollectionView.register(UINib.init(nibName: "ZZYShouCangCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        view.addSubview(menu)
        self.view.addSubview(childCollectionView)
        actorList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ZZYShouCangCell
        cell?.model = starModels?[indexPath.item]
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width:(AppWidth-20)/2,height:(AppWidth-20)/2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = IndividualVC()
        vc.actorid = starModels?[indexPath.item].actorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func actorList(){
        loadHUD()
        var params = ["crewId": AppConst.userid ?? 0] as [String:Any]//AppConst.userid!
        params["type"] = 1
        params["curPage"] = current
        if sex != -1 {
            params["sex"] = sex
        }
        if filmId != nil {
            params["mewssageId"] = filmId!
        }
        MoyaProvider<User>().request(.actorList(params: params)) { resp in
            do {
                self.childCollectionView.closeHeadRefresh()
                self.childCollectionView.closeFooterRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let model = [UserBaseInfoModel].deserialize(from: value, designatedPath: "pageBean.items") as? [UserBaseInfoModel]{
                    if self.current == 1 {
                        self.starModels = model
                    } else {
                        self.starModels?.append(contentsOf: model)
                    }
                    if model.count > 0 {
                        self.isEnd = false
                    } else {
                        self.isEnd = true
                    }
                    self.hideHUD()
                } else {
                    self.textHUD("无数据")
                }
                self.childCollectionView.reloadData()
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
                self.childCollectionView.closeHeadRefresh()
                self.childCollectionView.closeFooterRefresh()
            }
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
extension CollectVC:DropMenuViewDelegate{
    func dropMenuClick(column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
        WOWDropMenuSetting.rowTitles =  [
            ["销量","价格","信誉","性价比高","口碑超赞"],
            ["111","222","333","444"]
        ]
        
    }
}
