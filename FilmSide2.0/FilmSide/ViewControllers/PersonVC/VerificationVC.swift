//
//  VerificationVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/17.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import AVFoundation
import Moya

class VerificationVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ControlDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YMImageListVCDelegate {
    private lazy var childTableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NaviViewH-50), style:.plain)
        tableView.tableViewDefault()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        
        return tableView
    }()
    private lazy var bottom: UIButton = { [unowned self] in
        let button = UIButton(frame: CGRect(x: 0, y: NaviViewH-50, width: AppWidth, height: 50))
        button.backgroundColor = skinColor
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        return button
    }()
    private var selectIndex = 0
    private var positive:UIImage?
    private var negative:UIImage?
    private var id:Int?
    private var name:String?
    private var card:String?
    private let identifiercard = "card"
    private let identifierver = "ver"
    //0 未审核 1 审核通过 2 审核不通过
    private var model:CardModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        navigationBarTintColor()
        navigationItem.title = "身份验证"
        self.view.addSubview(childTableView)
        self.view.addSubview(bottom)
        childTableView.register(UINib(nibName: "VeridentityCell", bundle: nil), forCellReuseIdentifier: identifierver)
        childTableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: identifiercard)
        getRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierver) as? VeridentityCell
            cell?.publicDelegate = self
            cell?.separatorZero()
            cell?.nameField.text = model?.realName
            cell?.cardField.text = model?.cardNo
            if name != nil {
                cell?.nameField.text = name
            }
            if card != nil {
                cell?.cardField.text = card
            }
            
            return cell!
        } else if section == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell?.separatorHidden()
                
                cell?.textLabel?.textColor = titleColor
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell?.textLabel?.numberOfLines = 0
                cell?.textLabel?.textAlignment = .center
                cell?.textLabel?.text = "申请人手持身份证\n确保五官和身份证照片一致"
            }
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifiercard) as? CardCell
            cell?.publicDelegate = self
            cell?.section = section
            if section == 2 {
                cell?.titleLabel.text = "手持身份证正面"
                cell?.separatorHidden()
                if positive != nil {
                    cell?.imgView.setImage(nil, for: .normal)
                    cell?.imgView.setBackgroundImage(positive, for: .normal)
                } else if model?.cardImg1 != nil {
                    cell?.imgView.setImage(nil, for: .normal)
                    cell?.imgView.loadBackImage(model?.cardImg1)
                }
            } else {
                cell?.titleLabel.text = "手持身份证反面"
                cell?.separatorZero()
                if negative != nil {
                    cell?.imgView.setImage(nil, for: .normal)
                    cell?.imgView.setBackgroundImage(negative, for: .normal)
                } else if model?.cardImg2 != nil {
                    cell?.imgView.setImage(nil, for: .normal)
                    cell?.imgView.loadBackImage(model?.cardImg2)
                }
            }
            
            return cell!
        }
    }

    func btnClick(){
        submit()
    }
    
    func dataHandler(type: Any?, data: Any?) {
//        if model?.state == 0 {
//            textHUD("审核中")
//        }
        let tmp = type as? String
        if tmp == "up" {
            selectIndex = 0
            selectImage(count: 1)
        } else if tmp == "down" {
            selectIndex = 1
            selectImage(count: 1)
        } else if tmp == "name" {
            self.name = data as? String
        } else if tmp == "card" {
            self.card = data as? String
        }
    }
    
    func selectImage(count: Int){
        let alertVC = UIAlertController(title: "获取图片", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "相册", style: .default, handler: { (_) in
            let imgVC = YMImageListVC()
            imgVC.maxCount = count
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
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    
    //获取相机拍摄照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if selectIndex == 0 {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                positive = image
            }
        } else if selectIndex == 1 {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
               negative = image
            }
        }
        childTableView.reloadData()
    }
    
    //获取相册选择结果
    func imageResult(result: [UIImage]) {
        if result.count > 0 && selectIndex == 0 {
            positive = result[0]
        } else if selectIndex == 1 {
            negative = result[0]
        }
        childTableView.reloadData()
    }
    
    func submit(){
        var params = ["crewId": AppConst.userid!] as [String:Any]
        if name == nil {
            textHUD("姓名不能为空")
            return
        }
        params["realName"] = name
        if id != nil {
             params["id"] = id
        }
        if card == nil {
            textHUD("身份证号不能为空")
            return
        }
        params["cardNo"] = card
        if positive == nil && model?.cardImg1 == nil {
            textHUD("身份证正面不能为空")
            return
        }
        if negative == nil && model?.cardImg2 == nil {
            textHUD("身份证反面不能为空")
            return
        }
        var data1:Data?
        if positive != nil {
            data1 = UIImageJPEGRepresentation(positive!, 1)
        }
        
        var data2:Data?
        if negative != nil {
            data2 = UIImageJPEGRepresentation(negative!, 1)
        }
        
        loadHUD()
        MoyaProvider<User>().request(.verName(image1: data1, image2: data2, params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value) {
                    if status.status == 0 {
                        self.textHUD("提交成功")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: { 
                            self.navigationController?.popViewController(animated: true)
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
            }
        }
    }
    
    func getRequest(){
        loadHUD()
        
        MoyaProvider<User>().request(.actorCard()) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        self.model = CardModel.deserialize(from: value, designatedPath: "crewCard")
                        self.hideHUD()
                        self.id = self.model?.id
                        self.name = self.model?.realName
                        self.card = self.model?.cardNo
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
