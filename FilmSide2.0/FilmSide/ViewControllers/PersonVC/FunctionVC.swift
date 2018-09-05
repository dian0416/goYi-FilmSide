//
//  FunctionVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/8.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class FunctionVC: UITableViewController {
    private lazy var infos: [String] = {
        return ["你可以查看剧组信息，申请实验的角色。", "我们会把你推荐给剧组。会议消息的形式告知你是否被推荐或选中", "你通过签到、互动(点赞、评论)、邀请好友完善资料获取积分。", "积分排名靠前可获得映视之星、周冠军称号。", "你可以在广场发布动态"]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        navigationItem.title = "功能介绍"
        navigationBarTintColor()
        tableView.tableViewDefault()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cll"
        let row = indexPath.row
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            cell?.selectionStyle = .none
            
            cell?.textLabel?.textColor = titleColor
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.numberOfLines = 0
            
            let redView = UIImageView(frame: CGRect(x: 6, y: 19.5, width: 5, height: 5))
            redView.clipsToBounds = true
            redView.layer.cornerRadius = 2.5
            redView.backgroundColor = skinColor
            cell?.contentView.addSubview(redView)
        }
        cell?.textLabel?.text = infos[row]

        return cell!
    }
 
}
