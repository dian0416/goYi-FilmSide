//
//  NewestModel.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/27.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import HandyJSON

struct NewestModel: HandyJSON {
    var weekStar:UserBaseInfoModel?
    var monthStar:UserBaseInfoModel?
    var newest:[NewsModel]?
}

struct NewsModel:HandyJSON {
    var imgUrl:String?
    var id:Int?
    var readCount:Int = 0
    var content:String?
}
