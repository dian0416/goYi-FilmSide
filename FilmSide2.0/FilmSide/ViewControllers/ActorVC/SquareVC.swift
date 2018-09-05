//
//  SquareVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/21.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class SquareVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ControlDelegate {
    private lazy var filterView:UIView = {[weak self] in
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 45))
        headView.backgroundColor = UIColor.white
        
        let titleArray = ["最新", "最热"]
        let width = (AppWidth-50)/4
        for i in 0..<titleArray.count {
            let btn = UIButton(frame: CGRect(x: 20+(width+50)*CGFloat(i), y: 10, width: width, height: 25))
            btn.setTitle(titleArray[i], for: .normal)
            btn.setTitleColor(titleColor, for: .normal)
            btn.tag = 100+i
            btn.layer.cornerRadius = 12.5
            btn.backgroundColor = UIColor.white
            btn.addTarget(self!, action: #selector(self!.btnClick(sender:)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            self!.btnArray.append(btn)
            headView.addSubview(btn)
            if i == 0 {
                btn.backgroundColor = skinColor
                btn.setTitleColor(UIColor.white, for: .normal)
            }
        }
        
        return headView
    }()
    private lazy var btnArray:[UIButton] = {
        return [UIButton]()
    }()
    private lazy var headView:UIView = { [weak self] in
        let head = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 90))
        head.backgroundColor = backColor
        head.addSubview(self!.filterView)
        
        return head
    }()
    private lazy var childTableView:UITableView = {[weak self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 50, width: AppWidth, height: NaviTabH-50), style: .plain)
        tableView.delegate = self!
        tableView.dataSource = self!
        tableView.tableViewDefault()
        tableView.sectionFooterHeight = 0.0001
        tableView.backgroundColor = backColor
        
        return tableView
    }()
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
    private let identifierBox = "box"
    private let identifierHead = "head"
    private let identifierBottom = "bottom"
    private let identifierImage = "image"
    var current:Int = 1
    var orderBy = 1
    var models = [InvitionModel]()
    //首页-0
    var sourceType = 0
    var status = -1
    var squareId:Int?
    var isEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        navigationBarTintColor()
        navigationItem.title = "广场"
        self.view.addSubview(headView)
        self.view.addSubview(childTableView)
        childTableView.register(BoxCell.self, forCellReuseIdentifier: identifierBox)
        childTableView.register(UINib(nibName: "TrendsHeadCell", bundle: nil), forCellReuseIdentifier: identifierHead)
        for i in 0..<imageCells.count {
            childTableView.register(UINib(nibName: imageCells[i], bundle: nil), forCellReuseIdentifier: cellIdentifers[i])
        }
        childTableView.register(UINib(nibName: "BottomCell", bundle: nil), forCellReuseIdentifier: identifierBottom)
        
        childTableView.addHeadFreshView(target: self, action: #selector(pullFresh))
        childTableView.addFootFreshView(target: self, action: #selector(getRequest))
        pullFresh()
        childTableView.frame.size.height = NaviViewH-50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pullFresh()
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if models.count <= 0 {
            return 0
        } else if models.count <= 6 {
            return models.count
        } else {
            return models.count-5
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && models.count > 6 {
            return 1
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && models.count > 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier:identifierBox) as? BoxCell
            cell?.column = 3
            cell?.row = 1
            cell?.dataModels = worksModel
            cell?.publicDelegate = self

            return cell!
        }else{
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierHead) as? TrendsHeadCell
                cell?.publicDelegate = self
                cell?.selectionStyle = .none
                if models.count > 6 {
                    cell?.model = models[section+5]
                } else {
                    cell?.model = models[section]
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
                    model = models[section+5]
                } else {
                    model = models[section]
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
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierBottom) as? BottomCell
                if models.count > 6 {
                    cell?.model = models[section+5]
                } else {
                    cell?.model = models[section]
                }
                cell?.publicDelegate = self
                
                return cell!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && models.count > 6 {
            return (AppWidth-40)/9*4+21
        }
        
        if row == 1 {
            if models.count > 6 {
                section = indexPath.section+5
            }
            if models[section].imgList?.count > 0 {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.00001
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var section = indexPath.section
        if models.count > 6 {
            section = indexPath.section+5
        }
        
        let model = models[section]
        let detailVC = NewsDetailVC()
        detailVC.squareId = model.id
        detailVC.detailModel = model
        detailVC.imageModel = model.imgList
        navigationController?.pushViewController(detailVC.hiddenTabBar(), animated: true)
    }
    
    func cellDefault() -> UITableViewCell {
        var cell = childTableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        return cell!
    }
    
    func shareClick(){
        let naviCtrl = UINavigationController(rootViewController: DeliverVC(nibName: "DeliverVC", bundle: nil))
        present(naviCtrl, animated: true, completion: nil)
    }
    
    func btnClick(sender: UIButton) {
        for btn in btnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(titleColor, for: .normal)
        }
        orderBy = sender.tag-100+1
        sender.backgroundColor = skinColor
        sender.setTitleColor(UIColor.white, for: .normal)
        self.current = 1
        pullFresh()
    }
    
    func dataHandler(type: Any?, data: Any?) {
        let types = type as? String
        if types == "user" {
            let interVC = IndividualVC()
            let model = data as? InvitionModel
            interVC.actorid = model?.actorId
            navigationController?.pushViewController(interVC.hiddenTabBar(), animated: true)
        } else if types == "hot" {
            let detailVC = NewsDetailVC()
            detailVC.squareId = data as? Int
            for model in models {
                if model.id == detailVC.squareId {
                    detailVC.detailModel = model
                    detailVC.imageModel = model.imgList
                    break
                }
            }
            navigationController?.pushViewController(detailVC.hiddenTabBar(), animated: true)
        } else if types == "agree" {
            if AppConst.userid == nil {
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil).addNavigation()
                self.present(loginVC, animated: true, completion: nil)
                return
            }
            status = 1
            squareId = data as? Int
            self.forwardNews()
        } else if types == "forward" {
            if AppConst.userid == nil {
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil).addNavigation()
                self.present(loginVC, animated: true, completion: nil)
                return
            }
            status = 3
            squareId = data as? Int
            let model = data as? InvitionModel
            let object = UMShareWebpageObject()
            object.title = "go艺广场"
            object.descr = model?.content
            squareId = model?.id
            if squareId != nil {
                object.webpageUrl = "\(AppConst.FormalServer)/admin/square/toSquare?squareId=\(model!.id!)"
            }
            UmengEngine.instance.showShareView(object: object, complete: {
                self.forwardNews()
            })
//            let tmp = data as? InvitionModel
//            let derVC = DeliverVC(nibName: "DeliverVC", bundle: nil)
//            derVC.sourceType = 2
//            derVC.content = tmp?.content
//            self.present(derVC.addNavigation().hiddenTabBar(), animated: true, completion: nil)
        }
    }
    
    func pullFresh(){
        self.current = 1
        isEnd = false
        getRequest()
    }
    
    func getRequest(){
        if isEnd {
            self.childTableView.closeHeadRefresh()
            self.childTableView.closeFooterRefresh()
            return
        }
        loadHUD()
        
        var params = ["orderBy": orderBy, "curPage":current] as [String: Any]
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
                        self.childTableView.reloadData()
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
