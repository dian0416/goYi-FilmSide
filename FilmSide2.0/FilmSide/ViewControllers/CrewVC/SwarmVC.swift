//
//  SwarmVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class SwarmVC: UITableViewController, ControlDelegate {
    private let identiferinfo = "info"
    private let identiferuser = "user"
    //0-剧名 1-角色
    var sourceType = 0
    var models = [SwarmModel]()
    var current = 1
    var filmId:Int?
    var lineId:Int?
    var broker:Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        navigationBarTintColor()
        tableView.tableViewDefault()
//        tableView.tableHeaderView = headView
        tableView.register(UINib(nibName: "SwarmCell", bundle: nil), forCellReuseIdentifier: identiferinfo)
        tableView.register(UINib(nibName: "UserHeadCell", bundle: nil), forCellReuseIdentifier: identiferuser)
        tableView.addHeadFreshView(target: self, action: #selector(pullFresh))
        tableView.addFootFreshView(target: self, action: #selector(loadMore))
        pullFresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identiferinfo) as? SwarmCell
            cell?.separatorZero()
            cell?.model = models[section]
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identiferuser) as? UserHeadCell
//            cell?.accessoryType = .disclosureIndicator
            cell?.actors = models[section].actorList
            let model = models[section]
            if let count = model.signCount {
                if count > model.personCount {
                    cell?.descLabel.text = "已满"
                    cell?.descLabel.textColor = skinColor
                } else {
                    cell?.descLabel.text = "已有\(count)人报名"
                    cell?.descLabel.textColor = subColor
                }
            }
            
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 10
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let row = indexPath.row
//        if row == 1 {
//            let userVC = UserLIstVC().hiddenTabBar()
//            userVC.navigationItem.title = "报名人数"
//            navigationController?.pushViewController(userVC, animated: true)
//        }
    }
    
    func dataHandler(type: Any?, data: Any?) {
        let tmp = type as? String
        if tmp == nil {
            if sourceType == 0 && data as! String == "●●●" {
                let fiterVC = FilterListVC(collectionViewLayout: YMButtonFlowLayout()).hiddenTabBar()
                navigationController?.pushViewController(fiterVC, animated: true)
                return
            }
            if sourceType == 1 {
                return
            }
            let swarVC = SwarmVC(style: .plain)
            swarVC.sourceType = 1
            swarVC.navigationItem.title = data as? String
            navigationController?.pushViewController(swarVC.hiddenTabBar(), animated: true)
        }
    }
    
    func pullFresh(){
        current = 1
        swarmList()
    }
    
    func loadMore(){
        swarmList()
    }
    
    func swarmList(){
        loadHUD()
        
        var params = ["crewId": AppConst.userid!]//AppConst.userid!
        params["curPage"] = current
        if broker == 1 {
            params["broker"] = 1
        } else if broker == 2 {
            params["broker"] = 0
        }
        params["messageId"] = filmId
        params["lineId"] = lineId
        
        MoyaProvider<User>().request(.swarmList(params: params)) { resp in
            do {
                self.tableView.closeHeadRefresh()
                self.tableView.closeFooterRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        if let model = [SwarmModel].deserialize(from: value, designatedPath: "pageBean.items") as? [SwarmModel]{
                            if self.current == 1 {
                                self.models = model
                            } else {
                                self.models.append(contentsOf: model)
                            }
                            if model.count > 0 {
                                self.current += 1
                            }
                            self.hideHUD()
                        } else {
                            self.textHUD("无数据")
                        }
                        self.tableView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2, execute: { 
                            self.tableView.reloadData()
                        })
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

}
