//
//  YMBanerView.swift
//  WineDealer
//
//  Created by 米翊米 on 2016/12/19.
//  Copyright © 2016年 🐨🐨🐨. All rights reserved.
//

import UIKit

protocol YMBanerViewDelegate:NSObjectProtocol {
    //点击事件
    func didSelect(banner: YMBanerView, index: Int)
}

protocol YMBanerViewDataSource:NSObjectProtocol {
    //数据个数
    func bannerOfnumber() -> Int
    func bannerForView(cell: UIView?, atIndex: Int) -> UIView?
}

class YMBanerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate{
    //初始化视图
    private lazy var ectionView:UICollectionView = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.scrollDirection = .horizontal
        
        let collectView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectView.isPagingEnabled = true
        collectView.showsHorizontalScrollIndicator = false
        collectView.bounces = false
        collectView.backgroundColor = UIColor.white
        collectView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self.identifier)
        collectView.dataSource = self
        collectView.delegate = self
        
        return collectView
    }()
    private lazy var pageControl:UIPageControl = {[weak self] in
        let page = UIPageControl(frame: CGRect(x: 0, y: self!.frame.size.height-20, width: self!.frame.size.width, height: 20))
        page.currentPageIndicatorTintColor = skinColor
        page.pageIndicatorTintColor = UIColor.lightGray
        
        return page
    }()
    //自动滑动计时器
    private var autoTimer:Timer?
    private var isAuto = false
    weak var dataSource:YMBanerViewDataSource?
    weak var delegate:YMBanerViewDelegate?
    
    //获取视图个数
    private var itemsCount:Int {
        get{
            if dataSource != nil {
                return dataSource!.bannerOfnumber()
            }
            return 0
        }
    }
    //获取当前显示的视图
    private var currentItem = 0
    private let identifier = "cell"
    
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(ectionView)
        self.addSubview(pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if itemsCount > 1 {
            pageControl.numberOfPages = itemsCount
            pageControl.currentPage = 0
            ectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .left, animated: true)
        }
    }
    
    //重新载入数据
    func bannerReload(){
        pageControl.numberOfPages = itemsCount
        pageControl.currentPage = 0
        ectionView.reloadData()
        //当视图大于1个时，可以无限滑动,初始位置为1对应数据源0
        if itemsCount > 1 {
            ectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .left, animated: true)
        }
    }
    
    //section个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //当视图小于2个时不能无限滑动，大于1个时在首尾各加一个视图
        if itemsCount > 1 {
            return itemsCount + 2
        }
        return itemsCount
    }
    
    //每个section的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    //加载视图
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        var section = indexPath.section
        
        if itemsCount > 1 && section == 0 {
            //第一视图位置显示数据源最后一个数据
            section = itemsCount - 1
        }else if itemsCount > 1 && section == itemsCount+1 {
            //最后一个视图显示数据源第一个数据
            section = 0
        }else if itemsCount > 1 {
            //视图大于1时，当前位置-1
            section -= 1
        }
        
        if self.dataSource != nil {
            //创建复用视图
            cell.backgroundView = self.dataSource!.bannerForView(cell: cell.backgroundView, atIndex: section)
        }
        
        return cell
    }
    
    //点击视图
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var section = indexPath.section
        //第一视图和最后视图为重复利用视图，所以点击视图时当前位置-1
        if itemsCount > 1 && section > 0 {
            section -= 1
        }
        //最后视图位置是数据源个数-1
        if itemsCount > 1 && section == itemsCount {
            section = itemsCount - 1
        }
        
        self.delegate?.didSelect(banner: self, index: section)
    }
    
    //开始滑动关闭自动滚动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopScroll()
    }
    
    //手动滑动后重置位置，以便无限滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //获取当前位置
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {[weak self] in
            self?.changeItem()
        }
    }
    
    func changeItem(){
        currentItem = ectionView.indexPath(for: ectionView.visibleCells.first!)!.section
        //往下翻页，当前页为最后一页，回到第一页
        if currentItem == itemsCount+1 {
            ectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .left, animated: false)
            currentItem = 1
        }
        //往上翻页，当前页为第一页，回到最后一页
        if currentItem == 0 {
            ectionView.scrollToItem(at: IndexPath(item: 0, section: itemsCount), at: .left, animated: false)
            currentItem = itemsCount
        }
        
        if isAuto && autoTimer == nil {
            startScroll(time: 5.0)
        }
        pageControl.currentPage = currentItem - 1
    }
    
    //自动滚动开启
    func startScroll(time: CGFloat){
        if autoTimer == nil && time > 0 && itemsCount > 1 {
            autoTimer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(autoScrollView), userInfo: nil, repeats: true)
            isAuto = true
        }
    }
    
    //关闭自动滚动
    func stopScroll(){
        autoTimer?.invalidate()
        autoTimer = nil
    }
    
    //自动滚动
    func autoScrollView(){
        if currentItem >= itemsCount+1 {
            return
        }
        //无限往下翻页
        ectionView.scrollToItem(at: IndexPath(item: 0, section: currentItem+1), at: .left, animated: true)
        self.scrollViewDidEndDecelerating(self.ectionView)
    }
    
}
