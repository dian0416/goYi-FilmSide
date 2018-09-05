//
//  QuickLoginVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/19.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class QuickLoginVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var nickField: UITextField!
    @IBOutlet weak var viewConstraintH: NSLayoutConstraint!
    @IBOutlet weak var nickLbl: UILabel!
    @IBOutlet weak var inviteLbl: UILabel!
    @IBOutlet weak var inviteField: UITextField!
    var user:UMSocialUserInfoResponse!
    var type:Int = 0
//    var loginBlock:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "快速登录"
        avatarBtn.loadImage(placeholder: UIImage(named: "default"))
        navigationBarTintColor()
        nickLbl.font = UIFont.systemFont(ofSize: 15)
        nickField.font = UIFont.systemFont(ofSize: 15)
        inviteLbl.font = UIFont.systemFont(ofSize: 15)
        inviteField.placeholder = "请填写邀请码"
        inviteField.font = UIFont.systemFont(ofSize: 15)
        
        avatarBtn.loadImage(user.iconurl)
        nickField.text = user.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewConstraintH.constant = NaviViewH
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nickField:
            nickField.layer.borderColor = skinColor.cgColor
            nickLbl.textColor = skinColor
            inviteField.layer.borderColor = UIColor.lightGray.cgColor
            inviteLbl.textColor = UIColor.black
        case inviteField:
            inviteField.layer.borderColor = skinColor.cgColor
            inviteLbl.textColor = skinColor
            nickField.layer.borderColor = UIColor.lightGray.cgColor
            nickLbl.textColor = UIColor.black
        default:
            break
        }
    }

    @IBAction func avatarClick(_ sender: UIButton) {
        
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        if nickField.text == nil || nickField.text!.isEmpty {
            textHUD("请输入昵称")
            return
        }
        if inviteField.text == nil || inviteField!.text!.isEmpty {
            textHUD("请填写邀请码")
            return
        }
        
        loginApi()
    }
    
    func loginApi(){
        loadHUD()
        var params = ["uid": user.uid] as [String:Any]
        if nickField.text!.tirmSpace().length() == 0 {
            self.textHUD("请输入昵称")
            return
        }
        params["code"] = inviteField.text!
        params["uid"] = user.uid
        params["name"] = nickField.text!
        params["gender"] = user.gender
        params["conurl"] = user.iconurl
        params["type"] = type
        params["userType"] = 2
        MoyaProvider<User>().request(.thirdLogin(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapJSON() as? [String: Any]
                let result = value?["result"] as? [String: Any]
                if result?["status"] as? Int == 0 {
                    self.hideHUD()
                    var loginID:Int?
                    if let actor = value?["DLogin"] as? [String: Any] {
//                        AppConst.writeVale(key: "id", value: actor["id"])
                        loginID = actor["id"] as? Int
                        AppConst.writeVale(key: "uid", value: self.user.uid)
                        AppConst.writeVale(key: "realName", value: actor["name"])
                        AppConst.writeVale(key: "nickName", value: actor["name"])
                        AppConst.writeVale(key: "headImg", value: actor["conurl"])
                    }
                    if let actor = value?["actor"] as? [String: Any] {
                        AppConst.writeVale(key: "id", value: actor["id"])
                        AppConst.writeVale(key: "mobile", value: actor["mobile"])
                        AppConst.writeVale(key: "realName", value: actor["realName"])
                        AppConst.writeVale(key: "nickName", value: actor["nickName"])
                        AppConst.writeVale(key: "integralName", value: actor["integralName"])
                        AppConst.writeVale(key: "headImg", value: actor["headImg"])
                        AppConst.writeVale(key: "examine", value: actor["examine"])
                        AppConst.writeVale(key: "level", value: actor["integralId"])
                        AppConst.writeVale(key: "levelname", value: actor["integralName"])
                        AppConst.writeVale(key: "levelscore", value: actor["integra"])
                        if let sex = actor["sex"] as? Int {
                            AppConst.writeVale(key: "sex", value: sex == 0 ? "女":"男")
                        }
                    }
                    if loginID != nil && AppConst.userid == nil {
                        let bindVC = ForgetVC(nibName: "ForgetVC", bundle: nil)
                        bindVC.sourceType = 2
                        bindVC.loginID = loginID
                        self.navigationController?.pushViewController(bindVC, animated: true)
                        return
                    } else {
                        if let msg = result?["msg"] as? String {
                            self.textHUD(msg)
                        } else {
                            self.textHUD("登录失败，请重试")
                        }
                    }
                    AppConst.writeVale(key: "login", value: "true")
                    userDef.synchronize()
                    self.dismiss(animated: true, completion: nil)
                } else if let msg = result?["msg"] as? String {
                    self.textHUD(msg)
                } else {
                    self.textHUD("登录失败, 请稍后重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    
    func bindApi(){
        loadHUD()
        var params = [String:Any]()
        params["uid"] = user.uid
        params["name"] = nickField.text!
        params["gender"] = user.gender
        params["conurl"] = user.iconurl
        params["type"] = type
        params["userType"] = 2
        params["id"] = AppConst.userid
        MoyaProvider<User>().request(.bindApi(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapJSON() as? [String: Any]
                let result = value?["result"] as? [String: Any]
                if result?["status"] as? Int == 0 {
                    self.hideHUD()
                } else if let msg = result?["msg"] as? String {
                    self.textHUD(msg)
                } else {
//                    self.textHUD("登录失败, 请稍后重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
}
