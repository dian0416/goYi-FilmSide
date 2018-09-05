//
//  PersonVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class PersonVC: UITableViewController, ControlDelegate {
    private lazy var headImageView: MeHeaderView = {[weak self] in
        let imageView = Bundle.main.loadNibNamed("MeHeaderView", owner: self, options: nil)?.last as? MeHeaderView
        imageView?.backImageView.image = UIImage.init(named: "图层-352")
        imageView?.headImageView.loadImage(AppConst.headImage)
        imageView?.telLabel.text = AppConst.mobile ?? ""
        imageView?.nameLabel.text = AppConst.realName
        if AppConst.sex == "男"{
            imageView?.sexImageView.image = UIImage.init(named: "male")
        }else{
            imageView?.sexImageView.image = UIImage.init(named: "famale")
        }

        imageView?.editBtn.addTarget(self, action: #selector(editInfo), for: .touchUpInside)
        return imageView!
    }()
//    private lazy var  headerView :
    private lazy var titleArray: [(image:String, title:String)] = {
        return [("个人", "实名认证"), ("二维码邀请", "获取邀请码"), ("意见反馈-(1)", "意见反馈"), ("握手", "用户协议")]
    }()
    private lazy var infos: [(title:String, value:String?)] = {
        return [("姓名", AppConst.realName), ("性别", AppConst.sex), ("联系方式", AppConst.mobile)]
    }()
    private let identifierver = "ver"
    private let identifierWrite = "write"
    //0-女 1-男
    private var sex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        navigationBarTintColor()
        tableView.tableViewDefault()
        tableView.isScrollEnabled = false
//        tableView.tableHeaderView = headImageView
        tableView.register(UINib(nibName: "VerificationCell", bundle: nil), forCellReuseIdentifier: identifierver)
        tableView.register(UINib(nibName: "WriteInfoCell", bundle: nil), forCellReuseIdentifier: identifierWrite)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        infos[0].value = AppConst.realName
        infos[1].value = AppConst.sex
        infos[2].value = AppConst.mobile
        getRequest()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section != 4 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                
                cell?.textLabel?.textColor = titleColor
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell?.accessoryType = .disclosureIndicator
            }
            cell?.imageView?.image = UIImage(named: titleArray[section].image)
            cell?.textLabel?.text = titleArray[section].title
            
            return cell!
        } else {
            let identifier = "button"
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
                
                let outLabel = UILabel(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 44))
                outLabel.font = UIFont.systemFont(ofSize: 15)
                outLabel.textColor = skinColor
                outLabel.textAlignment = .center
                outLabel.text = "退出登录"
                
                cell?.contentView.addSubview(outLabel)
            }
            
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
//        let row = indexPath.row
        
        if section == 0 {
            navigationController?.pushViewController(VerificationVC().hiddenTabBar(), animated: true)
        }else if section == 1 {
            inviteRequest()
//                let object = UMShareWebpageObject()
//                object.title = "go艺，快速有效的找到饰演角色"
//                //            object.descr = model?.content
//                object.webpageUrl = "\(AppConst.FormalServer)/admin/actorInvitation/getMobile.action"
//                UmengEngine.instance.showShareView(object: object, complete: {
//
//                })
        } else if section == 2 {
            navigationController?.pushViewController(AboutVC().hiddenTabBar(), animated: true)
//            if row == 1 {
//                let webVC = WebVC()
//                webVC.title = "用户协议"
//                webVC.urlString = "http://www.baidu.com"
//                navigationController?.pushViewController(webVC.hiddenTabBar(), animated: true)
//            } else {
//                navigationController?.pushViewController(AboutVC().hiddenTabBar(), animated: true)
//            }
        } else if section == 3 {
            let webVC = WebVC()
            webVC.title = "用户协议"
            webVC.urlString = "http://www.baidu.com"
            navigationController?.pushViewController(webVC.hiddenTabBar(), animated: true)
        }else if section == 4{
            for user in userDef.dictionaryRepresentation() {
                userDef.removeObject(forKey: user.key)
            }
            userDef.synchronize()
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 310
        }
        return 10
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headImageView
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 10))
        view.backgroundColor = lineColor
        return view
    }
    
    func editInfo(){
        let editVC = EditVC(nibName: "EditVC", bundle: nil)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    func dataHandler(type: Any?, data: Any?) {
        let index = type as? IndexPath
        infos[index!.row].value = data as? String
    }
    func getRequest(){
        MoyaProvider<User>().request(.actorCard()) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        let model = CardModel.deserialize(from: value, designatedPath: "crewCard")
                        //0 未审核 1 审核通过 2 审核不通过
                        if model?.state == 0 {
                            AppConst.writeVale(key: "auth", value: "待审核")
                        } else if model?.state == 1 {
                            AppConst.writeVale(key: "auth", value: "已认证")
                        }else if model?.state == 2 {
                            AppConst.writeVale(key: "auth", value: "认证失败")
                        } else {
                            AppConst.writeVale(key: "auth", value: "未认证")
                        }
                        self.tableView.reloadData()
                    } else if let msg = status.msg {
                        self.textHUD(msg)
                    } else {
//                        self.textHUD("网络错误, 请稍后重试")
                    }
                } else {
//                    self.textHUD("网络错误, 请稍后重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    
    func inviteRequest(){
        loadHUD()
        MoyaProvider<User>().request(.inviteCode(params: ["crewId": AppConst.userid!])) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value) {
                    if status.status == 0 {
                        self.textHUD("邀请码已发送至您的手机")
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
            }
        }
    }

}
