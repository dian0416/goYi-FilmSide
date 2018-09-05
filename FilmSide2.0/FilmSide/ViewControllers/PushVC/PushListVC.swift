//
//  PushListVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/5/1.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class PushListVC: UIViewController, UITableViewDataSource, UITableViewDelegate,ControlDelegate,UISearchBarDelegate {
    private lazy var titleArray: [String] = {
        return ["院线电影","网络剧","网络电影","电视剧","商业活动"]
    }()
    private lazy var titleArrayPlus: [String] = {
        return ["+院线电影","+网络剧","+网络电影","+电视剧","+商业活动"]
    }()
    private lazy var childTableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NaviTabH), style:.plain)
        tableView.tableViewDefault()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        
        return tableView
    }()
    private lazy var searchBar:UISearchBar = { [unowned self] in
        let view = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 44))
        
        let _searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 44))
        
        _searchBar.backgroundColor = skinColor
        _searchBar.delegate = self
        _searchBar.placeholder = "找剧组类型 片名"
        _searchBar.subviews[0].backgroundColor = skinColor
        _searchBar.subviews[0].subviews[0].removeFromSuperview()
        let searchField = _searchBar.value(forKey: "_searchField") as? UITextField
        searchField?.backgroundColor = UIColor.white
        //        searchField?.layer.cornerRadius = 15
        searchField?.font = UIFont.systemFont(ofSize: 12)
        searchField?.layer.borderWidth = 0.5
        searchField?.layer.borderColor = skinColor.cgColor
        if #available(iOS 11.0, *) {
            searchField?.heightAnchor.constraint(equalToConstant: 44)
        }
        view.addSubview(_searchBar)
        return _searchBar
    }()
    
    
    var models:[FilmInfoModel]?
    private let identifier = "cell"
    private let identifierDetail = "cell1"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarTintColor()
        navigationItem.titleView = searchBar
//        self.view.addSubview(headView)
        self.view.addSubview(childTableView)
        childTableView.register(UINib(nibName: "PushTypeCell", bundle: nil), forCellReuseIdentifier: identifier)
        childTableView.register(UINib(nibName: "PushCrewCell", bundle: nil), forCellReuseIdentifier: identifierDetail)

//        childTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filmList(searchText:"")
    }
    
    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            var mmodels = [FilmInfoModel]()
            if self.models != nil{
                for model in self.models!{
                    
                    if model.movieId == indexPath.section + 1{
                        mmodels.append(model)
                        
                    }
                }
            }
            if mmodels.count == 0{
                return 0
            }else {
                return (AppWidth-10)/3
            }

        }
        return UITableViewAutomaticDimension

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        var mmodels = [FilmInfoModel]()
        if self.models != nil{
            for model in self.models!{
                
                if model.movieId == indexPath.section + 1{
                    mmodels.append(model)
                    
                }
                //                cell?.models = mmodels
            }
        }
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PushTypeCell
            cell?.selectionStyle = .none
            if mmodels.count == 0{
                cell?.typeBtn.setImage(UIImage(named: titleArrayPlus[section]), for: .normal)
            }else{
                cell?.typeBtn.setImage(UIImage(named: titleArray[section]), for: .normal)
            }
            cell?.publicDelegate = self
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierDetail) as? PushCrewCell
        //movieId:Int? //1院线电影 2网络大电影 3电视剧 4网络剧 5商业活动 6综艺
        cell?.models = mmodels

        return cell!
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 10
        }
        
        return 0
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let section = indexPath.section
//        let pushVC = PushVC()
//        pushVC.model = models?[section]
//        navigationController?.pushViewController(pushVC.hiddenTabBar(), animated: true)
    }
    func dataHandler(type: Any?, data: Any?) {
        if type as? String == "pushType" {
            let addVC = AddCrewVC()
            addVC.automaticallyAdjustsScrollViewInsets = false
            self.navigationController?.pushViewController(addVC, animated: true)
        }
        
    }
    //    关键词搜索
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.length() > 0 {
            filmList(searchText: searchBar.text!)
        }
        
        textHUD("请输入搜索关键词")
    }
    func addClick() {
//        let addVC = AddInfoVC(nibName: "AddInfoVC", bundle: nil)
//        self.present(addVC.addNavigation(), animated: true, completion: nil)
//        let section = indexPath.section
//        let pushVC = PushVC()
//        pushVC.model = models?[section]
//        navigationController?.pushViewController(pushVC.hiddenTabBar(), animated: true)
    }
    
    func filmList(searchText:String) {
        loadHUD()
        let params = ["crewId": AppConst.userid ?? 0,"filmName":searchText] as [String : Any]
        MoyaProvider<User>().request(.filmList(params:params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        self.models = [FilmInfoModel].deserialize(from: value, designatedPath: "crewMessageList") as? [FilmInfoModel]
                        if self.models?.count == 0 {
                            self.textHUD("暂无数据")
                        } else {
                            self.hideHUD()
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
