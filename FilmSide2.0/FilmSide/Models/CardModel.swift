//
//  CardModel.swift
//  Producer
//
//  Created by 米翊米 on 2017/5/8.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import HandyJSON

struct CardModel: HandyJSON {
    var id:Int?
    var actorId:Int? //艺人ID
    var state:Int? //审核状态 0 未审核 1 审核通过 2 审核不通过
    var realName:String? //真实姓名
    var cardNo:String? //身份证号
    var cardImg1:String? //身份证正面
    var cardImg2:String? //身份证背面
}
