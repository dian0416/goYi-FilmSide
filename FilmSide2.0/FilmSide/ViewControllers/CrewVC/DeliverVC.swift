//
//  DeliverVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/22.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Moya

class DeliverVC: UIViewController, UITextViewDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, YMImageListVCDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet var imgBtns: [UIButton]!
    private lazy var imageArray: [UIImage] = {
        return [UIImage]()
    }()
    //0-发表，1-建议 2-转发评论
    var sourceType:Int = 0
    var content:String?
    var total:Int = 9

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        placeLbl.isHidden = false
        navigationBarTintColor()
        if sourceType == 0 {
            _ = addLeftItem(title: "取消", color: skinColor)
            _ = addRightItem(title: "发表", color: skinColor)
            navigationItem.title = "发表新鲜事"
            for i in 0..<imgBtns.count {
                let btn = imgBtns[i]
                btn.imageView?.contentMode = .scaleAspectFill
                let closeBtn = UIButton(frame: CGRect(x: btn.frame.width-30, y: 0, width: 30, height: 30))
                closeBtn.backgroundColor = UIColor.white
                closeBtn.addTarget(self, action: #selector(closeClick(sender:)), for: .touchUpInside)
                closeBtn.setImage(UIImage(named: "close"), for: .normal)
                closeBtn.tag = 100 + i
                btn.addSubview(closeBtn)
            }
            self.changeImage()
        } else if sourceType == 1 {
            _ = addLeftItem(title: "取消", color: skinColor)
            _ = addRightItem(title: "提交", color: skinColor)
            total = 1
            placeLbl.text = "输入意见反馈'"
            navigationItem.title = "反馈与建议"
            for i in 0..<imgBtns.count {
                let btn = imgBtns[i]
                btn.imageView?.contentMode = .scaleAspectFill
                let closeBtn = UIButton(frame: CGRect(x: btn.frame.width-30, y: 0, width: 30, height: 30))
                closeBtn.backgroundColor = UIColor.white
                closeBtn.addTarget(self, action: #selector(closeClick(sender:)), for: .touchUpInside)
                closeBtn.setImage(UIImage(named: "close"), for: .normal)
                closeBtn.tag = 100 + i
                btn.addSubview(closeBtn)
            }
            self.changeImage()
        } else {
            _ = addLeftItem(title: "取消", color: skinColor)
            _ = addRightItem(title: "转发", color: skinColor)
            textView.text = content
            if textView.text.length() > 0 {
                placeLbl.isHidden = true
            } else {
                placeLbl.text = "转发消息不能为空"
                placeLbl.isHidden = false
            }
            navigationItem.title = "转发消息"
        }
        
        textView.font = UIFont.systemFont(ofSize: 15)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for i in 0..<imgBtns.count {
            let btn = imgBtns[i]
            let closeBtn = btn.viewWithTag(100+i)
            closeBtn?.frame = CGRect(x: btn.frame.width-30, y: 0, width: 30, height: 30)
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        selectImage(count: 9-imageArray.count)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.length() > 0 {
            placeLbl.isHidden = true
        } else {
            placeLbl.isHidden = false
        }
    }
    
    override func leftClick() {
        dismiss(animated: true, completion: nil)
    }
    
    override func rightClick() {
        if textView.text.length() <= 0 {
            textHUD("请输入反馈内容")
            return
        }
        suggestInfo()
    }
    
    func selectImage(count: Int){
        self.hideKeyboard()
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
    
    //获取相机拍摄照片/视频
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageArray.append(image)
            
            DispatchQueue.main.async {
                self.changeImage()
            }
        }
    }
    
    //获取相册选择结果
    func imageResult(result: [UIImage]) {
        imageArray.append(contentsOf: result)
        DispatchQueue.main.async {
            self.changeImage()
        }
    }
    
    func changeImage(){
        for btn in imgBtns {
            btn.layer.backgroundColor = lineColor.cgColor
            btn.isHidden = true
        }
        for i in 0..<imageArray.count {
            imgBtns[i].isHidden = false
            imgBtns[i].setImage(nil, for: .normal)
            imgBtns[i].setBackgroundImage(imageArray[i], for: .normal)
            imgBtns[i].viewWithTag(100+i)?.isHidden = false
        }
        if imageArray.count < total {
            imgBtns[imageArray.count].setImage(UIImage(named: "addimage"), for: .normal)
            imgBtns[imageArray.count].setBackgroundImage(nil, for: .normal)
            imgBtns[imageArray.count].isHidden = false
            imgBtns[imageArray.count].viewWithTag(100+imageArray.count)?.isHidden = true
        }
    }
    
    func closeClick(sender: UIButton){
        let tag = sender.tag - 100
        imageArray.remove(at: tag)
        DispatchQueue.main.async {
            self.changeImage()
        }
    }
    
    func suggestInfo(){
        loadHUD()
        let params = ["userid": AppConst.userid!, "content": textView.text, "userType":2] as [String : Any]
        var datas = [Data]()
        for image in imageArray {
            let data = UIImageJPEGRepresentation(image, 1)
            datas.append(data!)
        }
        MoyaProvider<User>().request(.sugsetInfo(params: params, images: datas)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value) {
                    if status.status == 0 {
                        self.textHUD("提交成功")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: {
                            self.dismiss(animated: true, completion: nil)
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
    
}
