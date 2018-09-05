//
//  UITableViewControllerExtension.swift
//  N+Store
//
//  Created by 米翊米 on 16/8/26.
//  Copyright © 2016年 天宫. All rights reserved.
//

import UIKit

var key = "key"
extension UITableViewController {

    //设置UITableViewController默认属性
    func tableViewControllerDefault(_ edge:UIRectEdge = UIRectEdge()) {
        self.edgesForExtendedLayout = edge
        if edge == .all {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        viewControllerDefault(edge: edge)
        tableView.tableViewDefault()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

}

extension UITableView {
    struct constView {
        static var emptyView = UIView()
        static var emptyLabel = UILabel()
    }
    //UITableView默认设置
    func tableViewDefault(){
        //去除多余分割线
        self.tableFooterView = UIView()
        //设置分割线颜色
        self.separatorColor = lineColor
        //设置背景色
        self.backgroundColor = lineColor
        //设置滚动条不显示
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        //设置cell高度自动计算
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 44
    }
    
    func showEmptyView() {
        constView.emptyView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.frame.size)
        constView.emptyLabel.text = "没有数据"
        constView.emptyLabel.textAlignment = .center
        constView.emptyLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        constView.emptyLabel.center = constView.emptyView.center
        constView.emptyLabel.font = UIFont.systemFont(ofSize: 15)
        constView.emptyLabel.textColor = skinColor
        constView.emptyView.addSubview(constView.emptyLabel)
        self.insertSubview(constView.emptyView, at: 0)
    }
    
    func hiddenEmptyView(){
        constView.emptyView.removeFromSuperview()
    }
    
}
