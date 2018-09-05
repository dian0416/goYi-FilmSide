//
//  UserImageModel.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/22.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import HandyJSON

class UserWorkModel:NSObject, HandyJSON {
    var id:Int?
    var actorId:Int?
    var movieTypeId:Int? //影片类型1院线电影2网络大电影3电视剧4网络剧5商业活动6综艺
    var movieName:String?
    var roleName:String?
    var directorName:String?
    var cooperationActor:String?
    
    required override init() { }
}
