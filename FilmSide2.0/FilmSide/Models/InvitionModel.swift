//
//  InvitionModel.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/27.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import HandyJSON

class InvitionModel: HandyJSON {
    var id:Int? //贴子ID
    var actorId:Int?
    var nickName:String? //昵称
    var headImg:String? //头像地址
    var integralName:String? //头衔
    var praise:Int = 0 //点赞数
    var forward:Int = 0 //转发数
    var commentCount:Int = 0 //评论数
    var addTime:Int? //新增时间
    var content:String? //内容
    var praiseType:Int = 0
    var imgList:[InvitionImageModel]? //图片列表
    
    required init() {
        
    }
    
}

struct InvitionImageModel:HandyJSON {
    var id:Int? //主键ID
    var squareId:Int?
    var imgUrl:String?
}

class AgreeModel: HandyJSON {
    var id:Int? //主键ID
    var actorId:Int? //艺人ID
    var squareId:Int? //帖子ID
    var state:Int? // 1 点赞 2被点赞 3转发
    var addTime:Int? //点赞时间
    var headImg:String? //
    var nickName:String? //昵称
    var integralName:String?
    
    required init() {
        
    }
}

class CommentModel:HandyJSON {
    var id:Int? //主健ID
    var actorId:Int? //艺人ID
    var realName:String? //评论者姓名
    var content:String? // 内容
    var addTime:Int? // 发帖时间
    var beenCommentId:Int? //被评论者ID
    var beenCommentName:String? //被评论者姓名
    var headImg:String? //头像地址
    var integralName:String?
    var beenCommentList:[CommentModel]?
    
    required init() {
        
    }
}
