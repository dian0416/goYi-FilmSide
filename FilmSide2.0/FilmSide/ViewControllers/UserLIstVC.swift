//
//  UserLIstVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class UserLIstVC: UITableViewController {
    var models = [AgreeModel]()
    var squareId:Int?
    var current = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        navigationBarTintColor()
        navigationItem.title = "点赞列表"
        tableView.tableViewDefault()
        tableView.addHeadFreshView(target: self, action: #selector(pullFresh))
        tableView.addFootFreshView(target: self, action: #selector(getRequest))
        getRequest()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as? BaseViewCell
        
        if cell == nil {
            cell = BaseViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
            cell?.separatorZero()
            
            cell?.textLabel?.textColor = skinColor
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.detailTextLabel?.textColor = subColor
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
            
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.imageView?.loadImage(models[row].headImg)
        cell?.imageView?.layer.cornerRadius = 30
        cell?.imageView?.clipsToBounds = true
        cell?.textLabel?.text = models[row].nickName
        cell?.detailTextLabel?.text = models[row].integralName

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        let interVC = IndividualVC()
        interVC.actorid = models[row].actorId
        navigationController?.pushViewController(interVC.hiddenTabBar(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func pullFresh(){
        self.current = 1
        
        getRequest()
    }
    
    func getRequest(){
        if squareId == nil {
            return
        }
        loadHUD()
        
        let params = ["squareId":squareId!, "curPage":current] as [String: Any]
        
        MoyaProvider<User>().request(.praiseList(params: params)) { resp in
            do {
                self.tableView.closeHeadRefresh()
                self.tableView.closeFooterRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        if let model = [AgreeModel].deserialize(from: value, designatedPath: "pageBean.items") as? [AgreeModel]{
                            if self.current == 1 {
                                self.models = model
                            } else {
                                self.models.append(contentsOf: model)
                            }
                            if model.count > 0 {
                                self.current += 1
                            }
                        }
                        self.hideHUD()
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

}
