//
//  HeadCell.swift
//  FilmSide
//
//  Created by 张嘉懿 on 2018/6/4.
//  Copyright © 2018年 🐨🐨🐨. All rights reserved.
//

import UIKit
import LLCycleScrollView
class HeadCell: UITableViewCell {
    var starModels:[UserBaseInfoModel?]?{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                if self.starModels != nil{
                    var imageArr = [String]()
                    var titles = [String]()
                    let winnertitles = ["周冠军","月冠军"]
                    for model in self.starModels!{
                        imageArr.append(model?.headImg ?? "")
                        titles.append(model?.realName ?? "")
                    }
                    self.bannerDemo.imagePaths = imageArr
                    self.bannerDemo.titles = titles
                    self.bannerDemo.winnerTitles = winnertitles
                }
            }
            
            
        }
    }
    var weekModel:UserBaseInfoModel?{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                self.bannerDemo.imagePaths.append(self.weekModel?.headImg ?? "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg")
            }
        }
    }
    var monthModel:UserBaseInfoModel?{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                self.bannerDemo.imagePaths.append(self.monthModel?.headImg ?? "")
            }
        }
    }
    @IBOutlet var bannerDemo: LLCycleScrollView!
//    var bannerDemo:LLCycleScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerDemo = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y:0, width: AppWidth, height: 200))
        // 是否自动滚动
        bannerDemo.autoScroll = true
        
        // 是否无限循环，此属性修改了就不存在轮播的意义了 😄
        bannerDemo.infiniteLoop = true
        
        // 滚动间隔时间(默认为2秒)
        bannerDemo.autoScrollTimeInterval = 3.0
        
//         等待数据状态显示的占位图
        bannerDemo.placeHolderImage = UIImage.init(named: "default")
        
        // 如果没有数据的时候，使用的封面图
        bannerDemo.coverImage = UIImage.init(named: "default")
        
        // 设置图片显示方式=UIImageView的ContentMode
        bannerDemo.imageViewContentMode = .scaleToFill
        
        // 设置滚动方向（ vertical || horizontal ）
        bannerDemo.scrollDirection = .horizontal
        
        // 设置当前PageControl的样式 (.none, .system, .fill, .pill, .snake)
        bannerDemo.customPageControlStyle = .snake
        
        // 非.system的状态下，设置PageControl的tintColor
        bannerDemo.customPageControlInActiveTintColor = UIColor.red
        
        // 设置.system系统的UIPageControl当前显示的颜色
        bannerDemo.pageControlCurrentPageColor = UIColor.white
        
        // 非.system的状态下，设置PageControl的间距(默认为8.0)
        bannerDemo.customPageControlIndicatorPadding = 8.0
        
        // 设置PageControl的位置 (.left, .right 默认为.center)
        bannerDemo.pageControlPosition = .center
        
        // 背景色
        bannerDemo.collectionViewBackgroundColor = UIColor.clear
        
        // 添加到view
        self.addSubview(bannerDemo)
        
        // 模拟网络图片获取
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
//            bannerDemo.imagePaths = imagesURLStrings
//        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
