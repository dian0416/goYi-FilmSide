//
//  InfoWorksTabelView.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/8.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

//class FilmModel {
//    var type:String?
//    var name:String?
//    var role:String?
//    var director:String?
//    var actor:String?
//    
//    init() {
//        
//    }
//}

class ShowInfoWorksView: UITableView, UITableViewDelegate, UITableViewDataSource, ControlDelegate {
    private let identifieradd = "addcell"
    private let identifierinfo = "infocell"
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
        head?.frame = CGRect(x: 0, y: 0, width: AppWidth, height: AppWidth/3*2-40)
        head?.headType = 1
        head?.levelLabel.layer.cornerRadius = 10
        head?.levelLabel.clipsToBounds = true
        
        return head!
    }()
    var backImage:String? {
        didSet{
            headView.backImageView.loadImage(backImage)
        }
    }
    var infoModel:UserBaseInfoModel?
    var selectIndex:Int = 3 {
        didSet{
            if btnArray.count > 0 {
                btnArray[selectIndex].addSubview(undrLine)
                headView.frame = CGRect(x: 0, y: 0, width: AppWidth, height: AppWidth/3*2-40)
                self.tableHeaderView = headView
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
    private lazy var filmTypes: [String] = {
        return ["院线电影", "网络大电影", "电视剧", "网络剧", "商业活动", "综艺"]
    }()
    var films: [String:[UserWorkModel]]? {
        didSet{
            self.reloadData()
        }
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: .plain)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        self.dataSource = self
        self.delegate = self
        self.tableHeaderView = headView
        self.tableViewDefault()
        register(UINib(nibName: "InfoWorksCell", bundle: nil), forCellReuseIdentifier: identifierinfo)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if films?.count > 0 {
            return films!.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 {
            if films?.count > 0 {
                let model = films![filmTypes[section-1]]
                return model!.count
            }
            
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
    
        if section > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierinfo) as? InfoWorksCell
            cell?.publicDelegate = self
            cell?.index = indexPath
            cell?.editBtn.isHidden = true
            let model = films![filmTypes[section-1]]?[row]
            cell?.model = model
            cell?.selectionStyle = .none
            
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "nono")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "nono")
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
            if header == nil {
                header = UITableViewHeaderFooterView(reuseIdentifier: "header")
                header?.contentView.backgroundColor = lineColor
                let line = UIImageView(frame: CGRect(x: 0, y: 49.5, width: AppWidth, height: 0.5))
                line.backgroundColor = lineColor
                
                header?.contentView.addSubview(sectionView)
                header?.contentView.addSubview(line)
            }
            
            return header
        }
        
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "video")
        if header == nil {
            header = UITableViewHeaderFooterView(reuseIdentifier: "video")
            header?.contentView.backgroundColor = lineColor
            
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: AppWidth-20, height: 50))
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor.black
            label.tag = 100
            header?.contentView.addSubview(label)
        }
        let lable = header?.contentView.viewWithTag(100) as! UILabel
        lable.text = filmTypes[section-1]
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section < films?.count && section > 0 {
            let model = films![filmTypes[section-1]]
            if model?.count > 0 {
                return 50
            }
            
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        }
        
        return UITableViewAutomaticDimension
    }
    
    func btnClick(sender: UIButton){
        publicDelegate?.dataHandler(type: "select", data: sender.tag-100)
    }
    
    func dataHandler(type: Any?, data: Any?) {
        publicDelegate?.dataHandler(type: type, data: data)
    }

}
