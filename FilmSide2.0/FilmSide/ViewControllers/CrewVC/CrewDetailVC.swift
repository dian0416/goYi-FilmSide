//
//  CrewDetailVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/20.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class CrewDetailVC: UITableViewController {
    private lazy var headView:UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: AppWidth/2))
        imgView.backgroundColor = skinColor
        
        return imgView
    }()
    private lazy var titleView:UIView = {[weak self] in
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 50))
        headView.backgroundColor = UIColor.white
        
        let titleArray = ["剧组信息", "角色信息"]
        let width = AppWidth/2
        for i in 0..<titleArray.count {
            let btn = UIButton(frame: CGRect(x: width*CGFloat(i), y: 0, width: width, height: 50))
            btn.setTitle(titleArray[i], for: .normal)
            btn.setTitleColor(skinColor, for: .normal)
            btn.tag = 100+i
            btn.addTarget(self!, action: #selector(self!.btnClick(sender:)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            self!.btnArray.append(btn)
            headView.addSubview(btn)
            if i == 0 {
                self!.btnClick(sender: btn)
            }
        }
        
        return headView
    }()
    private lazy var undrLine:UIImageView = {
        let line = UIImageView(frame: CGRect(x: ((AppWidth/2)-80)/2, y: 48, width: 80, height: 2))
        line.backgroundColor = skinColor
        
        return line
    }()
    private lazy var btnArray:[UIButton] = {
        return [UIButton]()
    }()
    private lazy var tagArray:[(key:String, value:String)] = {
        return [("1", "情报员"), ("2", "有情有义")]
    }()
    private var selectIndex = 0
    private let identifierGrop = "groupInfo"
    private let identifierBase = "roleBase"
    private let identifierTag = "roleTag"
    private let identifierAction = "roleAction"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        navigationBarTrans()
        tableView.tableViewDefault()
        tableView.tableHeaderView = headView
        tableView.register(UINib(nibName: "RoleActionCell", bundle: nil), forCellReuseIdentifier: identifierAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationAlpha(alpha: 1)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if selectIndex == 0 {
            return 1
        }
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectIndex == 0 {
            return 9
        }
        if section == 0 {
            return 5
        }
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if selectIndex == 0 || selectIndex == 1 && section == 1 && row == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: identifierGrop)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: identifierGrop)
                cell?.separatorZero()
                cell?.selectionStyle = .none
                
                cell?.textLabel?.textColor = subColor
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            }
            cell?.textLabel?.text = "剧名: 湄公河行动"
            
            return cell!
        }else{
            if section == 0 && row < 3 || section == 1 && row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: identifierBase)
                if cell == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: identifierBase)
                    cell?.separatorZero()
                    cell?.selectionStyle = .none
                    
                    cell?.textLabel?.textColor = subColor
                    cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
                    cell?.detailTextLabel?.textColor = subColor
                    cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
                }
                cell?.textLabel?.text = "体重: 70-80KG"
                cell?.detailTextLabel?.text = "身高: 178-185CM"
                
                return cell!
            }else if section == 0 && row == 3 {
                var cell = tableView.dequeueReusableCell(withIdentifier: identifierTag)
                if cell == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: identifierTag)
                    cell?.separatorZero()
                    cell?.selectionStyle = .none
                    
                    cell?.textLabel?.textColor = subColor
                    cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
                }
                cell?.textLabel?.text = "角色标签: "
                
                var tagView = cell?.contentView.viewWithTag(100) as? YMLabelCloud
                if tagView == nil {
                    tagView = YMLabelCloud(frame: CGRect(x: 80, y: 0, width: AppWidth-90, height: 0))
                    tagView?.tag = 100
                    tagView?.itemHeight = 20
                    tagView?.itemAble = false
                    tagView?.itemTextColor = subColor
                    cell?.contentView.addSubview(tagView!)
                }
                tagView?.titeArray = tagArray
                
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: identifierAction) as? RoleActionCell
                if section == 0 {
                    cell?.submitBtn.setTitle("申请", for: .normal)
                    cell?.tentLabel.text = "任务司法局:\n龙门石窟发快递哪家饭店南方科技阿萨德喀纳斯就能看见你富士康打发你可能对方那就是电脑上课那付款就那谁看得见发你"
                }else{
                    cell?.submitBtn.setTitle("报名", for: .normal)
                    cell?.tentLabel.text = "地址: 爱丽丝的疯狂开房间卡打开金风科技爱神的箭康师傅"
                }
                
                return cell!
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
            if header == nil {
                header = UITableViewHeaderFooterView(reuseIdentifier: "header")
                header?.contentView.backgroundColor = UIColor.white
                let line = UIImageView(frame: CGRect(x: 0, y: 49.5, width: AppWidth, height: 0.5))
                line.backgroundColor = lineColor
                
                header?.contentView.addSubview(titleView)
                header?.contentView.addSubview(line)
            }
            
            return header
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        if selectIndex == 1 {
            if section == 0 && row == 4 {
                let tent = "任务司法局:\n龙门石窟发快递哪家饭店南方科技阿萨德喀纳斯就能看见你富士康打发你可能对方那就是电脑上课那付款就那谁看得见发你"
                let size = tent.sizeString(font: UIFont.systemFont(ofSize: 15), maxWidth: AppWidth-24)
                
                return size.height + 70
            } else if section == 1 && row == 2 {
                let tent = "地址: 爱丽丝的疯狂开房间卡打开金风科技爱神的箭康师傅"
                let size = tent.sizeString(font: UIFont.systemFont(ofSize: 15), maxWidth: AppWidth-24)
                
                return size.height + 70
            }
        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        } else if selectIndex == 1 {
            return 10
        }
        
        return 0
    }
    
    func btnClick(sender: UIButton){
        sender.addSubview(undrLine)
        selectIndex = sender.tag-100
        tableView.reloadData()
    }

}
