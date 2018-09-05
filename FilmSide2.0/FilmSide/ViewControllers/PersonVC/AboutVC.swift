//
//  AboutVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/8.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class AboutVC: UITableViewController {
    private lazy var infos: [[(title:String, image:String)]] = {
        var info = [[("功能介绍", "function")], [("功能使用意见反馈", "suggest")], [("免责声明", "disclaimer")]]
        
        return info
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Uncomment the following line to preserve selection between presentations
        navigationItem.title = "关于go艺"
        tableView.tableViewDefault()
        navigationBarTintColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return infos.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let identifier = "cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            
            cell?.textLabel?.textColor = titleColor
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            
            cell?.accessoryView = UIImageView(image: UIImage(named: "redright"))
        }
        let title = infos[section][row].title
        let image = infos[section][row].image
        cell?.imageView?.image = UIImage(named: image)
        cell?.textLabel?.text = title
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        if section == 0 {
            navigationController?.pushViewController(FunctionVC().hiddenTabBar(), animated: true)
        } else if section == 1 {
            let vc = DeliverVC(nibName: "DeliverVC", bundle: nil)
            vc.sourceType = 1
            let naviCtrl = UINavigationController(rootViewController: vc)
            present(naviCtrl, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(WebVC().hiddenTabBar(), animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

}
