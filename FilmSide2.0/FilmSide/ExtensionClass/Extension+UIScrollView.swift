//
//  Extension+UIScrollView.swift
//  WineDealer
//
//  Created by 米翊米 on 2016/7/16.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

enum LoadState {
    case nomarl
    case loading
}

extension UIScrollView {
    
    class ConstVar {
        lazy var refreshView:(freshView:UIView, active:UIActivityIndicatorView) = {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            let activeView = UIActivityIndicatorView()
            activeView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            activeView.color = UIColor.gray
            activeView.tag = 100
            activeView.center = view.center
            view.addSubview(activeView)
            
            return (view, activeView)
        }()
        lazy var loadMoreView:(freshView:UIView, active:UIActivityIndicatorView) = {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            let activeView = UIActivityIndicatorView()
            activeView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            activeView.color = UIColor.gray
            activeView.tag = 100
            view.addSubview(activeView)
            
            return (view, activeView)
        }()
        var headFreshState:LoadState = .nomarl
        var moreFreshState:LoadState = .nomarl
        var headFunc:(tagert:Any, action:Selector)?
        var moreFunc:(tagert:Any, action:Selector)?
        static var insKey = "instance"
    }
    
    private var constVar:ConstVar {
        get{
            if objc_getAssociatedObject(self, &ConstVar.insKey) == nil {
                objc_setAssociatedObject(self, &ConstVar.insKey, ConstVar(), .OBJC_ASSOCIATION_RETAIN)
                self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            }
            return objc_getAssociatedObject(self, &ConstVar.insKey) as! ConstVar
        }
    }
    
    private var refreshView:(freshView:UIView, active:UIActivityIndicatorView) {
        get{
            return constVar.refreshView
        }
    }
    
    private var loadMoreView:(freshView:UIView, active:UIActivityIndicatorView) {
        get{
            return constVar.loadMoreView
        }
    }
    
    //添加下拉刷新
    func addHeadFreshView(target:Any, action:Selector){
        constVar.headFunc = (target, action)
        refreshView.freshView.frame = CGRect(x: 0, y: -60, width: self.frame.size.width, height: 60.0)
        refreshView.active.frame = CGRect(x: self.frame.size.width/2-15, y: 15, width: 30.0, height: 30.0)
        self.insertSubview(refreshView.freshView, at: 0)
    }
    
    //添加上拉加载更多
    func addFootFreshView(target:Any, action:Selector){
        self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        constVar.moreFunc = (target, action)
        loadMoreView.active.frame = CGRect(x: self.frame.size.width/2-15, y: 15.0, width: 30.0, height: 30.0)
        self.insertSubview(loadMoreView.freshView, at: 0)
    }
    
    //关闭下拉刷新
    func closeHeadRefresh(){
        constVar.headFreshState = .nomarl
        refreshView.active.stopAnimating()
        var insets = self.contentInset
        insets.top = 0
        UIView.animate(withDuration: 0.3) {
            self.contentInset = insets
        }
    }
    
    //关闭上拉刷新
    func closeFooterRefresh(){
        constVar.moreFreshState = .nomarl
        loadMoreView.active.stopAnimating()
        var insets = self.contentInset
        insets.bottom = 0
        UIView.animate(withDuration: 0.3) {
            self.contentInset = insets
        }
    }
    
    //位移监听
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath! == "contentOffset" {
            let point = change?[.newKey] as! CGPoint
            let sWidth = self.frame.width
            let sHeight = self.frame.height
            let cHeight = self.contentSize.height
            let offset:CGFloat = 60.0
            
            //下拉刷新
            if point.y < 0 && constVar.headFunc != nil {
                if !refreshView.active.isAnimating {
                    refreshView.active.startAnimating()
                }
                
                //下拉到-60位置后触发悬停
                if point.y <= -offset && self.isDecelerating {
                    if self.contentInset.top != offset && constVar.headFreshState == .nomarl {
                        constVar.headFreshState = .loading
                        UIView.animate(withDuration: 0.3) {
                            self.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0)
                        }
                        _ = (constVar.headFunc?.tagert as AnyObject).perform(constVar.headFunc?.action)
                    }
                }
                //正在加载中滑动页面
                if constVar.headFreshState == .loading && self.contentInset.top == 0 {
                    UIView.animate(withDuration: 0.3) {
                        self.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0)
                    }
                }
            }
            //下拉刷新，当往上滑动时恢复contentInset并停止下拉的菊花
            if point.y >= 0 && point.y < sHeight {
                if self.contentInset.top != 0 {
                    refreshView.active.stopAnimating()
                    self.contentInset = UIEdgeInsets.zero
                }
            }
            
            //上拉加载更多
            if point.y + sHeight > cHeight && cHeight > sHeight && constVar.moreFunc != nil {
                loadMoreView.freshView.frame = CGRect(x: 0, y: cHeight, width: sWidth, height: 60.0)
                if !loadMoreView.active.isAnimating {
                    loadMoreView.active.startAnimating()
                }
                
                //底部悬停
                if point.y + sHeight >= cHeight + 2*offset && self.isDecelerating {
                    if self.contentInset.bottom != offset && constVar.headFreshState == .nomarl {
                        constVar.moreFreshState = .loading
                        UIView.animate(withDuration: 0.3) {
                            self.contentInset = UIEdgeInsetsMake(0, 0, offset, 0)
                        }
                        _ = (constVar.moreFunc?.tagert as AnyObject).perform(constVar.moreFunc?.action)
                    }
                }
                //正在加载中滑动页面
                if constVar.moreFreshState == .loading && self.contentInset.bottom == 0 {
                    UIView.animate(withDuration: 0.3) {
                        self.contentInset = UIEdgeInsetsMake(0, 0, offset, 0)
                    }
                }
            }
            //上拉加载，当向下滑动时恢复contentInset并停止上拉的菊花
            if point.y + sHeight <= cHeight && point.y + sHeight > sHeight {
                if self.contentInset.bottom != 0 {
                    self.contentInset = UIEdgeInsets.zero
                    loadMoreView.active.stopAnimating()
                }
            }
        }
    }
    
}
