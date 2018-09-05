//
//  UserBaseInfoModel.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/20.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import HandyJSON
import Moya

typealias completionBlock = (_ resp: String?, _ error: Swift.Error?)->()

class UserBaseInfoModel:NSObject, HandyJSON {
    var status:Int = 0
    var actor:ActorModel?
    var actorId:Int?
    var specialiy:[LabelModel]?
    var lables:[LabelModel]?
    var line:[LabelModel]?
    var allSpecialiy:[LabelModel]?
    var allLables:[LabelModel]?
    var id:Int?
    var mobile:String?
    var realName:String?
    var nickName:String?
    var birthday:String?
    var sex:Int = 0
    var height:Int = 0
    var weight:Int = 0
    var constellation:Int = 0
    var school:String?
    var major:String?
    var language:String?
    var broker:Int = 0
    var brokerageFirm:String?
    var brokerMobile:String?
    var headImg:String?
    var schedule:Int = 0
    var remark:String?
    var integra:Int = 0
    var examine:Int = 0
    var starType:Int = 0
    var integralId:Int = 0
    var integralName:String?
    var display:Int = 0
    var actorPhoto:String?
    
    required override init() { }
    
    static func network(params: [String: Any], completion:@escaping completionBlock){
        MoyaProvider<User>().request(.userInfo(params: params)) { resp in
            var jsonString:String?
            var respError:Swift.Error?
            switch resp {
            case .success(_):
                do {
                    let response = try? resp.dematerialize()
                    jsonString = try response?.mapString()
                } catch {
                    
                }
            case let .failure(err):
                respError = err
                HUDNotice.showText("网络错误请重试", autoClearTime: 1.0)
            }
            completion(jsonString, respError)
        }
    }
    
    static func infoUpdate(params: [String: Any], completion:@escaping completionBlock){
        MoyaProvider<User>().request(.infoUpdate(params: params)) { resp in
            var jsonString:String?
            var respError:Swift.Error?
            switch resp {
            case .success(_):
                do {
                    let response = try? resp.dematerialize()
                    jsonString = try response?.mapString()
                } catch {
                    
                }
            case let .failure(err):
                respError = err
                HUDNotice.showText("网络错误请重试", autoClearTime: 1.0)
            }
            completion(jsonString, respError)
        }
    }
}

class ActorModel: HandyJSON {
    var id:Int?
    var actorId:Int?
    var mobile:String?
    var realName:String?
    var nickName:String?
    var birthday:String?
    var sex:Int = 0
    var height:Int = 0
    var weight:Int = 0
    var constellation:Int = 1
    var school:String?
    var major:String?
    var language:String?
    var broker:Int = 0
    var brokerageFirm:String?
    var brokerMobile:String?
    var headImg:String?
    var schedule:Int = 0
    var remark:String?
    var integra:Int = 0
    var examine:Int = 0
    var starType:Int = 0
    var integralId:Int = 0
    var integralName:String?
    var display:Int = 0
    var actorPhoto:String?
    var status:Int = 0
    var roleId:Int?
    var messageId:Int?
    
    required init() {
    
    }

}

class LabelModel: HandyJSON {
    var id:Int?
    var labelName:String?
    var specialtyName:String?
    var lineName:String?
    var type:Int = 0
    
    required init() { }
}

struct StatusModel: HandyJSON {
    var msg:String?
    var status:Int?
}

struct SwarmModel: HandyJSON {
    var biography:String? //群演信息
    var personCount:Int? //群演人数
    var signCount:Int? //群演已报名人数
    var byTime:Int? //时间
    var actorList:[String]? //[string] 群演头像列表
    var city:String?
}
