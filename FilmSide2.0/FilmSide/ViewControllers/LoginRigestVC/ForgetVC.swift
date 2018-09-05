//
//  ForgetVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/19.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class ForgetVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var passLbl: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var viewConstraintH: NSLayoutConstraint!
    @IBOutlet weak var inviteLbl: UILabel!
    @IBOutlet weak var inviteField: UITextField!
//    var loginBlock:(()->())?
    @IBOutlet weak var noticeView: UITextView!
    //0-标示注册 1-标示忘记密码 2-绑定手机号
    var sourceType = 0
    var loginID:Int?
    private var timer:Timer?
    private var timeSec = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarTintColor()
        
        codeBtn.layer.borderWidth = 0.5
        codeBtn.layer.borderColor = UIColor.lightGray.cgColor
        if sourceType == 0 {
            navigationItem.title = "注册"
            let tmp = "<<用户协议>>"
            let attrText = NSMutableAttributedString(string: "点击\"确认\"即表示您同意\(tmp)")
            attrText.addAttributes([NSLinkAttributeName: service], range: NSRange(location: attrText.length-tmp.length(), length: tmp.length()))
            attrText.addAttributes([NSForegroundColorAttributeName: titleColor], range: NSRange(location:0, length: attrText.length-tmp.length()))
            noticeView.delegate = self
            noticeView.attributedText = attrText
            noticeView.textAlignment = .center
        } else if sourceType == 1 {
            noticeView.isHidden = true
            inviteLbl.isHidden = true
            inviteField.isHidden = true
            navigationItem.title = "找回密码"
        } else {
            inviteLbl.isHidden = true
            inviteField.isHidden = true
            noticeView.isHidden = true
            navigationItem.title = "绑定手机号"
            passField.isHidden = true
            passLbl.isHidden = true
        }
        inviteField.delegate = self
        phoneLbl.font = UIFont.systemFont(ofSize: 15)
        phoneField.font = UIFont.systemFont(ofSize: 15)
        codeLbl.font = UIFont.systemFont(ofSize: 15)
        codeField.font = UIFont.systemFont(ofSize: 15)
        passLbl.font = UIFont.systemFont(ofSize: 15)
        passField.font = UIFont.systemFont(ofSize: 15)
        noticeView.font = UIFont.systemFont(ofSize: 13)
        inviteLbl.font = UIFont.systemFont(ofSize: 15)
        inviteField.font = UIFont.systemFont(ofSize: 15)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewConstraintH.constant = NaviViewH
    }
    
    @IBAction func codeClick(_ sender: UIButton) {
        if phoneField.text == nil || !phoneField.text!.authPhone() {
            textHUD("请输入正确的手机号码")
            return
        }
        
        loadHUD()
        var apiType:User!
        if sourceType == 0 {
            apiType = .userCode(params: ["mobile": phoneField.text!])
        } else if sourceType == 1 {
            apiType = .forgetCode(params: ["mobile": phoneField.text!])
        } else {
            apiType = .thirdCode(params: ["mobile": phoneField.text!, "userType": 1])
        }
        MoyaProvider<User>().request(apiType) { result in
            do {
                let response = try? result.dematerialize()
                let value = try response?.mapJSON() as? [String: Any?]
                if value?["status"] as? Int == 0 {
                    self.textHUD("验证码已经发送")
                } else if let msg = value?["msg"] as? String {
                    self.textHUD(msg)
                } else {
                    self.textHUD("验证码发送失败, 请稍后重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
        
        codeBtn.isUserInteractionEnabled = false
        if timer == nil {
            timeSec = 60
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(flashTime), userInfo: nil, repeats: true)
        }
        timer?.fire()
    }
    
    //刷新时间
    func flashTime() {
        timeSec -= 1
        
        if timeSec == 0 {
            timer?.invalidate()
            codeBtn.setTitleColor(UIColor.gray, for: .normal)
            codeBtn.setTitle("获取", for: .normal)
            codeBtn.backgroundColor = UIColor.white
            codeBtn.isUserInteractionEnabled = true
            return
        }
        codeBtn.setTitleColor(UIColor.gray, for: .normal)
        codeBtn.setTitle("\(timeSec)s", for: .normal)
        codeBtn.backgroundColor = UIColor.lightGray
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case phoneField:
            phoneField.layer.borderColor = skinColor.cgColor
            phoneLbl.textColor = skinColor
            passField.layer.borderColor = UIColor.lightGray.cgColor
            passLbl.textColor = UIColor.black
            codeField.layer.borderColor = UIColor.lightGray.cgColor
            codeLbl.textColor = UIColor.black
            inviteField.layer.borderColor = UIColor.lightGray.cgColor
            inviteLbl.textColor = UIColor.black
        case codeField:
            codeField.layer.borderColor = skinColor.cgColor
            codeLbl.textColor = skinColor
            phoneField.layer.borderColor = UIColor.lightGray.cgColor
            phoneLbl.textColor = UIColor.black
            passField.layer.borderColor = UIColor.lightGray.cgColor
            passLbl.textColor = UIColor.black
            inviteField.layer.borderColor = UIColor.lightGray.cgColor
            inviteLbl.textColor = UIColor.black
        case passField:
            passField.layer.borderColor = skinColor.cgColor
            passLbl.textColor = skinColor
            phoneField.layer.borderColor = UIColor.lightGray.cgColor
            phoneLbl.textColor = UIColor.black
            codeField.layer.borderColor = UIColor.lightGray.cgColor
            codeLbl.textColor = UIColor.black
            inviteField.layer.borderColor = UIColor.lightGray.cgColor
            inviteLbl.textColor = UIColor.black
        case inviteField:
            inviteField.layer.borderColor = skinColor.cgColor
            inviteLbl.textColor = skinColor
            phoneField.layer.borderColor = UIColor.lightGray.cgColor
            phoneLbl.textColor = UIColor.black
            codeField.layer.borderColor = UIColor.lightGray.cgColor
            passField.layer.borderColor = UIColor.lightGray.cgColor
            passLbl.textColor = UIColor.lightGray
            codeLbl.textColor = UIColor.black
            phoneField.layer.borderColor = UIColor.lightGray.cgColor
            phoneLbl.textColor = UIColor.black
        default:
            break
        }
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        if phoneField.text == nil || !phoneField.text!.authPhone() {
            textHUD("请输入正确的手机号码")
            return
        }
        
        if codeField.text == nil || !codeField.text!.authCode() {
            textHUD("验证码为4位字符")
            return
        }
        
        if (passField.text == nil || !passField.text!.authPass()) && sourceType != 2 {
            textHUD("请输入6-20为字符密码")
            return
        }
        if (inviteField.text == nil || inviteField.text!.length() == 0) && sourceType == 0 {
            textHUD("请输入邀请码")
            return
        }
        
        loadHUD()
        var params = ["mobile": phoneField.text!, "code": codeField.text!] as [String:Any]
        var apiType:User!
        if sourceType == 0 {
            params["password"] = passField.text!
            params["code2"] = inviteField.text!
            apiType = .userRegist(params: params)
        } else if sourceType == 1 {
            params["newUserPass"] = passField.text!
            apiType = .forgetPass(params: params)
        } else {
            params["loginId"] = loginID
            params["userType"] = 2
            apiType = .thirdBind(params: params)
        }
        MoyaProvider<User>().request(apiType) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapJSON() as? [String: Any]
                let result = value?["result"] as? [String: Any]
                if result?["status"] as? Int == 0 || value?["status"] as? Int == 0 {
                    if let msg = value?["msg"] as? String {
                        self.textHUD(msg)
                    }
                    if let actor = value?["actor"] as? [String: Any] {
                        AppConst.writeVale(key: "id", value: actor["id"])
                        AppConst.writeVale(key: "mobile", value: actor["mobile"])
                        AppConst.writeVale(key: "nickName", value: actor["nickName"])
                        AppConst.writeVale(key: "realName", value: actor["realName"])
                        AppConst.writeVale(key: "integralName", value: actor["integralName"])
                        if let sex = actor["sex"] as? Int {
                            AppConst.writeVale(key: "sex", value: sex == 0 ? "女":"男")
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
                    AppConst.writeVale(key: "login", value: "true")
                    userDef.synchronize()
                    
                    
                    self.hideHUD()
                } else if let msg = result?["msg"] as? String {
                    self.textHUD(msg)
                } else if let msg = value?["msg"] as? String {
                    self.textHUD(msg)
                } else {
                    self.hideHUD()
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }

    @IBAction func rigestClick(_ sender: UIButton) {
        let forgetVC = ForgetVC(nibName: "ForgetVC", bundle: nil)
        forgetVC.sourceType = 0
        navigationController?.pushViewController(forgetVC, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let webVC = WebVC()
        webVC.title = "用户协议"
        webVC.urlString = "http://www.baidu.com"
        navigationController?.pushViewController(webVC, animated: true)
        
        return true
    }
    
}
