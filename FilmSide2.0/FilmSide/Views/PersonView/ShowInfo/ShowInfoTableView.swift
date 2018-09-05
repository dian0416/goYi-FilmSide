//
//  InfoTableView.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/4.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ShowInfoTableView: UITableView, UITableViewDelegate, UITableViewDataSource,ControlDelegate {
    private lazy var sectionView:UIView = {[weak self] in
        let section = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 50))
        section.backgroundColor = UIColor.white
        
        let titleArray = ["简介", "照片", "视频", "作品"]
        let width = AppWidth/4
        for i in 0..<titleArray.count {
            let btn = UIButton(frame: CGRect(x: width*CGFloat(i), y: 0, width: width, height: 50))
            btn.setTitle(titleArray[i], for: .normal)
            btn.setTitleColor(skinColor, for: .normal)
            btn.tag = 100+i
            btn.addTarget(self!, action: #selector(self!.btnClick(sender:)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            if self!.selectIndex == i {
                btn.addSubview(self!.undrLine)
            }
            self!.btnArray.append(btn)
            section.addSubview(btn)
        }
        
        return section
    }()
    private lazy var undrLine:UIImageView = {
        let line = UIImageView(frame: CGRect(x: ((AppWidth/4)-60)/2, y: 48, width: 60, height: 2))
        line.backgroundColor = skinColor
        
        return line
    }()
    private lazy var btnArray:[UIButton] = {
        return [UIButton]()
    }()
    lazy var headView: PersonHeadView = { [weak self] in
        let head = Bundle.main.loadNibNamed("PersonHeadView", owner: self, options: nil)?.first as? PersonHeadView
        head?.headType = 1
        head?.publicDelegate = self
        head?.frame = CGRect(x: 0, y: 0, width: AppWidth, height: AppWidth/3*2-40)
        
        return head!
    }()
    private lazy var constellations: [(id:Int, value:String)] = {
        let valus = ["水瓶座", "双鱼座", "白羊座", "金牛座", "双子座", "巨蟹座", "狮子座", "处女座", "天枰座", "天蝎座", "射手座", "摩羯座"]
        var tmps = [(id:Int, value:String)]()
        for (i, value) in valus.enumerated() {
            tmps.append((i, value))
        }
        return tmps
    }()
    var infoModel:UserBaseInfoModel? {
        didSet{
            self.selectIndex = 0
            self.initData()
        }
    }
    private lazy var titleArray: [(key:String, value:String?)] = {[unowned self] in
        let titles = ["姓名:", "昵称:", "性别:", "出生年月:", "星座:", "身高:", "体重:"/*, "年龄段*:", "常住地*"*/, "毕业院校:", "所学专业:", "语言能力:", "经纪公司:", "经纪人手机号码:"]
        var tups = [(key:String, value:String?)]()
        for title in titles {
            tups.append((title, ""))
        }
        
        return tups
    }()
    private lazy var personality: [[(id:Int, value:String, select:Bool)]] = {[unowned self] in
        var datas = [[(id:Int, value:String, select:Bool)]]()
        
        var roles = [(id:Int, value:String, select:Bool)]()
        if self.infoModel?.line?.count > 0 {
            for model in self.infoModel!.line! {
               roles.append((model.id!, model.lineName!, false))
            }
        }
        datas.append(roles)
        
        var pers = [(id:Int, value:String, select:Bool)]()
        if self.infoModel?.lables?.count > 0 {
            for model in self.infoModel!.lables! {
                pers.append((model.id!, model.labelName!, false))
            }
        }
        datas.append(pers)
        
        var seps = [(id:Int, value:String, select:Bool)]()
        if self.infoModel?.specialiy?.count > 0 {
            for model in self.infoModel!.specialiy! {
                seps.append((model.id!, model.specialtyName!, false))
            }
        }
        datas.append(seps)
        
        return datas
    }()
    private let identifierWrite = "write"
    private let identifierSelect = "select"
    private let identifierLabel = "label"
    private let identifierText = "text"
    private var personalitySelect = ""
    private var specialtySelect = ""
    private var roleSelect = ""
    var backImage:String? {
        didSet{
            headView.backImageView.loadImage(backImage)
        }
    }
    var selectIndex:Int = 0 {
        didSet{
            if btnArray.count > 0 {
                btnArray[selectIndex].addSubview(undrLine)
            }
            headView.userButton.loadImage(infoModel?.actor?.headImg)
            headView.nameLabel.text = infoModel?.actor?.nickName
            headView.levelLabel.text = infoModel?.actor?.integralName
            headView.winnerButton.isHidden = false
            let star = infoModel?.actor?.starType == nil ? 0:infoModel!.actor!.starType
            if star == 1 {
                headView.winnerButton.setTitle("周冠军", for: .normal)
            } else if star == 2 {
                headView.winnerButton.setTitle("月冠军", for: .normal)
            } else {
                headView.winnerButton.isHidden = true
            }
        }
    }
    var actorid:Int? {
        didSet{
            headView.nameLabel.text = nil
        }
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.dataSource = self
        self.delegate = self
        self.tableHeaderView = headView
        self.tableViewDefault()
        
        self.register(UINib(nibName: "WriteInfoCell", bundle: nil), forCellReuseIdentifier: identifierWrite)
        self.register(UINib(nibName: "SelectInfoCell", bundle: nil), forCellReuseIdentifier: identifierSelect)
        self.register(UINib(nibName: "TextViewCell", bundle: nil), forCellReuseIdentifier: identifierText)
        self.register(LabelViewCell.self, forCellReuseIdentifier: identifierLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(){
        if let info = self.infoModel?.actor {
            titleArray[0].value = info.realName
            titleArray[1].value = info.nickName
            if info.sex == 1 {
                titleArray[2].value = "男"
            } else if info.sex == 0 {
                titleArray[2].value = "女"
            }
            if info.display == 1 {
                titleArray[3].value = info.birthday
            } else {
                titleArray[3].value = "保密"
            }
            if info.constellation-1 > 0 && info.constellation < 13  {
                titleArray[4].value = constellations[info.constellation-1].value
            }
            titleArray[5].value = "\(info.height)"
            titleArray[6].value = "\(info.weight)"
            titleArray[7].value = info.school
            titleArray[8].value = info.major
            titleArray[9].value = info.language
            titleArray[10].value = info.brokerageFirm
            titleArray[11].value = info.brokerMobile
        }
        self.reloadData()
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if infoModel?.actor?.broker > 0 {
                return titleArray.count
            }
            return titleArray.count-2
        } else if section == 1 {
            if infoModel == nil {
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            return infoConfigCell(tableView: tableView, indexPath: indexPath)
        } else if section == 1 {
            return labelConfigCell(tableView: tableView, indexPath: indexPath)
        } else {
            return textConfigCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
            if header == nil {
                header = UITableViewHeaderFooterView(reuseIdentifier: "header")
                header?.contentView.backgroundColor = UIColor.white
                let line = UIImageView(frame: CGRect(x: 0, y: 49.5, width: AppWidth, height: 0.5))
                line.backgroundColor = lineColor
                
                header?.contentView.addSubview(sectionView)
                header?.contentView.addSubview(line)
            }
            
            return header
        }
        if selectIndex == 0 && section == 2 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header2")
            if header == nil {
                header = UITableViewHeaderFooterView(reuseIdentifier: "header2")
                header?.contentView.backgroundColor = lineColor
                let titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: AppWidth-20, height: 40))
                titleLabel.textColor = subColor
                titleLabel.font = UIFont.systemFont(ofSize: 15)
                titleLabel.text = "个人简介"
                
                header?.contentView.addSubview(titleLabel)
            }
            
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        if section == 2 {
            return 40
        }
        
        return 0
    }
    
    
    func infoConfigCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierWrite) as? WriteInfoCell
        cell?.titleLabel.text = titleArray[row].key
        cell?.texitField.isUserInteractionEnabled = false
        cell?.texitField.placeholder = nil
        let width = titleArray[row].key.sizeString(font: UIFont.systemFont(ofSize: 15), maxWidth: 150).width
        cell?.titleWidth.constant = width+5
        if cell?.descLabel != nil {
            cell?.descLabel.removeFromSuperview()
        }
        if titleArray[row].key.hasPrefix("出生年月*") {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierSelect) as? SelectInfoCell
            cell?.leftButton.isHidden = true
            cell?.rightButton.isHidden = true
            cell?.titleLabel.text = titleArray[row].key
            cell?.descLabel.text = titleArray[row].value
            cell?.indexPath = indexPath
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierWrite) as? WriteInfoCell
            cell?.texitField.placeholder = nil
            if cell?.descLabel != nil {
                cell?.descLabel.removeFromSuperview()
            }
            cell?.texitField.isUserInteractionEnabled = false
            cell?.titleLabel.text = titleArray[row].key
            cell?.texitField.text = titleArray[row].value
            let width = titleArray[row].key.sizeString(font: UIFont.systemFont(ofSize: 15), maxWidth: 150).width
            cell?.titleWidth.constant = width+5
            cell?.indexPath = indexPath
            
            return cell!
        }
    }
    
    func labelConfigCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierLabel) as? LabelViewCell
        cell?.dataModels = personality
        cell?.isUserInteractionEnabled = false
        
        return cell!
    }
    
    func textConfigCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierText) as? TextViewCell
        cell?.selectionStyle = .none
        cell?.textView.isUserInteractionEnabled = false
        cell?.placeLabel.isHidden = true
        cell?.textView.text = infoModel?.actor?.remark
        
        return cell!
    }
    
    func btnClick(sender: UIButton){
        publicDelegate?.dataHandler(type: "select", data: sender.tag-100)
    }
    
    func dataHandler(type: Any?, data: Any?) {
        publicDelegate?.dataHandler(type: "fav", data: nil)
    }
    
}
