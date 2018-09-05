//
//  InfoVideoView.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/4.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class ShowInfoVideoView: UITableView, UITableViewDelegate, UITableViewDataSource, ControlDelegate {
    private let identifier = "cell"
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
        head?.publicDelegate = self
        
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
    var videoArray:[(url:String?, imageUrl:String?, image:UIImage?)]? {
        didSet{
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    func setup(){
        self.dataSource = self
        self.delegate = self
        self.tableHeaderView = headView
        self.tableViewDefault()
        self.register(UINib(nibName: "InfoVideoCell", bundle: Bundle.main), forCellReuseIdentifier: identifier)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videoArray?.count != nil {
            return videoArray!.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? InfoVideoCell
        
        cell?.publicDelegate = self
        cell?.playBtn.setImage(UIImage(named: "play"), for: .normal)
        cell?.playBtn.setTitle(nil, for: .normal)
        cell?.closeBtn.tag = 100+row
        cell?.closeBtn.isHidden = true
        cell?.videoImgView.loadImage(videoArray?[row].imageUrl)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func dataHandler(type: Any?, data: Any?) {
        publicDelegate?.dataHandler(type: type, data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnClick(sender: UIButton){
        publicDelegate?.dataHandler(type: "select", data: sender.tag-100)
    }

}
