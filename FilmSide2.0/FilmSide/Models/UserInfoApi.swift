//
//  UserInfoApi.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/20.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

public enum User {
    case userCode(params: [String:Any])
    case forgetCode(params: [String:Any])
    case userRegist(params: [String:Any])
    case userLogin(params: [String:Any])
    case forgetPass(params: [String:Any])
    case updatePass(params: [String:Any])
    case userInfo(params: [String:Any])
    case infoUpdate(params: [String:Any])
    case actorGet()
    case actorList(params: [String:Any])
    case filmsGet()
    case lineGet(params: [String:Any])
    case roleGet(params: [String:Any])
    case roleList(params: [String:Any])
    case crewRoleList(params: [String:Any])
    case swarmList(params: [String:Any])
    case lineList()
    case favActor(params: [String:Any])
    case favList()
    case disFav(params: [String:Any])
    case praiseList(params :[String:Any])
    case actorCard()
    case submitInfo(params :[String:Any])
    case filmList(params :[String:Any])
    case updateRole(params :[String:Any])
    case updateSwarm(params :[String:Any])
    case addRole(params :[String:Any])
    case addSwarm(params :[String:Any])
    case pushInfo(params: [String:Any],image:Data)
    case getCity(params: [String:Any])
    case verName(image1: Data?, image2: Data?, params:[String:Any])
    case sugsetInfo(params: [String: Any], images:[Data]?)
    case smsRequest(params: [String:Any])
    case thirdLogin(params: [String: Any])
    case thirdCode(params: [String: Any])
    case bindApi(params: [String: Any])
    case inviteCode(params: [String:Any])
    case thirdBind(params: [String: Any])
    
    case uploadHead(image: Data)
    case uploadImage(image: Data)
    case getImages(params: [String:Any])
    case deleteImage(params: [String:Any])
    case getVideos(params: [String:Any])
    case addVideo(video: Data)
    case deleteVideo(params: [String:Any])
    case addLabel(params: [String:Any])
    case addSpec(params: [String:Any])
    case getWorks(params: [String:Any])
    case addWorks(params: [String: Any])
    case deleteWorks(params: [String:Any])
    case updateWorks(params: [String:Any])
    case getIntegral(params: [String:Any])
    case sign(params: [String:Any])
    case getIntegralDetail()
    case getInfo()
    case readInfo(params: [String:Any])
    case removeInfo()
    case deleteInfo(params: [String:Any])
    case historyInfo()
    case crewList([String:Any])
    case filmType()
    case roleInfo(params: [String: Any])
    case getLastInfo()
    case getList(params: [String:Any])
    case getDeatilNews(params: [String:Any])
    case commentInfo(params: [String:Any])
    case praiseSquare(params: [String:Any])
    case queryBeenComment(params: [String:Any])
    case updateImage(params: [String: Any], data:Data)
}

extension User: TargetType {
    public var baseURL: URL {
        return URL(string: AppConst.FormalServer)!
    }
    
