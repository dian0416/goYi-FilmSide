//
//  IndividualVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/11.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class IndividualVC: UIViewController, ControlDelegate {
    private lazy var infoTabelView:ShowInfoTableView = {
        return ShowInfoTableView(frame: CGRect(x: 0, y: 0, width:AppWidth, height:AppHeight), style: .plain)
    }()
    private lazy var infoImageView: ShowInfoImageView = {
        let imageView = ShowInfoImageView(frame: CGRect(x: 0, y: 0, width:AppWidth, height:AppHeight), style: .plain)
        
        return imageView
    }()
    private lazy var infoVideoView: ShowInfoVideoView = {
        let videoView = ShowInfoVideoView(frame: CGRect(x: 0, y: 0, width:AppWidth, height:AppHeight), style: .plain)
        return videoView
    }()
    private lazy var infoWorkView: ShowInfoWorksView = {
        let workView = ShowInfoWorksView(frame: CGRect(x: 0, y: 0, width:AppWidth, height:AppHeight), style: .plain)
        
        return workView
    }()
    private var headImage:UIImage?
    private var selectIndex = 0
    private lazy var imageArray:[(url:String?, image:UIImage?)] = {
        var images = [(url:String?, image:UIImage?)]()
        
        return images
    }()
    private lazy var videoArray:[(url:String?, imageUrl:String?, image:UIImage?)] = {
        var videos = [(url:String?, imageUrl:String?, image:UIImage?)]()
        
        return videos
    }()
    private lazy var filmTypes: [String] = {
        return ["院线电影", "网络大电影", "电视剧", "网络剧", "商业活动", "综艺"]
    }()
    private lazy var films: [String:[UserWorkModel]] = { [unowned self] in
        var film = [String:[UserWorkModel]]()
        for type in self.filmTypes {
            film[type] = [UserWorkModel]()
        }
        
        return film
    }()
    private var infoModel:UserBaseInfoModel?
    private var editInfo:(type:String, index:Int)?
    private var imageUrls:[[String: Any]]?
    private var videoUrls:[[String: Any]]?
    var actorid:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Uncomment the following line to preserve selection between presentations
        infoTabelView.actorid = actorid
        addWorkView()
        addVideoView()
        addImageView()
        addInfoView()
        
        infoRequest()
        imageRequest()
        videoRequest()
        worksRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.navigationController?.isNavigationBarHidden = true
        navigationBarTrans()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        self.navigationController?.isNavigationBarHidden = false
        navigationBarTintColor()
    }
    
    func addInfoView(){
        infoTabelView.publicDelegate = self
        self.view.addSubview(infoTabelView)
        infoTabelView.reloadData()
    }
    
    func addImageView(){
        infoImageView.publicDelegate = self
        self.view.addSubview(infoImageView)
        infoImageView.reloadData()
    }
    
    func addVideoView(){
        infoVideoView.publicDelegate = self
        self.view.addSubview(infoVideoView)
        infoVideoView.reloadData()
    }
    
    func addWorkView(){
        infoWorkView.publicDelegate = self
        self.view.addSubview(infoWorkView)
        infoWorkView.reloadData()
    }
    
    func dataHandler(type: Any?, data: Any?) {
        if type as? String == "select" {
            selectIndex = data as! Int
            if selectIndex == 0 {
                infoTabelView.infoModel = self.infoModel
                infoTabelView.selectIndex = selectIndex
                self.view.bringSubview(toFront: infoTabelView)
                infoTabelView.reloadData()
            } else if selectIndex == 1 {
                infoImageView.infoModel = self.infoModel
                infoImageView.selectIndex = selectIndex
                infoImageView.imageAarry = imageArray
                self.view.bringSubview(toFront: infoImageView)
            } else if selectIndex == 2 {
                infoVideoView.infoModel = self.infoModel
                infoVideoView.selectIndex = selectIndex
                infoVideoView.videoArray = videoArray
                self.view.bringSubview(toFront: infoVideoView)
            } else {
                infoWorkView.infoModel = self.infoModel
                infoWorkView.selectIndex = selectIndex
                self.view.bringSubview(toFront: infoWorkView)
            }
        } else if type as? String == "video_play" {
            let index = data as! Int
            let playVC = VideoPlayVC()
            if let url = videoArray[index].url {
                playVC.videoUrl = URL(string: "\(AppConst.FormalServer)/\(url)")
                self.present(playVC, animated: true, completion: nil)
            }
        } else if type as? String == "fav" {
            favRequest()
        }
    }
    
    func favRequest(){
        if AppConst.userid == nil {
            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil).addNavigation()
            self.present(loginVC, animated: true, completion: nil)
            return
        }
        loadHUD()
        var params = [String: Any]()
        params["crewId"] = AppConst.userid!
        params["actorId"] = actorid
        params["type"] = 1
        MoyaProvider<User>().request(.favActor(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                let status = StatusModel.deserialize(from: value)
                if status?.status == 0 {
                    self.textHUD("收藏成功")
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
    
    func infoRequest() {
        if actorid != nil {
            UserBaseInfoModel.network(params: ["actorId": actorid!], completion: { (resp, error) in
                if error == nil {
                    if let status = StatusModel.deserialize(from: resp, designatedPath: "result") {
                        if status.status == 0 {
                            self.infoModel = UserBaseInfoModel.deserialize(from: resp, designatedPath:"actorMessageVO")
                            self.infoTabelView.infoModel = self.infoModel
                            self.hideHUD()
                        } else {
                            if let msg = status.msg {
                                self.textHUD(msg)
                            } else {
                                self.textHUD("网络错误请重试")
                            }
                        }
                    } else {
                        self.textHUD("网络错误, 请稍后重试")
                    }
                } else {
                    self.textHUD("网络错误请重试")
                }
            })
        }
    }
    
    func imageRequest(){
        if actorid == nil {
            return
        }
        let params = ["actorId":actorid!]
        loadHUD()
        MoyaProvider<User>().request(.getImages(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                self.imageUrls = try response?.mapJSON() as? [[String: Any]]
                if self.imageUrls != nil {
                    self.imageArray = [(url:String?, image:UIImage?)]()
                    for object in self.imageUrls! {
                        self.imageArray.append((object["photoUrl"] as? String, nil))
                    }
                }
                self.infoImageView.imageAarry = self.imageArray
                if self.imageArray.count > 0 {
                    self.infoTabelView.backImage = self.imageArray[0].url
                    self.infoVideoView.backImage = self.imageArray[0].url
                    self.infoWorkView.backImage = self.imageArray[0].url
                }
                self.hideHUD()
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    
    func videoRequest(){
        if actorid == nil {
            return
        }
        let params = ["actorId":actorid!]
        loadHUD()
        MoyaProvider<User>().request(.getVideos(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                self.videoUrls = try response?.mapJSON() as? [[String: Any]]
                if self.videoUrls != nil {
                    self.videoArray = [(url:String?, imageUrl:String?, image:UIImage?)]()
                    for object in self.videoUrls! {
                        self.videoArray.append((object["videoUrl"] as? String, object["videoImg"] as? String, nil))
                    }
                }
                self.infoVideoView.videoArray = self.videoArray
                self.hideHUD()
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    
    func worksRequest(){
        if actorid == nil {
            return
        }
        let params = ["actorId":actorid!]
        MoyaProvider<User>().request(.getWorks(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value, designatedPath: "result") {
                    if status.status == 0 {
                        if let works = [UserWorkModel].deserialize(from: value, designatedPath: "actorMovieList") {
                            for work in works {
                                if  let id = work?.movieTypeId {
                                    self.films[self.filmTypes[id-1]]?.append(work!)
                                }
                            }
                        }
                        self.infoWorkView.films = self.films
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
