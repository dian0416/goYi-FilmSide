//
//  PushVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/13.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya
import Photos
import AVKit
import MobileCoreServices

class PushVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ControlDelegate, YMImageListVCDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private lazy var headView:UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: AppWidth*362/686))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        let tapZer = UITapGestureRecognizer(target: self, action: #selector(imgClick))
        imgView.addGestureRecognizer(tapZer)
        
        return imgView
    }()
    private lazy var bottom: UIButton = { [unowned self] in
        let button = UIButton(frame: CGRect(x: 0, y: NaviViewH-50, width: AppWidth, height: 50))
        button.backgroundColor = skinColor
        button.setTitle("发布", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        return button
    }()
    private lazy var childTableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NaviViewH-50), style:.plain)
        tableView.tableViewDefault()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = backColor
        
        return tableView
    }()
    private lazy var titleArray: [(key:String, value:String?)] = {
        let titles = ["片名:", "题材:", "影片级别:", "开机时间:", "招募时间:", "拍摄地:", "拍摄周期:", "出品公司:", "主演:", "出品人:", "制片人:", "执行制片人:", "原著:", "编剧:", "导演:", "副导演:", "演员统筹:", "邮箱:", "剧情介绍:"]
        var tups = [(key:String, value:String?)]()
        for title in titles {
            tups.append((title, ""))
        }
        return tups
    }()
    private lazy var actorArray: [[(key:String, value:String)]] = {
        let titles = ["角色名*", "线位*", "年龄*", "性别*", "身高*", "体重*", "角色标签*", "人物小传*"]
        var tups = [(key:String, value:String)]()
        for title in titles {
            tups.append((title, ""))
        }
        return [tups]
    }()
    lazy var lines: [String] = {
        return ["角色", "特约", "前特", "群演"]
    }()
    private lazy var tagArray:[(key:String?, value:String?)] = {
        return [(key:String?, value:String?)]()
    }()
    private let identifier = "cell"
    private let identifierWrite = "write"
    private let identifierButton = "button"
    private let identifierText = "text"
    private let identifierTwo = "two"
    private let identifierBase = "roleBase"
    private let identifierTag = "roleTag"
    private let identifierAction = "roleAction"
    private let identifierGrop = "groupInfo"
    private var headImage:UIImage?
    private lazy var filmTypes: [String] = {
        return ["院线电影", "网络大电影", "电视剧", "网络剧", "商业活动", "综艺"]
    }()
    var model:FilmInfoModel? {
        didSet{
            titleArray[0].value = model?.filmName
            titleArray[1].value = model?.theme
            if let type = model?.movieId {
                titleArray[2].value = filmTypes[type-1]
            }
            titleArray[3].value = model?.startTime
            titleArray[4].value = model?.beginTime
            titleArray[5].value = model?.shotPlace
            titleArray[6].value = model?.shotCycle
            titleArray[7].value = model?.company
            titleArray[8].value = model?.toStar
            titleArray[9].value = model?.publisher
            titleArray[10].value = model?.fileProducer
            titleArray[11].value = model?.executivePorducer
            titleArray[12].value = model?.original
            titleArray[13].value = model?.screenwriter
            titleArray[14].value = model?.director
            titleArray[15].value = model?.deputyDirector
            titleArray[16].value = model?.performerOveral
            titleArray[17].value = model?.email
            titleArray[18].value = model?.storyIntroduction
            headView.loadImage(model?.messageImg)
        }
    }
    var roleModels = [RoleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarTintColor()
        navigationItem.title = "发布"
        self.view.addSubview(childTableView)
        self.view.addSubview(bottom)
        childTableView.register(UINib(nibName: "WriteInfoCell", bundle: nil), forCellReuseIdentifier: identifierWrite)
        childTableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: identifierButton)
        childTableView.register(UINib(nibName: "DescTextCell", bundle: nil), forCellReuseIdentifier: identifierText)
        childTableView.register(UINib(nibName: "TwoTextFieldCell", bundle: nil), forCellReuseIdentifier: identifierTwo)
        childTableView.register(UINib(nibName: "RoleActionCell", bundle: nil), forCellReuseIdentifier: identifierAction)
        childTableView.tableHeaderView = headView
        
        roleRequest()
        
        NotificationCenter.default.addObserver(self, selector: #selector(roleRequest), name: NSNotification.Name("ROLE"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return roleModels.count+2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return titleArray.count
        } else if section <= roleModels.count {
            if let id = roleModels[section-1].lineId {
                if id == 4 {
                    return 3
                }
                return 5
            }
        } else {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row < titleArray.count - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierWrite) as? WriteInfoCell
                cell?.separatorZero()
                cell?.publicDelegate = self
                cell?.indexPath = indexPath
                cell?.texitField.isHidden = true
                
                if titleArray[row].value?.length() > 0 {
                    cell?.titleLabel.text = titleArray[row].key
                    let width = titleArray[row].key.sizeString(font: UIFont.systemFont(ofSize: 15), maxWidth: 150).width
                    cell?.titleWidth.constant = width+5
                    cell?.descLabel.text = titleArray[row].value
                } else {
                    cell?.titleLabel.text = nil
                    cell?.descLabel.text = nil
                }
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierText) as? DescTextCell
                cell?.publicDelegate = self
                if titleArray[row].value?.length() > 0 {
                    cell?.titleLabel.text = titleArray[row].key
                    cell?.descLabel.text = titleArray[row].value
                } else {
                    cell?.titleLabel.text = nil
                    cell?.descLabel.text = nil
                }
                cell?.descLabel.font = UIFont.systemFont(ofSize: 15)
                if cell?.textView != nil {
                    cell?.textView.removeFromSuperview()
                }
                
                return cell!
            }
        } else if section <= roleModels.count {
            let role = roleModels[section-1]
            if role.lineId > 3 && row == 1 {
                var cell = tableView.dequeueReusableCell(withIdentifier: identifierGrop)
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: identifierGrop)
                    cell?.separatorZero()
                    cell?.selectionStyle = .none
                    
                    cell?.textLabel?.textColor = subColor
                    cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                }
                
                cell?.textLabel?.text = "时间: "
                if let time = role.byTime {
                    let ss = "\(time/1000)".stringFormartDate(formart: "yyyy-MM-dd HH:mm")
                    cell?.textLabel?.text = "时间: \(ss)"
                }
                
                return cell!
            } else if (role.lineId < 4 && row < 3) || (role.lineId == 4 && row == 0) {
                var cell = tableView.dequeueReusableCell(withIdentifier: identifierBase)
                if cell == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: identifierBase)
                    cell?.separatorZero()
                    cell?.selectionStyle = .none
                    
                    cell?.textLabel?.textColor = subColor
                    cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                    cell?.detailTextLabel?.textColor = subColor
                    cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
                }
                
                if role.lineId < 4 {
                    if row == 0 {
                        cell?.textLabel?.text = "角色名: "
                        if let name = role.roleName {
                            cell?.textLabel?.text = "角色名: \(name)"
                        }
                        cell?.detailTextLabel?.text = "线位: "
                        if let line = role.lineId {
                            cell?.detailTextLabel?.text = "线位: \(lines[line-1])"
                        }
                    }
                    if row == 1 {
                        cell?.textLabel?.text = "性别: "
                        if let sex = role.sex {
                            let sexs = sex == 0 ? "女":"男"
                            cell?.textLabel?.text = "性别: \(sexs)"
                        }
                        cell?.detailTextLabel?.text = "年龄段: "
                        var ageLow = 0
                        if let age = role.ageLow {
                            ageLow = age
                        }
                        var ageHight = 0
                        if let age = role.ageHigh {
                            ageHight = age
                        }
                        cell?.detailTextLabel?.text = "年龄段: \(ageLow)-\(ageHight)"
                    }
                    
                    if row == 2 {
                        cell?.textLabel?.text = "体重: "
                        cell?.detailTextLabel?.text = "身高: "
                        var weightLow = 0
                        if let wlow = role.weightLow {
                            weightLow = wlow
                        }
                        var weightHigh = 0
                        if let high = role.weightHigh {
                            weightHigh = high
                        }
                        cell?.textLabel?.text = "体重: \(weightLow)-\(weightHigh)KG"
                        
                        var heightLow = 0
                        if let wlow = role.heightLow {
                            heightLow = wlow
                        }
                        var hightHigh = 0
                        if let high = role.heightHigh {
                            hightHigh = high
                        }
                        cell?.detailTextLabel?.text = "身高: \(heightLow)-\(hightHigh)CM"
                    }
                } else {
                    cell?.textLabel?.text = "线位: "
                    if let line = role.lineId {
                        cell?.textLabel?.text = "线位: \(lines[line-1])"
                    }
                    cell?.detailTextLabel?.text = "人数: "
                    if let count = role.personCount {
                        cell?.detailTextLabel?.text = "人数: \(count)"
                    }
                }
                
                return cell!
            } else if row == 3 && role.lineId < 4 {
                var cell = tableView.dequeueReusableCell(withIdentifier: identifierTag)
                if cell == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: identifierTag)
                    cell?.separatorZero()
                    cell?.selectionStyle = .none
                    
                    cell?.textLabel?.textColor = subColor
                    cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                }
                cell?.textLabel?.text = "角色标签: "
                
                var tagView = cell?.contentView.viewWithTag(100) as? YMLabelCloud
                if tagView == nil {
                    tagView = YMLabelCloud(frame: CGRect(x: 90, y: -2, width: AppWidth-90, height: 0))
                    tagView?.tag = 100
                    tagView?.spaceH = 5
                    let size = "爱打架".sizeString(font: UIFont.systemFont(ofSize: 14), maxWidth: AppWidth)
                    tagView?.coruis = size.height/2-2.5
                    tagView?.font = UIFont.systemFont(ofSize: 14)
                    tagView?.itemAble = false
                    tagView?.itemTextColor = subColor
                    cell?.contentView.addSubview(tagView!)
                }
                tagView?.coruis = 8
                tagArray.removeAll()
                if let label = role.labelName1 {
                    if label.length() > 0 {
                        tagArray.append((nil, label))
                    }
                }
                if let label = role.labelName2 {
                    if label.length() > 0 {
                        tagArray.append((nil, label))
                    }
                }
                tagView?.titeArray = tagArray
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierAction) as? RoleActionCell
                cell?.publicDelegate = self
                cell?.model = roleModels[section-1]
                if row == 4 && role.lineId < 4 {
                    cell?.submitBtn.setTitle("修改", for: .normal)
                    cell?.tentLabel.text = "人物小传:\n"
                    if let biography = role.biography {
                        cell?.tentLabel.text = "人物小传:\n\(biography)"
                    }
                }else{
                    cell?.submitBtn.setTitle("修改", for: .normal)
                    cell?.tentLabel.text = "地址: \n"
                    if let addr = role.city {
                        cell?.tentLabel.text = "地址: \(addr)"
                    }
                }
                
                return cell!
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierButton) as? ButtonCell
            cell?.publicDelegate = self
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            let text = titleArray[row].value
            if text?.length() > 0 {
                return UITableViewAutomaticDimension
            }
            
            return 0
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        
        return 10
    }
    
    func btnClick(){
        pushInfo()
    }
    
    func dataHandler(type: Any?, data: Any?) {
        let tmp = type as? String
        
        if tmp == "leftfiled" {
            let dtmp = data as! (text:String?, path:IndexPath?)
            if dtmp.path != nil && dtmp.text != nil {
                actorArray[dtmp.path!.section-1][dtmp.path!.row].value = dtmp.text!
            }
        } else if tmp == "rightfiled" {
            let dtmp = data as! (text:String?, path:IndexPath?)
            if dtmp.path != nil && dtmp.text != nil {
                actorArray[dtmp.path!.section-1][dtmp.path!.row].value = dtmp.text!
            }
        } else if tmp == "role" {
            let roleVC = RoleVC()
            roleVC.title = "添加角色"
            roleVC.msgID = model?.id
            navigationController?.pushViewController(roleVC, animated: true)
        } else if tmp == "qunyan" {
            let qyVC = QunyanVC()
            qyVC.msgID = model?.id
            qyVC.title = "添加群演"
            navigationController?.pushViewController(qyVC, animated: true)
        } else if tmp == "update" {
            let rmodel = data as? RoleModel
            if rmodel?.lineId == 4 {
                let qyVC = QunyanVC()
                qyVC.title = "修改群演"
                qyVC.msgID = model?.id
                qyVC.model = data as? RoleModel
                navigationController?.pushViewController(qyVC, animated: true)
            } else {
                let roleVC = RoleVC()
                roleVC.title = "修改角色"
                roleVC.msgID = model?.id
                roleVC.model = data as? RoleModel
                navigationController?.pushViewController(roleVC, animated: true)
            }
        }
    }
    
    func roleRequest() {
        loadHUD()
        var params = [String: Any]()
        if let id = model?.id {
            params = ["messageId": id]
        }
        MoyaProvider<User>().request(.roleInfo(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        if let models = [RoleModel].deserialize(from: value, designatedPath: "crewRoleList") as? [RoleModel] {
                            self.roleModels = models
                        }
                        self.hideHUD()
                        self.childTableView.reloadData()
                    } else if let msg = status.msg {
                        self.textHUD(msg)
                    } else {
                        self.textHUD("网络错误，请重试")
                    }
                } else {
                    self.textHUD("网络错误，请重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    
    //发布组讯
    func pushInfo() {
        if model?.id == nil {
            return
        }
        let params = ["messageId": model!.id!]
        loadHUD()
        
//        MoyaProvider<User>().request(.pushInfo(params: params)) { resp in
//            do {
//                let response = try? resp.dematerialize()
//                let value = try response?.mapString()
//                if let status = StatusModel.deserialize(from: value) {
//                    if status.status == 0 {
//                        self.textHUD("发布成功")
//                    } else if let msg = status.msg {
//                        self.textHUD(msg)
//                    } else {
//                        self.textHUD("网络错误, 请稍后重试")
//                    }
//                } else {
//                    self.textHUD("网络错误, 请稍后重试")
//                }
//            } catch {
//                let printableError = error as CustomStringConvertible
//                self.textHUD(printableError.description)
//            }
//        }
    }
    
    func selectImage(){
        let alertVC = UIAlertController(title: "获取图片", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "相册", style: .default, handler: { (_) in
            let imgVC = YMImageListVC()
            imgVC.maxCount = 1
            imgVC.delegate = self
            self.navigationController?.pushViewController(imgVC, animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                if authStatus == .denied || authStatus == .restricted {
                    self.textHUD("打开访问开关 [设置] - [隐私] - [相机] - [go艺]")
                    return
                }
                let pick:UIImagePickerController = UIImagePickerController()
                pick.delegate = self
                pick.sourceType = UIImagePickerControllerSourceType.camera
                self.present(pick, animated: true, completion: nil)
            } else {
                self.textHUD("摄像头不能使用")
            }        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //获取相机拍摄照片/视频
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        headImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        uploadHeadImage()
    }
    
    //获取相册选择结果
    func imageResult(result: [UIImage]) {
        if result.count > 0 {
            headImage = result[0]
            uploadHeadImage()
        }
    }
    
    func imgClick(){
        selectImage()
    }
    
    func uploadHeadImage(){
        if headImage != nil {
            let data = UIImageJPEGRepresentation(headImage!, 1)
            
            loadHUD()
            MoyaProvider<User>().request(.updateImage(params: ["messageId": model!.id!], data: data!)) { resp in
                do {
                    let response = try? resp.dematerialize()
                    let value = try response?.mapJSON() as? [String: Any?]
                    if value?["status"] as? Int == 0 {
                        self.textHUD("上传成功")
                        self.headView.loadImage(placeholder: self.headImage)
                    } else if let msg = value?["msg"] as? String {
                        self.textHUD(msg)
                    } else {
                        self.textHUD("上传失败, 请稍后重试")
                    }
                } catch {
                    let printableError = error as CustomStringConvertible
                    self.textHUD(printableError.description)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
