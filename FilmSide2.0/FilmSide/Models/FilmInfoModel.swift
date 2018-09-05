//
//  FilmInfoModel.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/26.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import HandyJSON

struct FilmInfoModel: HandyJSON {
    var id:Int? //主键ID
    var crewId:Int? //片方ID
    var filmName:String? //剧名
    var movieId:Int? //1院线电影 2网络大电影 3电视剧 4网络剧 5商业活动 6综艺
    var theme:String? //题材
    var startTime:String? //开机时间
    var beginTime:String? //招募开始时间
    var endTime:String? //招募结束时间
    var shotPlace:String? //拍摄地点
    var shotCycle:String? //拍摄周期
    var company:String? //出品公司
    var toStar:String? //主演
    var publisher:String? //出品人
    var fileProducer:String? //制片人
    var executivePorducer:String? //执行制片人
    var original:String? //原著
    var screenwriter:String? //编剧
    var director:String? //导演
    var deputyDirector:String? //副导演
    var performerOveral:String? //演员统筹
    var email:String? //邮箱
    var storyIntroduction:String? //剧情介绍
    var messageImg:String? //组讯海报
    var state:Int? //0 未发布 1 已发布 2已过期
    var urgent:Int? //是否加急排序字段
    var addTime:Int? //添加时间
    var readCount:Int = 0 //阅读量
    var cache:Bool?
    var praseList:[PriseModel]?
}
struct PriseModel:HandyJSON {
    var actorId:Int?
    var headImg:String?
    var nickName:String?
    var integralName:String?
}
struct RoleModel:HandyJSON {
    var id:Int? //主键ID
    var messageId:Int? //组讯ID
    var lineId:Int? //线位1角色 2特约 3前特 4群演
    var roleName:String? //角色名
    var ageLow:Int? //年龄
    var ageHigh:Int? //年龄
    var sex:Int? //性别 0 女 1男
    var labelName1:String? //角色标签
    var labelName2:String? //角色标签
    var heightLow:Int? //身高 （单位厘米CM）最低
    var weightLow:Int? //体重（单位KG）最低
    var biography:String? //人物小传
    var state:Int? //0 未匹配 1 已匹配
    var addTime:Int? //number 添加时间
    var heightHigh:Int? //身高 （单位厘米CM）最高
    var weightHigh:Int?
    var personCount:Int?
    var city:String?
    var byTime:Int?
}

struct PersonModel: HandyJSON {
    var id:Int?
    var roleName:String?
}

