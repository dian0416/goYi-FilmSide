//
//  ActorListVC.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/7/25.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya
class ActorListVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ControlDelegate {
    //下拉选项
    private var menu:ZZYMenuListView{
        let menuView = ZZYMenuListView(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:44))
        menuView.delegate = self
        return menuView
    }
    //如果有备选则显示备选
    private var optionView:ZZYOptionView = {
        let optionview = ZZYOptionView.zzyOptionView()
        optionview.frame = CGRect(x: 0, y: -200, width: AppWidth, height: 200)
        optionview.headView.headLabel.text = "备选艺人"
        optionview.isHidden = true
        return optionview
    }()
    //右侧弹出view
    private var biographyView:RightDrawerView = {
        let bioView = RightDrawerView.rightDrawerView()
        bioView.frame = CGRect(x: AppWidth, y: 44, width: AppWidth/3*2, height: NaviTabH - 44)
        bioView.backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
//        bioView.isHidden = true
        //        optionview.models = selectActorList
        return bioView
    }()
    private let identifier = "cell"
    private let headerIdentifier = "CollectionReusableViewHeader"
    private let footerIdentifier = "CollectionReusableViewFooter"
    
    private lazy var collectView:UICollectionView = { [weak self] in
        let browLayout = UICollectionViewFlowLayout()
        browLayout.itemSize = CGSize(width: AppWidth, height: NaviTabH)
        browLayout.scrollDirection = .vertical
        browLayout.minimumInteritemSpacing = 0
        browLayout.minimumLineSpacing = 0
        browLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        let collect = UICollectionView(frame: CGRect(x: 0, y: 44, width: AppWidth, height: NaviTabH - 44), collectionViewLayout: browLayout)
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
    var model : FilmInfoModel?
    
    var lines:[LabelModel]?
    var roles:[PersonModel]?
    var selectActorList = [ActorModel]()
    var matchActorList = [ActorModel]()
    var roleModel:RoleModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        WOWDropMenuSetting.columnTitles = ["无经纪公司","角色","群演"]
        WOWDropMenuSetting.rowTitles =  [
            ["无经纪公司","有经纪公司"],
            ["热销的咯","推荐","进口保证","美国"],
            ["申通","圆通速递","韵达","德邦"]
        ]
        WOWDropMenuSetting.maxShowCellNumber = 4
        WOWDropMenuSetting.columnEqualWidth = true
        WOWDropMenuSetting.cellTextLabelSelectColoror = UIColor.red
        WOWDropMenuSetting.showDuration = 0.2
        view.addSubview(menu)
        view.addSubview(collectView)
        self.navigationItem.title = model?.filmName
        collectView.register(UINib(nibName: "ActorChooseCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        collectView.register(UINib(nibName: "ZZYCollectionHeaderView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        collectView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
//        collectView.addSubview(headView)
        collectView.addSubview(optionView)
        optionView.publicDelegate = self
        view.addSubview(biographyView)
        lineList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func back(){
        UIView.animate(withDuration: 2, animations: {
            self.biographyView.frame = CGRect(x: AppWidth/3, y: 44, width: AppWidth/3*2, height: NaviTabH - 44)
        }) { (true) in
            self.biographyView.frame = CGRect(x: AppWidth, y: 44, width: AppWidth/3*2, height: NaviTabH - 44)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchActorList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: (AppWidth - 15)/2, height: (AppWidth - 15)/2)
        }
        return CGSize(width: (AppWidth - 15)/2, height: (AppWidth - 15)/2)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ActorChooseCell
        cell?.headImageView.loadImage(matchActorList[indexPath.item].headImg)
        cell?.namelabel.text = matchActorList[indexPath.item].nickName
        //        cell?.model = models[indexPath.item]
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let interVC = IndividualVC()
        interVC.actorid = selectActorList[indexPath.item].id
        navigationController?.pushViewController(interVC.hiddenTabBar(), animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if matchActorList.count == 0 {
            return CGSize(width: AppWidth, height: 0)
        }
        return CGSize(width: AppWidth, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:ZZYCollectionHeaderView!
        
        if kind == UICollectionElementKindSectionHeader
        {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ZZYCollectionHeaderView
            
            reusableview.headlabel.text = "推荐艺人"
            if selectActorList.count != 0 {
                reusableview.charectorBtn.isHidden = true
            }else{
                reusableview.charectorBtn.isHidden = false
            }
        }else if kind == UICollectionElementKindSectionFooter{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! ZZYCollectionHeaderView
            reusableview.backgroundColor = UIColor.brown
            
            //            (reusableview as! UICollectionReusableView).label.text = String(format: "第 %d 个页脚", arguments: [indexPath.section])
        }
        return reusableview
    }
    //获取线位
    func lineList(){
        loadHUD()
        let params = ["messageId":model?.id ?? 0] as [String:Any]
        MoyaProvider<User>().request(.lineGet(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value, designatedPath:"result")
                if status?.status == 0 {
                    self.lines = [LabelModel].deserialize(from: value, designatedPath: "DLineList") as? [LabelModel]
                    var linenames = [String]()
                    if self.lines != nil{
                        for line in self.lines!{
                            
                            linenames.append(line.lineName ?? "")
                        }
                    }

                    WOWDropMenuSetting.rowTitles =  [
                        ["无经纪公司","有经纪公司"],
                        linenames,
                        ["申通","圆通速递","韵达","德邦"]
                    ]
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
    //获取角色
    func roleList(lineId:Int){
        let params = ["messageId": model?.id ?? 0, "lineId":lineId] as [String : Any]
        MoyaProvider<User>().request(.roleGet(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value, designatedPath:"result")
                if status?.status == 0 {
                    self.roles = [PersonModel].deserialize(from: value, designatedPath: "crewRoleWrapperList") as? [PersonModel]
                    var rolenames = [String]()
                    if self.roles != nil{
                        for line in self.roles!{
                        
                            rolenames.append(line.roleName ?? "")
                        }
                    }
                    var linenames = [String]()
                    if self.lines != nil{
                        for line in self.lines!{
                            
                            linenames.append(line.lineName ?? "")
                        }
                    }
                    WOWDropMenuSetting.rowTitles =  [
                        ["无经纪公司","有经纪公司"],
                        linenames,
                        rolenames
                    ]
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
    //根据角色查询备选及推荐艺人
    func actorList(roleId:Int){
//        loadHUD()

        let params = ["messageId": model?.id ?? 0, "roleId":roleId] as [String : Any]
        
        MoyaProvider<User>().request(.crewRoleList(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                self.matchActorList.removeAll()
                self.selectActorList.removeAll()
                if let models = [RoleModel].deserialize(from: value, designatedPath: "list") as? [RoleModel]{
                    self.roleModel = models[0]
                    self.biographyView.biographyLabel.text = models[0].biography
                    self.biographyView.movieName.text = self.model?.filmName
                    self.biographyView.headImageview.loadImage(self.model?.messageImg)
                    self.biographyView.infoLabel.text = "身高\(models[0].heightLow ?? 0)-\(models[0].heightHigh ?? 0),年龄\(models[0].ageLow ?? 0)-\(models[0].ageHigh ?? 0)"
                }
                if let models = [ActorModel].deserialize(from: value, designatedPath: "list1") as? [ActorModel]{
                    self.selectActorList = models
                }
                if let models = [ActorModel].deserialize(from: value, designatedPath: "list2") as? [ActorModel]{
                    self.matchActorList = models
                }
                
                self.optionView.models = self.selectActorList
                self.collectView.reloadData()
//                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
//
//                    if status.status == 0 {
//                        if let models = [ActorModel].deserialize(from: value, designatedPath: "list1") as? [ActorModel]{
//                            self.selectActorList = models
//                            self.collectView.reloadData()
//                        }
//                        if let models = [ActorModel].deserialize(from: value, designatedPath: "list2") as? [ActorModel]{
//                            self.optionView.models = models
//                        }
//                    } else if let msg = status.msg {
//                        self.textHUD(msg)
//                    } else {
//                        self.textHUD("网络错误, 请稍后重试")
//                    }
//                } else {
//                    self.textHUD("网络错误, 请稍后重试")
//                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    func dataHandler(type: Any?, data: Any?) {
        if type as! String == "popBIO"{
            UIView.animate(withDuration: 1, animations: {
                self.biographyView.frame = CGRect(x: AppWidth, y: 44, width: AppWidth/3*2, height: NaviTabH - 44)
            }) { (true) in
                self.biographyView.frame = CGRect(x: AppWidth/3, y: 44, width: AppWidth/3*2, height: NaviTabH - 44)
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
extension ActorListVC:DropMenuViewDelegate{
    func dropMenuClick(column: Int, row: Int) {
        debugPrint("点击了第\(column)列第\(row)行")
        if column == 1{
            roleList(lineId: self.lines?[row].id ?? 0)
        }else if column == 2{
            actorList(roleId: self.roles?[row].id ?? 0)
        }

        
    }
}
