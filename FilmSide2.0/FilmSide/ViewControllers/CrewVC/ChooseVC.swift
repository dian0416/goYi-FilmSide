//
//  ChooseVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class ChooseVC: UITableViewController, ControlDelegate {
    private lazy var headView: YMLabelCloud = {[unowned self] in
        var cloud = YMLabelCloud(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 0))
        cloud.publicDelegate = self
        if self.sourceType == 0 {
            cloud.row = 0
        } else {
            cloud.row = 4
        }
        
        return cloud
    }()
    private lazy var titleArray:[(key:String?, value:String?)] = {
        return [(key:String?, value:String?)]()
    }()
    var models = [ActorModel]()
    var films:[FilmInfoModel]?
    var lines:[LabelModel]?
    var roles:[PersonModel]?
    var current:Int = 1
    private let identiferchoose = "choose"
    var isEnd = false
    //0-剧名 1-角色 2-线位
    var sourceType = 0
    var filmId:Int?
    var lineId:Int?
    var roleId:Int?
    var broker:Int?
    var mobile:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        navigationBarTintColor()
        tableView.tableViewDefault()
        tableView.register(UINib(nibName: "ChooseCell", bundle: nil), forCellReuseIdentifier: identiferchoose)
        tableView.addHeadFreshView(target: self, action: #selector(pullFresh))
        tableView.addFootFreshView(target: self, action: #selector(loadMore))
        if sourceType == 0 {
            filmList()
        } else if sourceType == 1 {
            lineList()
        } else if sourceType == 2 {
            roleList()
        }
        pullFresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        headView.noCheck(sender: UIButton())
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: identiferchoose) as? ChooseCell
        cell?.publicDelegate = self
        cell?.model = models[section]
        cell?.levelLabel.isHidden = true

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 10
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = models[indexPath.section]
        let interVC = IndividualVC()
        interVC.actorid = model.actorId
        navigationController?.pushViewController(interVC.hiddenTabBar(), animated: true)
    }
    
    func dataHandler(type: Any?, data: Any?) {
        let tmp = type as? String
        if tmp == "fav" {
            if let tid = (data as? ActorModel)?.actorId {
                favRequest(aid: tid)
            }
        } else if tmp == "disfav" {
//            if let tid = data as? Int {
//                disFav(aid: tid)
//            }
        } else if tmp == "note" {
            if let model = data as? ActorModel {
                noteRequest(model: model)
                bxRequest(model: model)
            }
            if let mobile = (data as? ActorModel)?.mobile {
                let alertVC = UIAlertController(title: "通知面试", message: "\(mobile)", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                alertVC.addAction(UIAlertAction(title: "拨打电话", style: .destructive, handler: { (_) in
                    UIApplication.shared.openURL(URL(string: "tel://\(mobile)")!)
                }))
                self.present(alertVC, animated: true, completion: nil)
            }
        } else {
            let tmpd = data as? (key:String?, value:String?)
            if sourceType == 0 && tmpd?.value == "●●●" {
                let fiterVC = FilterListVC(collectionViewLayout: YMButtonFlowLayout())
                fiterVC.sourceType = 1
                navigationController?.pushViewController(fiterVC.hiddenTabBar(), animated: true)
                return
            }
            
            if tmpd?.value == "群演" {
                let swarmVC = SwarmVC(style: .plain)
                swarmVC.navigationItem.title = "群演"
                swarmVC.filmId = filmId
                if let id = type as? String {
                    swarmVC.lineId = Int(id)
                }
                navigationController?.pushViewController(swarmVC.hiddenTabBar(), animated: true)
                return
            }
            
            let chooseVC = ChooseVC(style: .plain)
            chooseVC.sourceType = sourceType+1
            chooseVC.navigationItem.title = tmpd?.value
            if sourceType == 0 {
                chooseVC.filmId = Int(tmpd!.key!)
            } else if sourceType == 1 {
                chooseVC.filmId = filmId
                chooseVC.lineId = Int(tmpd!.key!)
            } else if sourceType == 2 {
                chooseVC.filmId = filmId
                chooseVC.lineId = lineId
                chooseVC.roleId = Int(tmpd!.key!)
            }
            chooseVC.broker = broker
            navigationController?.pushViewController(chooseVC.hiddenTabBar(), animated: true)
        }
    }
    
    func pullFresh(){
        current = 1
        actorList()
        if sourceType == 0 {
            filmList()
        } else if sourceType == 1 {
            lineList()
        }  else if sourceType == 2 {
            if lineId != 4 {
                roleList()
            }
        }
    }
    
    func loadMore(){
        if isEnd {
            tableView.closeFooterRefresh()
            tableView.closeHeadRefresh()
            return
        }
        current += 1
        actorList()
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
                    self.titleArray.removeAll()
                    if self.films != nil {
                        for i in 0..<self.films!.count {
                            var tid = ""
                            let film = self.films![i]
                            if let id = film.id {
                                tid = "\(id)"
                            }
                            if i == 6 {
                                self.titleArray.append((nil, "●●●"))
                            } else if i < 6 {
                                self.titleArray.append((tid, film.filmName))
                            }
                        }
                    }
                    self.headView.titeArray = self.titleArray
                    if self.titleArray.count > 0 {
                        self.tableView.tableHeaderView = self.headView
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
    
    func lineList(){
        loadHUD()
        let params = ["messageId": 0] as [String:Any]
        MoyaProvider<User>().request(.lineGet(params:params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value, designatedPath:"result")
                if status?.status == 0 {
                    self.lines = [LabelModel].deserialize(from: value, designatedPath: "DLineList") as? [LabelModel]
                    self.titleArray.removeAll()
                    if self.lines != nil {
                        for line in self.lines! {
                            var tid = ""
                            if let id = line.id {
                                tid = "\(id)"
                            }
                            self.titleArray.append((tid, line.lineName))
                        }
                    }
                    self.headView.row = 4
                    self.headView.titeArray = self.titleArray
                    if self.titleArray.count > 0 {
                        self.tableView.tableHeaderView = self.headView
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

    func roleList(){
        loadHUD()
        
        let params = ["messageId": filmId!, "lineId":lineId!]
        MoyaProvider<User>().request(.roleGet(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value, designatedPath:"result")
                if status?.status == 0 {
                    self.roles = [PersonModel].deserialize(from: value, designatedPath: "crewRoleWrapperList") as? [PersonModel]
                    self.titleArray.removeAll()
                    if self.roles != nil {
                        for role in self.roles! {
                            var tid = ""
                            if let id = role.id {
                                tid = "\(id)"
                            }
                            self.titleArray.append((tid, role.roleName))
                        }
                    }
                    self.headView.titeArray = self.titleArray
                    if self.titleArray.count > 0 {
                        self.tableView.tableHeaderView = self.headView
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
        
        var params = ["crewId": AppConst.userid!]//
//        params["type"] = 0
        params["curPage"] = current
        if broker == 1 {
            params["broker"] = 1
        } else if broker == 2 {
            params["broker"] = 0
        }
        if sourceType == 1 {
            params["messageId"] = filmId
        } else if sourceType == 2 {
            params["messageId"] = filmId
            params["lineId"] = lineId
        } else if sourceType == 3 {
            params["messageId"] = filmId
            params["lineId"] = lineId
            params["roleId"] = roleId
        }
        
        MoyaProvider<User>().request(.roleList(params: params)) { resp in
            do {
                self.tableView.closeHeadRefresh()
                self.tableView.closeFooterRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        if let model = [ActorModel].deserialize(from: value, designatedPath: "pageBean.items") as? [ActorModel]{
                            if self.current == 1 {
                                self.models = model
                            } else {
                                self.models.append(contentsOf: model)
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
                        self.tableView.reloadData()
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
                self.tableView.closeHeadRefresh()
                self.tableView.closeFooterRefresh()
            }
        }
    }
    
    func favRequest(aid: Int){
        loadHUD()
        var params = [String: Any]()
        params["crewId"] = AppConst.userid!
        params["actorId"] = aid
        params["type"] = 1
        MoyaProvider<User>().request(.favActor(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value)
                if status?.status == 0 {
                    self.textHUD("收藏成功")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: {
                        self.pullFresh()
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
    
    func bxRequest(model: ActorModel){
        loadHUD()
        var params = [String: Any]()
        params["crewId"] = AppConst.userid
        params["actorId"] = model.actorId
        params["roleId"] = model.roleId
        params["type"] = 0
        MoyaProvider<User>().request(.favActor(params: params)) { resp in
            do {
                self.hideHUD()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value)
                if status?.status == 0 {
                    self.textHUD(status!.msg!)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: {
                        self.pullFresh()
                    })
                    
                } else if let msg = status?.msg {
                    self.textHUD(msg)
                } else {
                    self.textHUD("网络错误, 请稍后重试")
                }
            } catch {
//                let printableError = error as CustomStringConvertible
//                self.textHUD(printableError.description)
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
    
    func noteRequest(model: ActorModel){
        loadHUD()
        var params = [String: Any]()
        params["roleid"] = model.roleId
        params["actorid"] = model.actorId
        params["messageid"] = model.messageId
        MoyaProvider<User>().request(.smsRequest(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value)
                if status?.status == 0 {
                    self.textHUD("已通知")
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
