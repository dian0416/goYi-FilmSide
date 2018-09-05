//
//  Extension+URL.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/5.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

extension URL {
    func urlObject() -> (image:UIImage, time:CGFloat) {
        //获取本地视频
        let avAsset = AVAsset(url: self)
        let seconds = ceil(Double(avAsset.duration.value/Int64(avAsset.duration.timescale)))
        
        //生成视频截图
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0,600)
        var actualTime:CMTime = CMTimeMake(0,0)
        let imageRef:CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
        let frameImg = UIImage(cgImage: imageRef)
        
        //显示截图
        return (frameImg, CGFloat(seconds))
    }
}
