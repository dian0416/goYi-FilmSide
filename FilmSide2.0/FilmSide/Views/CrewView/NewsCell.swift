//
//  NewsCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/19.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lookLbl: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var addrBtn: UIButton!
    @IBOutlet weak var deliveryBtn: UIButton!
    @IBOutlet weak var descLbl: UIButton!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var typeWidth: NSLayoutConstraint!
    @IBOutlet weak var typeHeight: NSLayoutConstraint!
    //1院线电影2网络大电影3电视剧4网络剧5商业活动6综艺
    private lazy var filmTypes: [String] = {
        return ["院线电影", "网络大电影", "电视剧", "网络剧", "商业活动", "综艺"]
    }()
    
    var model:FilmInfoModel? {
        didSet{
            nameLbl.text = model?.filmName
            lookLbl.setTitle("\(model!.readCount)", for: .normal)
            imgView.loadImage(model?.messageImg)
            addrBtn.setTitle(model?.shotPlace, for: .normal)
            var desc = ""
            if let time = model?.startTime {
                 desc = "开机时间\(time)"
            }
            if let time = model?.endTime {
                desc.append(" 招募结束时间\(time)")
            }
            descLbl.setTitle(desc, for: .normal)
            typeLbl.isHidden = true
            if let type = model?.movieId {
                if type-1 < filmTypes.count && type-1 >= 0 {
                    typeLbl.isHidden = false
                    typeLbl.text = filmTypes[type-1]
                    
                    let size = typeLbl.text!.sizeString(font: UIFont.systemFont(ofSize: 13), maxWidth: AppWidth)
                    typeWidth.constant = size.width+20
                    typeHeight.constant = size.height+5
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        separatorZero()
        
        nameLbl.font = UIFont.systemFont(ofSize: 15)
        lookLbl.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        typeLbl.font = UIFont.systemFont(ofSize: 13)
        typeLbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        addrBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        descLbl.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        deliveryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        deliveryBtn.isUserInteractionEnabled = false
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        loadHUD()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) { 
            self.textHUD("简历投递成功")
        }
    }
}
