//
//  LoginVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/17.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class LoginVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var accountFiled: UITextField!
    @IBOutlet weak var passLbl: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var viewConstraintH: NSLayoutConstraint!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var registBtn: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    
    private lazy var leftView: UILabel = {
        let leftLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        leftLbl.textColor = UIColor.gray
        leftLbl.font = UIFont.systemFont(ofSize: 15)
        leftLbl.textAlignment = .right
        leftLbl.text = "+86"
        
        return leftLbl
    }()
    var loginBlock:(()->())?
    
    @IBOutlet weak var sinaBtn: UIButton!
    @IBOutlet weak var centerX: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "登录"
        accountFiled.leftViewMode = .always
        accountFiled.leftView = leftView
        
        navigationBarTintColor()
        _ = addLeftItem(title: "关闭", color: skinColor)
        
        accountFiled.text = AppConst.mobile
        accountLbl.font = UIFont.systemFont(ofSize: 15)
        accountFiled.font = UIFont.systemFont(ofSize: 15)
        passLbl.font = UIFont.systemFont(ofSize: 15)
        passField.font = UIFont.systemFont(ofSize: 15)
        forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        registBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        descLabel.font = UIFont.systemFont(ofSize: 14)
        sinaBtn.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewConstraintH.constant = NaviViewH
        centerX.constant = 35
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func leftClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        if accountFiled.text == nil || !accountFiled.text!.authPhone() {
            textHUD("请输入正确的账号")
            return
        }
        
        if passField.text == nil || !passField.text!.authPass() {
            textHUD("请输入6-20位字母数字组成的密码")
            return
        }
        
        loadHUD()
        let params = ["mobile": accountFiled.text!, "password": passField.text!]
        MoyaProvider<User>().request(.userLogin(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapJSON() as? [String: Any]
                let result = value?["result"] as? [String: Any]
                if result?["status"] as? Int == 0 {
                    self.textHUD("登录成功")
                    if let actor = value?["crew"] as? [String: Any] {
                        AppConst.writeVale(key: "id", value: actor["id"])
                        AppConst.writeVale(key: "mobile", value: actor["mobile"])
                        AppConst.writeVale(key: "nickName", value: actor["nickName"])
                        AppConst.writeVale(key: "realName", value: actor["realName"])
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
                    AppConst.writeVale(key: "pass", value: self.passField.text!)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case accountFiled:
            accountFiled.layer.borderColor = skinColor.cgColor
            accountLbl.textColor = skinColor
            passField.layer.borderColor = UIColor.lightGray.cgColor
            passLbl.textColor = UIColor.black
        case passField:
            passField.layer.borderColor = skinColor.cgColor
            passLbl.textColor = skinColor
            accountFiled.layer.borderColor = UIColor.lightGray.cgColor
            accountLbl.textColor = UIColor.black
        default:
            break
        }
    }
    
    @IBAction func forgetClick(_ sender: UIButton) {
        let forgetVC = ForgetVC(nibName: "ForgetVC", bundle: nil)
        forgetVC.sourceType = 1
        navigationController?.pushViewController(forgetVC, animated: true)
    }
    
    @IBAction func rigestClick(_ sender: UIButton) {
        let forgetVC = ForgetVC(nibName: "ForgetVC", bundle: nil)
        forgetVC.sourceType = 0
        navigationController?.pushViewController(forgetVC, animated: true)
    }

    @IBAction func qqClick(_ sender: UIButton) {
        UmengEngine.instance.getUserInfo(platformType: .QQ) { (resp) in
            self.loginApi(user: resp, type: 2)
        }
    }
    
    @IBAction func wxClick(_ sender: UIButton) {
        UmengEngine.instance.getUserInfo(platformType: .wechatSession) { (resp) in
            print(resp.uid, resp.iconurl, resp.name)
            self.loginApi(user: resp, type: 1)
        }
    }
    
    @IBAction func sinaClick(_ sender: UIButton) {
        UmengEngine.instance.getUserInfo(platformType: .sina) { (resp) in
            self.loginApi(user: resp, type: 3)
        }
    }
    
    func loginApi(user:UMSocialUserInfoResponse!, type: Int){
        loadHUD()
        var params = ["uid": user.uid] as [String:Any]
        params["uid"] = user.uid
        params["name"] = user.name
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
                    if let actor = value?["DLogin"] as? [String: Any] {
                        AppConst.writeVale(key: "uid", value: user.uid)
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
                    if AppConst.userid == nil {
                        self.login(user: user, type: type)
                        return
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
    
    func login(user:UMSocialUserInfoResponse!, type: Int){
        if type == 1 {
            let quickVC = QuickLoginVC(nibName: "QuickLoginVC", bundle: nil)
            quickVC.user = user
            quickVC.type = 1
            self.navigationController?.pushViewController(quickVC, animated: true)
        } else if type == 2 {
            let quickVC = QuickLoginVC(nibName: "QuickLoginVC", bundle: nil)
            quickVC.user = user
            quickVC.type = 2
            self.navigationController?.pushViewController(quickVC, animated: true)
        } else if type == 3 {
            let quickVC = QuickLoginVC(nibName: "QuickLoginVC", bundle: nil)
            quickVC.user = user
            quickVC.type = 3
            self.navigationController?.pushViewController(quickVC, animated: true)
        }
    }

}