    public var path: String {
        switch self {
        case .userCode(_):
            return "admin/actorValidate/crewVerification.json"
        case .forgetCode(_):
            return "admin/actorValidate/doUpdateCrew.json"
        case .userRegist(_):
            return "admin/crew/register.json"
        case .userLogin(_):
            return "admin/crew/login.json"
        case .forgetPass(_):
            return "admin/crew/doRetrieve.json"
        case .updatePass(_):
            return "admin/actor/doUpdateRetrieve.json"
        case .userInfo(_):
            return "admin/actor/toActorInfo.json"
        case .infoUpdate(_):
            return "admin/crew/crewPerfect.json"
        case .actorGet():
            return "admin/square/pastStar.json"
        case .actorList(_):
            return "admin/crewCollection/queryCrewCollection.json"
        case .filmsGet():
            return "admin/crewMessage/queryCrewMessageNameList.json"
        case .lineGet(_):
            return "/admin/dLine/queryLineByMessageId.json"
        case .roleGet(_):
            return "admin/crewRole/queryRoleNameList.json"
        case .roleList(_):
            return "admin/crewMessage/queryMatchingActor.json"
        case .swarmList(_):
            return "admin/crewMatching/queryMatchingPerson.json"
        case .lineList():
            return "admin/dLine/queryLineList.json"
        case .favActor(_):
            return "admin/crewCollection/addCrewCollection.json"
        case .favList():
            return "admin/crewCollection/queryCrewCollection.json"
        case .disFav(_):
            return "admin/crewCollection/delCrewCollection.json"
        case .praiseList(_):
            return "admin/square/queryPraise.json"
        case .actorCard():
            return "admin/crewCard/queryCrewCard.json"
        case .submitInfo(_):
            return "admin/crewContent/addMessage.json"
        case .filmList(_):
            return "admin/crewMessage/queryCrewMessage.json"
        case .updateRole(_):
            return "admin/crewRole/modifyRole.json"
        case .updateSwarm(_):
            return "admin/crewRole/updateGroup.json"
        case .addRole(_):
            return "admin/crewRole/addRole.json"
        case .addSwarm(_):
            return "admin/crewRole/groupPlay.json"
        case .pushInfo(_,_):
            return "admin/crewContent/addMessage.json"
        case .getCity(_):
            return "admin/dArea/getCount.json"
        case .verName(_,_,_):
            return "admin/crewCard/doIdentificationFace.json"
        case .sugsetInfo(_,_):
            return "admin/dFeedback/submitFeedBack.json"
        case .smsRequest(_):
            return "admin/dSms/noticeActor.json"
        case .thirdLogin(_):
            return "admin/dLogin/doLogin.json"
        case .thirdCode(_):
            return "admin/dLogin/getMobile.json"
        case .bindApi(_):
            return "admin/dLogin/getBind.json"
        case .inviteCode(_):
            return "admin/dCode/getCode.json"
        case .thirdBind(_):
            return "admin/dLogin/getValidate.json"
        case .updateImage(_, _):
            return "admin/crewMessage/resetPicture.json"
        case .uploadHead(_):
            return "admin/actor/doHeadImg.json"
        case .getImages(_):
            return "admin/actorPhoto/doQueryPhotos.json"
        case .uploadImage(_):
            return "admin/actorPhoto/doUploadPhotos.json"
        case .deleteImage(_):
            return "admin/actorPhoto/doDelPhotos.json"
        case .getVideos(_):
            return "admin/actorVideo/doQueryVideo.json"
        case .addVideo(video: _):
            return "admin/actorVideo/doAddVideo.json"
        case .deleteVideo(_):
            return "admin/actorVideo/doDelVideo.json"
        case .addLabel(_):
            return "admin/actorLabel/doLabel.json"
        case .addSpec(_):
            return "admin/actorSpecialty/doSpecialty.json"
        case .getWorks(_):
            return "admin/actorMovie/queryActorMovieList.json"
        case .addWorks(_):
            return "admin/actorMovie/doAddWorks.json"
        case .deleteWorks(_):
            return "admin/actorMovie/doDelWorks.json"
        case .updateWorks(_):
            return "admin/actorMovie/doUpdateWorks.json"
        case .getIntegral(_):
            return "admin/dIntegraHonor/getIntegraHonor.json"
        case .sign(_):
            return "admin/actorSign/addSign.json"
        case .getIntegralDetail():
            return "admin/actorIntegral/queryActorIntegraList.json"
        case .getInfo():
            return "admin/message/toMessage.json"
        case .readInfo(_):
            return "admin/message/editMessage.json"
        case .removeInfo():
            return "admin/message/delMessage.json"
        case .deleteInfo(_):
            return "admin/message/delOneMessage.json"
        case .historyInfo():
            return "admin/actorStar/queryActorStarList.json"
        case .crewList(_):
            return "admin/crewMessage/queryCrewMessageList.json"
        case .filmType():
            return "admin/dMovieType/queryMovieTypeList.json"
        case .roleInfo(_):
            return "admin/crewRole/queryCrewRoleList.json"
        case .getLastInfo():
            return "admin/square/queryNewest.json"
        case .getList(_):
            return "admin/square/querySquare.json"
        case .getDeatilNews(_):
            return "admin/square/getSquare.json"
        case .commentInfo(_):
            return "admin/square/commentSquare.json"
        case .praiseSquare(_):
            return "admin/square/praiseSquare.json"
        case .queryBeenComment(_):
            return "admin/square/queryBeenComment.json"
        case .crewRoleList(_):
            return "admin/crewMessage/queryMatchingList.json"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .userCode(let params):
            return params
        case .forgetCode(let params):
            return params
        case .userRegist(let params):
            return params
        case .userLogin(let params):
            return params
        case .userInfo(let params):
            return params
        case .infoUpdate(let params):
            return  params
        case .actorGet():
            if AppConst.userid != nil {
                return ["crewId": AppConst.userid!]
            }
            return nil
        case .filmsGet():
            return ["crewId": AppConst.userid!]
        case .actorList(let params):
            return params
        case .lineGet(let params):
            return params
        case .roleGet(let params):
            return params
        case .roleList(let params):
            return params
        case .swarmList(let params):
            return params
        case .favActor(let params):
            return params
        case .favList():
            return ["crewId": AppConst.userid!]
        case .disFav(let params):
            return params
        case .praiseList(let parmas):
            return parmas
        case .actorCard():
            return ["crewId": AppConst.userid!]
        case .submitInfo(let params):
            return params
        case .filmList(let params):
            return params
        case .updateRole(let params):
            return params
        case .updateSwarm(let params):
            return params
        case .addRole(let params):
            return params
        case .addSwarm(let params):
            return params
        case .pushInfo(let params,_):
            return params
        case .getCity(let params):
            return params
        case .verName(_, _, let params):
            return params
        case .sugsetInfo (let params, _):
            return params
        case .smsRequest(let params):
            return params
        case .thirdLogin(let params):
            return params
        case .thirdCode(let params):
            return params
        case .bindApi(let params):
            return params
        case .inviteCode(let params):
            return params
        case .thirdBind(let params):
            return params
        case .updateImage(let params, _):
            return params
            
        
        case .uploadHead(_):
            return ["id": AppConst.userid!]
        case .uploadImage(_):
            return ["actorId": AppConst.userid!]
        case .getImages(let params):
            return params
        case .deleteImage(let params):
            return params
        case .getVideos(let params):
            return params
        case .addVideo(_):
            let marter = DateFormatter()
            marter.dateFormat = "YYYY-MM-dd"
            
            let dateStr = marter.string(from: Date())
            return ["actorId": AppConst.userid!, "shootTime": dateStr]
        case .deleteVideo(let params):
            return params
        case .addLabel(let params):
            return params
        case .addSpec(let params):
            return params
        case .getWorks(let params):
            return params
        case .addWorks(let params):
            return params
        case .deleteWorks(let params):
            return params
        case .updateWorks(let params):
            return params
        case .forgetPass(let params):
            return params
        case .updatePass(let params):
            return params
        case .getIntegral(let params):
            return params
        case .sign(let params):
            return params
        case .getIntegralDetail():
            return ["actorId": AppConst.userid!]
        case .getInfo():
            return nil
        case .readInfo(let params):
            return params
        case .removeInfo():
            return ["actorId": AppConst.userid!]
        case .deleteInfo(let params):
            return params
        case .historyInfo():
            return ["actorId": AppConst.userid!]
        case .crewList(let params):
            return params
        case .filmType():
            return nil
        case .roleInfo(let params):
            return params
        case .getLastInfo():
            return nil
        case .getList(let params):
            return params
        case .getDeatilNews(let params):
            return params
        case .commentInfo(let params):
            return params
        case .praiseSquare(let params):
            return params
        case .queryBeenComment(let params):
            return params
        case .crewRoleList(let params):
            return params
        default:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    
    public var task: Task {
        switch self {
        case .pushInfo(_, let data):
            return .upload(.multipart([MultipartFormData(provider: .data(data), name: "file1", fileName: "image.png", mimeType: "image/png")]))
        case .uploadImage(let data):
            return .upload(.multipart([MultipartFormData(provider: .data(data), name: "file", fileName: "image.png", mimeType: "image/png")]))
        case .updateImage(_, let data):
            return .upload(.multipart([MultipartFormData(provider: .data(data), name: "file", fileName: "head.png", mimeType: "image/png")]))
        case .addVideo(let data):
            return .upload(.multipart([MultipartFormData(
                provider: .data(data), name: "file", fileName: "video.mp4", mimeType: "video/mp4")]))
        case .verName(let image1, let image2, _):
            var data1:MultipartFormData?
            if image1 != nil {
                data1 = MultipartFormData(
                    provider: .data(image1!), name: "file1", fileName: "正面.png", mimeType: "image/png")
            }
            var data2:MultipartFormData?
            if image2 != nil {
                data2 = MultipartFormData(
                    provider: .data(image2!), name: "file2", fileName: "反面.png", mimeType: "image/png")
            }
            if data1 != nil && data2 != nil {
                return .upload(.multipart([data1!, data2!]))
            } else if data1 != nil {
                return .upload(.multipart([data1!]))
            } else if data2 != nil {
                return .upload(.multipart([data2!]))
            }

            return .upload(UploadType.multipart([MultipartFormData(provider: .data(Data()), name: "dd")]))
        case .sugsetInfo(_, let images):
            if images?.count > 0 {
                let data = MultipartFormData(
                    provider: .data(images![0]), name: "file", fileName: "建议", mimeType: "image/png")
                return .upload(.multipart([data]))
            }
            
            return .upload(UploadType.multipart([MultipartFormData(provider: .data(Data()), name: "dd")]))
        case .thirdLogin(_):
            return .upload(UploadType.multipart([MultipartFormData(provider: .data(Data()), name: "dd")]))
        default:
            return .request
        }
    }
    
    public var validate: Bool {
        return false
    }
    
    //这个就是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    public var sampleData: Data {
        return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
    }
    
}

