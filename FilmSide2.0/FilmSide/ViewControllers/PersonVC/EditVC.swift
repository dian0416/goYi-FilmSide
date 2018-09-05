//
//  EditVC.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/8/9.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya
import Photos
class EditVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, YMImageListVCDelegate {
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var headImageView: UIImageView!

    @IBOutlet var nameText: UITextField!
    @IBOutlet var sexText: UITextField!
    @IBOutlet var phoneText: UITextField!
    
    //0-女 1-男
    private var sex = -1
    private var headImage:UIImage?
    private var backGroundImage:UIImage?
    //0-头像 1-背景
    private var uploadType = 0
    private var uploadBtn:UIButton{
        let btn = UIButton(frame: CGRect(x:AppWidth/2-125,y:600,width:100,height:40))
        btn.setTitle("提交", for: .normal)
        btn.setTitleColor(skinColor, for: .normal)
        btn.addTarget(self, action: #selector(infoUpdate), for: .touchUpInside)
        btn.layer.cornerRadius = 18
        btn.layer.borderWidth = 2
        btn.layer.borderColor = skinColor.cgColor
        return btn
    }
    private var cancelBtn:UIButton{
        let btn = UIButton(frame: CGRect(x:AppWidth/2+25,y:600,width:100,height:40))
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(skinColor, for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        btn.layer.cornerRadius = 18
        btn.layer.borderWidth = 2
        btn.layer.borderColor = skinColor.cgColor
        return btn
    }
    func cancel(){
        
    }
    @IBAction func uploadBackGroundImage(_ sender: Any) {
        uploadType = 1
        selectImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        headImageView.loadImage(AppConst.headImage)
        nameText.text = AppConst.realName
        sexText.text = AppConst.sex
        phoneText.text = AppConst.mobile
        headImageView.layer.cornerRadius = headImageView.bounds.width/2
        headImageView.clipsToBounds = true
        
        headImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectImage))
        headImageView.addGestureRecognizer(tap)
        view.addSubview(uploadBtn)
        view.addSubview(cancelBtn)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func selectImage(){
        let alertVC = UIAlertController(title: "获取图片", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "相册", style: .default, handler: { (_) in
            //            let imgVC : UIImagePickerController = UIImagePickerController()
            //            imgVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
            let imgVC = YMImageListVC()
            imgVC.maxCount = 1
            imgVC.delegate = self
            self.navigationController?.pushViewController(imgVC, animated: true)
            //            self.present(imgVC, animated: true, completion: nil)
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
    func imageResult(result: [UIImage]) {
        if uploadType == 0 {
            headImage = result[0]
            uploadHeadImage()
        }else{
            backGroundImage = result[0]
            uploadBackGroundImage()
        }

    }
    func infoUpdate(){
        loadHUD()
        
        if sexText.text == "男" {
            sex = 1
        } else if sexText.text == "女" {
            sex = 0
        }
        
        let params = ["id": AppConst.userid!, "sex": sex, "realName": nameText.text ?? ""] as [String : Any]
        MoyaProvider<User>().request(.infoUpdate(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value, designatedPath: "result")
                if status?.status == 0 {
                    AppConst.writeVale(key: "mobile", value: self.phoneText.text)
                    AppConst.writeVale(key: "sex", value: self.sexText.text)
                    AppConst.writeVale(key: "realName", value: self.nameText.text)
//                    self.tableView.reloadData()
                    self.textHUD("保存成功")
                } else if let msg = status?.msg {
                    self.textHUD(msg)
                } else {
                    self.textHUD("网络错误, 请稍后重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    
    func uploadHeadImage(){
        if headImage != nil {
            let data = UIImageJPEGRepresentation(headImage!, 1)
            
            loadHUD()
            MoyaProvider<User>().request(.updateImage(params: ["id": AppConst.userid ?? 0], data: data!)) { resp in
                do {
                    let response = try? resp.dematerialize()
                    let value = try response?.mapJSON() as? [String: Any?]
                    if value?["status"] as? Int == 0 {
                        self.textHUD("上传成功")
//                        AppConst.writeVale(key: "headImage", value: self.headImage)
                        self.headImageView.image = self.headImage
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
    func uploadBackGroundImage(){
        if backGroundImage != nil {
            let data = UIImageJPEGRepresentation(backGroundImage!, 1)
            uploadType = 0
            loadHUD()
            MoyaProvider<User>().request(.uploadImage(image: data!)) { resp in
                do {
                    let response = try? resp.dematerialize()
                    let value = try response?.mapJSON() as? [String: Any?]
                    if value?["status"] as? Int == 0 {
                        self.textHUD("上传成功")
                        self.backImageView.image = self.backGroundImage
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
