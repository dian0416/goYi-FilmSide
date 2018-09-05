//
//  LastVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/20.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya
import LLCycleScrollView
class LastVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ControlDelegate{
    private lazy var headerView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 8, width: AppWidth, height: 30))
        view.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 200, height: 30))
        label.text = "收藏的艺人"
        label.font = UIFont.systemFont(ofSize: 14)
        let btn = UIButton(frame: CGRect(x: AppWidth - 50, y: 5, width: 45, height: 30))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("更多", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.addTarget(self, action: #selector(LastVC.moreShouCang), for: .touchUpInside)
        view.addSubview(label)
        view.addSubview(btn)
        return view
    }()
    private lazy var squareView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 8, width: AppWidth, height: 30))
        view.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: 200, height: 30))
        label.text = "艺人广场"
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        return view
    }()
    private lazy var titleArray:[(key:String?, value:String?)] = {
        return [(key:String?, value:String?)]()
    }()
    var imagePaths=[UserBaseInfoModel?]()
    private lazy var childTableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: TabbarViewH), style:.plain)
        tableView.tableViewDefault()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = backColor

        return tableView
    }()
    //*帖子使用变量
    private lazy var worksModel: [(id:String?, title:String?, image:String?)]? = {
        return [(id:String?, title:String?, image:String?)]()
    }()
    private lazy var cellIdentifers: [String] = {
        var identifers = [String]()
        for i in 0..<9 {
            identifers.append("image_\(i)")
        }
        
        return identifers
    }()
    private lazy var imageCells: [String] = {
        return ["OneImageCell", "TwoImageCell", "ThreeImageCell", "FourImageCell", "FiveImageCell", "SixImageCell", "SevenImageCell", "EightImageCell", "NineImageCell"]
    }()
    //************
    //*点赞转发
    var status = -1
    var squareId:Int?
    //************
    private let identifierhead = "head"
    private let identifiercollect = "collect"
    private let identifiersquare1 = "square1"
    private let identifiersquare2 = "square2"
    private let identifiersquare3 = "square3"
    private lazy var sexs: [String] = {
        return ["男", "女"]
    }()
    private var isEnd = false
    private var pickType = 0
    //0-艺人之星 1-备选艺人剧名 2-备选艺人线位 3-备选艺人角色 4-角色筛选 6-收藏艺人
