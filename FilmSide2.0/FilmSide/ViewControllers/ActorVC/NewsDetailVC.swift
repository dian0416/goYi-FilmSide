//
//  NewsDetailVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/23.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya
import IQKeyboardManagerSwift
import ESPullToRefresh

class NewsDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ControlDelegate {
    private let identifierArt = "article"
    private let identifierBottom = "bottom"
    private let identifierTool = "tool"
    private let identifierUser = "user"
    private let identifierTent = "tent"
    private let identifierHead = "head"
    private lazy var childTableView:UITableView = {[weak self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NaviViewH-50), style: .plain)
        tableView.delegate = self!
        tableView.dataSource = self!
        tableView.tableViewDefault()
        tableView.backgroundColor = lightColor
        tableView.separatorColor = backColor
        
        return tableView
    }()
    private lazy var inboxView:InputView = {
        let input = InputView(frame: CGRect(x: 0, y: NaviViewH-50, width: AppWidth, height: 50))
        input.publicDelegate = self
        
        return input
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
    var squareId:Int?
    var detailModel:InvitionModel?
    var imageModel:[InvitionImageModel]?
    var agreeModel:[AgreeModel]?
    var comments = [CommentModel]()
    var current:Int = 1
    var reviewerId:Int?
    var reviewer:String?
    var content:String?
    var status:Int = 0
    var isEnd = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Uncomment the following line to preserve selection between presentations
        navigationItem.title = "新鲜事正文"
        navigationBarTintColor()
        self.view.addSubview(childTableView)
        self.view.addSubview(inboxView)
        
        childTableView.register(TrendsBottomCell.self, forCellReuseIdentifier: identifierBottom)
        childTableView.register(UINib(nibName: "NewsTentCell", bundle: nil), forCellReuseIdentifier: identifierArt)
        childTableView.register(UINib(nibName: "TrendsHeadCell", bundle: nil), forCellReuseIdentifier: identifierHead)
        childTableView.register(UINib(nibName: "ToolCell", bundle: nil), forCellReuseIdentifier: identifierTool)
        childTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: identifierUser)
        childTableView.register(UINib(nibName: "TentCell", bundle: nil), forCellReuseIdentifier: identifierTent)
        for i in 0..<imageCells.count {
            childTableView.register(UINib(nibName: imageCells[i], bundle: nil), forCellReuseIdentifier: cellIdentifers[i])
        }
        childTableView.addHeadFreshView(target: self, action: #selector(pullFresh))
        childTableView.addFootFreshView(target: self, action: #selector(loadData))
        getDetailNews()
        queryBeenComment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if detailModel != nil {
            count = 1
        } else {
            return 0
        }
        if comments.count > 0 {
            count += comments.count
        }
        
        return count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        if comments.count > 0 {
            let model = comments[section-1]
            if model.beenCommentList?.count > 0  {
                return model.beenCommentList!.count+1
            }
            return 1
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierHead) as? TrendsHeadCell
                cell?.publicDelegate = self
                cell?.selectionStyle = .none
                cell?.model = detailModel
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
                var count = 0
                var images = [String?]()
                if imageModel != nil {
                    for model in imageModel! {
                        images.append(model.imgUrl)
                    }
                }
                if images.count == 0 {
                    return cellDefault()
                } else if images.count > 9 {
                    count = 9
                } else {
                    count = images.count
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifers[count-1]) as? BaseViewCell
                cell?.textLabel?.isHidden = true
                cell?.detailTextLabel?.isHidden = true
                cell?.images = images
                cell?.selectionStyle = .none
                cell?.separatorHidden()
                
                return cell!
            } else if row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierBottom) as? TrendsBottomCell
                if let praise = detailModel?.praise {
                    cell?.agreeBtn.setTitle("\(praise)", for: .normal)
                    cell?.agreeBtn.isSelected = false
                    if detailModel?.praiseType > 0 {
                        cell?.agreeBtn.isSelected = true
                    } else {
                        cell?.agreeBtn.isSelected = false
                    }
                }
                cell?.publicDelegate = self
                cell?.models = agreeModel
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierTool) as? ToolCell
                cell?.separatorZero()
                cell?.publicDelegate = self
                
                if let mark = detailModel?.commentCount {
                    cell?.markBtn.setTitle("\(mark)", for: .normal)
                }
                if let mark = detailModel?.forward {
                    cell?.forwardBtn.setTitle("\(mark)", for: .normal)
                }
                
                return cell!
            }
        } else {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierUser) as? CommentCell
                cell?.publicDelegate = self
                cell?.model = comments[section-1]
                cell?.separatorHidden()
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierTent) as? TentCell
                cell?.publicDelegate = self
                cell?.model = comments[section-1].beenCommentList?[row-1]
                if row == comments[section-1].beenCommentList?.count {
                    cell?.textBottom.constant = 12
                } else {
                    cell?.textBottom.constant = 0
                }
                
                return cell!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && row == 2 {
            let listVC = UserLIstVC()
            listVC.squareId = detailModel?.id
            navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 1 && (imageModel == nil || imageModel!.count == 0 ){
                return 0
            }
            if row == 2 {
                return (AppWidth-160)/6+20
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    func cellDefault() -> UITableViewCell {
        var cell = childTableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        return cell!
    }
    
    func dataHandler(type: Any?, data: Any?) {
        let tmp = type as? String
        if tmp == "user" {
            let interVC = IndividualVC()
            if let id = data as? Int {
                interVC.actorid = id
            } else {
                interVC.actorid = (data as? InvitionModel)?.actorId
            }
            
            navigationController?.pushViewController(interVC.hiddenTabBar(), animated: true)
        } else if tmp == "agree" {
            if AppConst.userid == nil {
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil).addNavigation()
                self.present(loginVC, animated: true, completion: nil)
                return
            }
            status = 1
            self.forwardNews()
        } else if tmp == "forward" {
            if AppConst.userid == nil {
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil).addNavigation()
                self.present(loginVC, animated: true, completion: nil)
                return
            }
            let object = UMShareWebpageObject()
            object.title = "go艺广场"
            object.descr = detailModel?.content
            if detailModel?.id != nil {
                object.webpageUrl = "\(AppConst.FormalServer)/admin/square/toSquare?squareId=\(detailModel!.id!)"
            }
            UmengEngine.instance.showShareView(object: object, complete: {
                self.forwardNews()
            })
        } else if tmp == "tent" {
            let model = data as? CommentModel
            reviewerId = model?.id
            inboxView.textFiled.becomeFirstResponder()
            if let name = model?.realName {
                inboxView.textFiled.placeholder = "回复:\(name)"
            }
        } else if tmp == "send" {
            if AppConst.userid == nil {
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil).addNavigation()
                self.present(loginVC, animated: true, completion: nil)
                return
            }
            content = data as? String
            if content?.length() > 0 {
                commentNews()
            } else {
                textHUD("请输入评论内容")
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        inboxView.textFiled.placeholder = "我也来留个言..."
        reviewerId = nil
        self.hideKeyboard()
    }
    
    func pullFresh(){
        self.current = 1
        getDetailNews()
        queryBeenComment()
    }
    
    func loadData(){
        if isEnd  {
            self.childTableView.closeHeadRefresh()
            self.childTableView.closeFooterRefresh()
            return
        }
        getDetailNews()
        queryBeenComment()
    }
    
    //获取详情
    func getDetailNews() {
        if squareId == nil || AppConst.userid == nil {
            return
        }
        var params = ["squareId": squareId!] as [String : Any]
        if AppConst.userid != nil {
            params["actorId"] = AppConst.userid
        }
        loadHUD()
        
        MoyaProvider<User>().request(.getDeatilNews(params: params)) { resp in
            do {
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        let model = InvitionModel.deserialize(from: value, designatedPath: "squareVO.master")
                        if self.detailModel != nil {
                            self.detailModel?.praiseType = model!.praiseType
                            self.detailModel?.praise = model!.praise
                            self.detailModel?.commentCount = model!.commentCount
                            self.detailModel?.forward = model!.forward
                        } else {
                            self.detailModel = model
                        }
                        self.imageModel = [InvitionImageModel].deserialize(from: value, designatedPath: "squareVO.imgList") as? [InvitionImageModel]
                        self.agreeModel = [AgreeModel].deserialize(from: value, designatedPath: "squareVO.praiseList") as? [AgreeModel]
                        self.childTableView.reloadData()
                        self.hideHUD()
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
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
            }
        }
    }
    
    //评论内容
    func commentNews() {
        var params = ["reviewerId": AppConst.userid!] as [String : Any]
        if reviewerId != nil {
            params["squareId"] = reviewerId!
        } else {
            params["squareId"] = squareId!
        }
        params["content"] = content
        loadHUD()
        
        MoyaProvider<User>().request(.commentInfo(params: params)) { resp in
            do {
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value) {
                    if status.status == 0 {
                        self.reviewerId = nil
                        self.inboxView.textFiled.text = nil
                        self.hideKeyboard()
                        self.current = 1
                        self.pullFresh()
                        self.inboxView.textFiled.placeholder = "我也来留个言..."
                        self.hideHUD()
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
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
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
                        self.hideHUD()
                        if self.status == 1 {
                            AppConst.writeVale(key: "a_\(self.squareId!)", value: true)
                        }
                        self.pullFresh()
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
    
    //获取评论内容
    func queryBeenComment() {
        if squareId == nil {
            return
        }
        var params = ["squareId": squareId!] as [String : Any]
        params["curPage"] = current
        loadHUD()
        
        MoyaProvider<User>().request(.queryBeenComment(params: params)) { resp in
            do {
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        if let models = [CommentModel].deserialize(from: value, designatedPath: "pageBean.items") as? [CommentModel]{
                            if self.current == 1 {
                                self.comments = models
                            } else {
                                self.comments.append(contentsOf: models)
                            }
                            if models.count > 0 {
                                self.current += 1
                                self.isEnd = false
                            } else {
                                self.isEnd = true
                            }
                        }
                        self.childTableView.reloadData()
                        self.hideHUD()
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
                self.childTableView.closeHeadRefresh()
                self.childTableView.closeFooterRefresh()
            }
        }
    }

}
