//
//  AddCrewVC.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/7/30.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Photos
import AVKit
import AVFoundation
import Moya
class AddCrewVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, YMImageListVCDelegate {
    private var crewimage:UIImage?
    private var headImageView:UIImageView{
        let iView = UIImageView.init(frame: CGRect(x:0,y:-64,width:AppWidth,height:314))
        iView.image = UIImage.init(named: "Z")
        return iView
    }

    private var crewBtn:UIImageView{
        let imgView = UIImageView(frame: CGRect(x:0,y:250,width:AppWidth,height:150))
        imgView.image = UIImage.init(named: "添加剧图")
        imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tap1))
        imgView.addGestureRecognizer(tap)
        return imgView
    }
    private var textView:UITextView{
        let textView = UITextView(frame: CGRect(x:0,y:400,width:AppWidth,height:200))
        textView.placeholderText = "输入你要发布的剧组信息"
        return textView
    }
    private var naviView:(view:UIView,label:UILabel){
        let view = UIView(frame: CGRect(x:0,y:0,width:AppWidth,height:44))
        let label = UILabel(frame: CGRect(x:0,y:0,width:AppWidth-34,height:44))
        label.text = "有1个剧组正在审核发布中\n请耐心等待"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        view.addSubview(label)
        return (view,label)
    }
    private var uploadBtn:UIButton{
        let btn = UIButton(frame: CGRect(x:AppWidth/2-125,y:600,width:100,height:40))
        btn.setTitle("提交", for: .normal)
        btn.setTitleColor(skinColor, for: .normal)
        btn.addTarget(self, action: #selector(uploadCrew), for: .touchUpInside)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "naviback"), for: .default)
        _ = addRightItem(title: "00",color: UIColor.clear)
        self.navigationItem.titleView = naviView.view
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(headImageView)

        self.view.addSubview(crewBtn)
        self.view.addSubview(textView)
        self.view.addSubview(uploadBtn)
        self.view.addSubview(cancelBtn)
        // Do any additional setup after loading the view.
    }
    func tap1(){
        selectImage(count: 1)
    }
    func uploadCrew(){
        pushInfo()
    }
    func cancel(){
        
    }
    func selectImage(count: Int){
        let alertVC = UIAlertController(title: "获取图片", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "相册", style: .default, handler: { (_) in
//            let imgVC : UIImagePickerController = UIImagePickerController()
//            imgVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
            let imgVC = YMImageListVC()
            imgVC.maxCount = count
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
        let iView = UIImageView.init(frame: CGRect(x:0,y:250,width:AppWidth,height:150))
        iView.image = result[0]
        self.crewimage = result[0]
        self.view.addSubview(iView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //发布组讯
    func pushInfo() {
        let params = ["crewId": AppConst.userid ?? 1,"content":textView.text] as [String : Any]
        var data = Data()
        if crewimage != nil{
            data = UIImageJPEGRepresentation(crewimage!, 0.5)!
        }
        loadHUD()
        MoyaProvider<User>().request(.pushInfo(params: params,image:data)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value) {
                    if status.status == 0 {
                        self.textHUD("发布成功")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