//    var sourceType:Int = 0
    var monthActor:UserBaseInfoModel?
    var weekActor:UserBaseInfoModel?
    var starModels = [UserBaseInfoModel]()
    var films:[FilmInfoModel]?
    var lines:[LabelModel]?
    var roles:[PersonModel]?
    var current = 1
    var filmId:Int?
    var lineId:Int?
    var roleId:Int?
    var sex:Int = -1
    var actorName:String?
    
    
    var models = [InvitionModel]()
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationBarTintColor()
        self.view.addSubview(childTableView)
        childTableView.addHeadFreshView(target: self, action: #selector(pullFresh))
        childTableView.addFootFreshView(target: self, action: #selector(loadMore))
        pullFresh()
        childTableView.register(UINib(nibName: "CrewListCell", bundle: nil), forCellReuseIdentifier: identifiercollect)
        childTableView.register(UINib(nibName: "HeadCell", bundle: nil), forCellReuseIdentifier: identifierhead)
        childTableView.register(UINib(nibName: "TrendsHeadCell", bundle: nil), forCellReuseIdentifier: identifiersquare1)
        for i in 0..<imageCells.count {
            childTableView.register(UINib(nibName: imageCells[i], bundle: nil), forCellReuseIdentifier: cellIdentifers[i])
        }
        childTableView.register(UINib(nibName: "BottomCell", bundle: nil), forCellReuseIdentifier: identifiersquare3)

        

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count + 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0||section == 1 {
            return 1
        }
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierhead) as! HeadCell
            cell.starModels = imagePaths
            return cell
        }else if section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: identifiercollect) as! CrewListCell
            cell.models = starModels
            return cell
        }else{
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifiersquare1) as? TrendsHeadCell
                cell?.publicDelegate = self
                cell?.selectionStyle = .none
                if models.count > 6 {
                    cell?.model = models[section - 2]
                } else {
                    cell?.model = models[section - 2]
                }
                if cell?.model?.imgList?.count > 0 {
                    cell?.descLabel.textAlignment = .left
                    cell?.backView.image = nil
                    cell?.descLeft.constant = 10
                    cell?.descRight.constant = 10
                } else {
                    cell?.descLabel.textAlignment = .center
                    cell?.backView.image = UIImage(named: "forwardback")
                    cell?.descLeft.constant = 50
                    cell?.descRight.constant = 50
                }
                
                return cell!
            } else if row == 1 {
                var model:InvitionModel?
                if models.count > 6 {
                    model = models[section-2]
                } else {
                    model = models[section-2]
                }
                var count = 0
                var images = [String?]()
                if model?.imgList != nil {
                    for model in model!.imgList! {
                        images.append(model.imgUrl)
                    }
                }
                if images.count == 0 {
                    return cellDefault()
                } else if images.count > 5 {
                    count = 5
                } else {
                    count = images.count
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifers[count-1]) as? BaseViewCell
                cell?.textLabel?.isHidden = true
                cell?.detailTextLabel?.isHidden = true
                cell?.selectionStyle = .none
                cell?.isEnable = false
                
                cell?.images = images
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifiersquare3) as? BottomCell
                if models.count > 6 {
                    cell?.model = models[section-2]
                } else {
                    cell?.model = models[section-2]
                }
                cell?.publicDelegate = self
                
                return cell!
            }
        }
        
        
        
    }
    func cellDefault() -> UITableViewCell {
        var cell = childTableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200
        }else if indexPath.section == 1{
            return 260
        }
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            return headerView
        }else if section == 2{
            return squareView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1||section == 2 {
            return 40
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 1 {
            let model = models[indexPath.section-2]
            let detailVC = NewsDetailVC()
            detailVC.squareId = model.id
            detailVC.detailModel = model
            detailVC.imageModel = model.imgList
            navigationController?.pushViewController(detailVC.hiddenTabBar(), animated: true)
        }

    }
    
    //更多收藏
    @objc func moreShouCang(){
        let cVC = CollectVC()
        self.navigationController?.pushViewController(cVC, animated: true)
    }
    func dataHandler(type: Any?, data: Any?) {

    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    
    func pullFresh(){
        current = 1

        actorStar()

        actorList()
        getRequest()

    }
    
    func loadMore(){
        if isEnd {
            childTableView.closeHeadRefresh()
            childTableView.closeFooterRefresh()
            return
        }
        self.current += 1
        actorList()
    }
    //周月冠军
    func actorStar(){
        loadHUD()
        MoyaProvider<User>().request(.actorGet()) { resp in
            do {
                self.childTableView.closeHeadRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value, designatedPath: "result")
                if status?.status == 0 {
                    self.monthActor = UserBaseInfoModel.deserialize(from: value, designatedPath: "starWrapper.monthStar.actor")
                    self.weekActor = UserBaseInfoModel.deserialize(from: value, designatedPath: "starWrapper.weekStar.actor")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                        self.imagePaths = [self.monthActor,self.weekActor]
                        self.childTableView.reloadData()
                    }
                    

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
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let model = [UserBaseInfoModel].deserialize(from: value, designatedPath: "pageBean.items") as? [UserBaseInfoModel]{
                    self.starModels = model

                    if model.count > 0 {
                        self.isEnd = false
                    } else {
                        self.isEnd = true
                    }
                    self.hideHUD()
                } else {
                    self.textHUD("无数据")
                }
                self.childTableView.reloadData()
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
            }
        }
    }
    //得到帖子数据
    func getRequest(){
        if isEnd {
            self.childTableView.closeHeadRefresh()
            self.childTableView.closeFooterRefresh()
            return
        }
        loadHUD()
        
        var params = ["orderBy": 1, "curPage":current] as [String: Any]
        params["actorId"] = AppConst.userid
        MoyaProvider<User>().request(.getList(params: params)) { resp in
            do {
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        if let model = [InvitionModel].deserialize(from: value, designatedPath: "pageBean.items") as? [InvitionModel]{
                            if self.current == 1 {
                                self.models = model
                            } else {
                                self.models.append(contentsOf: model)
                            }
                            if model.count > 0 {
                                self.current += 1
                            }
                            if model.count < 20 {
                                self.isEnd = true
                            } else {
                                self.isEnd = false
                            }
                            self.worksModel?.removeAll()
                            for i in 0..<6 {
                                if i < self.models.count {
                                    let mod = self.models[i]
                                    var tid = ""
                                    if let id = mod.id {
                                        tid = "\(id)"
                                    }
                                    var tle = ""
                                    if let title = mod.content {
                                        tle = title
                                    }
                                    var timage:String? = ""
                                    if let images = mod.imgList {
                                        if images.count > 0 {
                                            timage = images[0].imgUrl
                                        }
                                    }
                                    self.worksModel?.append((tid, tle, timage))
                                }
                            }
                        }
                        self.hideHUD()
                        self.childTableView.reloadData()
//                        self.childTableView.layoutIfNeeded()
//                        self.childTableView.contentInset = UIEdgeInsets(top: 420, left: 0, bottom: 0, right: 0)
                    } else if let msg = status.msg {
                        self.textHUD(msg)
                    } else {
                        self.textHUD("网络错误, 请稍后重试")
                        //                        if self.models.count > 0 {
                        //                            self.childTableView.hiddenEmptyView()
                        //                        } else {
                        //                            self.childTableView.showEmptyView()
                        //                        }
                    }
                } else {
                    self.textHUD("网络错误, 请稍后重试")
                    //                    if self.models.count > 0 {
                    //                        self.childTableView.hiddenEmptyView()
                    //                    } else {
                    //                        self.childTableView.showEmptyView()
                    //                    }
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
                //                if self.models.count > 0 {
                //                    self.childTableView.hiddenEmptyView()
                //                } else {
                //                    self.childTableView.showEmptyView()
                //                }
            }
        }
    }
    
    //点赞转发
    func forwardNews() {
        if squareId == nil {
            return
        }
        var params = ["squareId": squareId!] as [String : Any]
        params["actorId"] = AppConst.userid
        params["state"] = status
        loadHUD()
        
        MoyaProvider<User>().request(.praiseSquare(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value) {
                    if status.status == 0 {
                        if self.status == 1 {
                            self.textHUD("点赞成功")
                        } else {
                            self.textHUD("转发成功")
                        }
                        for model in self.models {
                            if model.id == self.squareId {
                                if self.status == 1 {
                                    model.praise += 1
                                } else if self.status == 3 {
                                    model.forward += 1
                                }
                            }
                        }
//                        self.childTableView.reloadData()
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
    func disFav(aid: Int){
        loadHUD()
        let params = ["id": aid]
        
        MoyaProvider<User>().request(.disFav(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value)
                if status?.status == 0 {
                    self.textHUD("取消收藏成功")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: {
                        self.actorList()
                    })
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
