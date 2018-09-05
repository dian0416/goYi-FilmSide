//
//  ViewControllerExtension.swift
//  N+Store
//
//  Created by 米翊米 on 16/8/3.
//  Copyright © 2016年 天宫. All rights reserved.
//

import UIKit

func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

//MARK: - UIViewController拓展
extension UIViewController {
    
    //添加导航栏
    func addNavigation() -> UIViewController {
        let navCtrl = UINavigationController(rootViewController: self)
        
        return navCtrl
    }
    
    //隐藏tabbar
    func hiddenTabBar() -> UIViewController {
        self.hidesBottomBarWhenPushed = true
        
        return self
    }
    
    //设置导航栏背景
    func navigationBarTintColor(color: UIColor = UIColor.white){
        self.navigationController?.navigationAlpha(alpha: 1)
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.tintColor = skinColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge()
        self.naviTextAttributes(skinColor)
        //设置返回键
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action:#selector(leftClick))
    }
    
    //设置导航栏透明
    func navigationBarTrans(){
        self.edgesForExtendedLayout = .top
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationAlpha(alpha: 0)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action:#selector(leftClick))
    }
    
    //UIViewController默认参数配置
    func viewControllerDefault(edge: UIRectEdge = UIRectEdge()) {
        self.edgesForExtendedLayout = edge
        //设置导航栏不为半透明(坐标从(0,64)开始)
        self.navigationController?.navigationBar.isTranslucent = false
        //设置导航栏标题颜色
        naviTextAttributes()
        //让坐标从(0,0)开始
//        self.extendedLayoutIncludesOpaqueBars = true
        //不让视图自动根据状态栏、导航栏、tabbar自动布局
//        self.automaticallyAdjustsScrollViewInsets = false
        //设置导航栏左右UIBarButtonItem文字颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //设置导航栏背景
        self.navigationController?.navigationBar.barTintColor = skinColor
        //设置返回键
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action:nil)
        //设置背景色
        self.view.backgroundColor = UIColor.white
        //设置状态栏颜色
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        //隐藏阴影
        navigationController?.shadowHidden(flag: true)
        
        //设置滑动返回
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        //交换UITextField方法
        if !UITextField.constVar.isExchange {
            UITextField.swizzMethod()
        }
        //设置UITextField的默认左边文字间距
        UITextField.constVar.pading = 0
    }
    
    //初始化表格视图
    func initTableView(_ edge:UIRectEdge, style: UITableViewStyle) -> UITableView {
        self.viewControllerDefault(edge: edge)
        let tableView = UITableView(frame: self.view.bounds, style: style)
        tableView.tableViewDefault()
        
        self.view.addSubview(tableView)
        return tableView
    }
    
    //设置导航栏文字颜色、大小
    func naviTextAttributes(_ color:UIColor = UIColor.white, font:UIFont = UIFont.systemFont(ofSize: 16)) {
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:font, NSForegroundColorAttributeName:color]
    }

    //自定义返回按钮
    func addLeftItem(_ image: UIImage? = nil, title: String? = nil, color:UIColor? = UIColor.white) -> UIButton {
        let leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        leftBtn.setImage(image, for: UIControlState())
        leftBtn.setTitle(title, for: UIControlState())
        leftBtn.setTitleColor(color, for: UIControlState())
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftBtn.contentHorizontalAlignment = .left
        leftBtn.addTarget(self, action: #selector(self.leftClick), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: leftBtn)
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -5
        self.navigationItem.leftBarButtonItems = [spaceItem, leftItem]
        
        return leftBtn
    }
    
    //返回事件
    func leftClick(){
        _ = hideKeyboard()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //添加右边按钮
    func addRightItem(_ image: UIImage? = nil, title: String? = nil, color:UIColor? = UIColor.white) -> UIButton {
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        rightBtn.setImage(image, for: UIControlState())
        rightBtn.setTitle(title, for: UIControlState())
        rightBtn.setTitleColor(color, for: UIControlState())
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.addTarget(self, action: #selector(self.rightClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -5
        self.navigationItem.rightBarButtonItems = [spaceItem, rightItem]
        
        return rightBtn
    }
    
    //右按钮点击事件
    func rightClick() {
        
    }
    
    //前后台切换监听
    func addBackForeActive() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.becomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.backActive), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    //进入前台
    func becomeActive() {
        
    }
    
    //进入后台
    func backActive() {
        
    }
    
    //点击空白隐藏键盘
    func touchSpaceHidden(){
        let tapZer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
            
        /**
         *  设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
         */
        tapZer.cancelsTouchesInView = false
        /**
         *  将触摸事件添加到当前view
         */
        self.view.addGestureRecognizer(tapZer)
    }
    
    //键盘显示隐藏监控
    func addKeyWordNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //键盘显示高度
    func keyboardWasShow(_ notif: Notification) -> CGFloat {
        let info = notif.userInfo
        
        let endKeyboardRect = ((info?[UIKeyboardFrameEndUserInfoKey] as! NSValue)).cgRectValue
        
        return endKeyboardRect.size.height
    }
    
    //键盘隐藏
    func keyboardWasHide(_ notif: Notification) {
        
    }
    
    //隐藏键盘
    func hideKeyboard() {
        self.view.endEditing(true)
        navigationController?.view.endEditing(true)
    }
    
}















