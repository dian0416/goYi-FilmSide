//
//  CommentCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/23.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tentLbl: UILabel!
    @IBOutlet weak var typeHeight: NSLayoutConstraint!
    @IBOutlet weak var typeWidth: NSLayoutConstraint!
    @IBOutlet weak var tentBottom: NSLayoutConstraint!
    
    var model:CommentModel? {
        didSet{
            imgBtn.imageView?.contentMode = .scaleAspectFill
            imgBtn.loadImage(model?.headImg)
            nameLbl.text = model?.realName
            typeLbl.text = model?.integralName
            if typeLbl.text != nil {
                let size = typeLbl.text!.sizeString(font: UIFont.systemFont(ofSize: 12), maxWidth: AppWidth)
                typeWidth.constant = size.width+2
                typeHeight.constant = size.height
            }
            timeLbl.text = nil
            if let time = model?.addTime {
                timeLbl.text = "\(time/1000)".stringFormartDate(formart: "yyyy-MM-dd")
            }
            if let content = model?.content {
                let attrStr =  replaceEmoji(content)
                tentLbl.attributedText = attrStr
            }
            
            if model?.beenCommentList?.count > 0 {
                tentBottom.constant = 5
            } else {
                tentBottom.constant = 15
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = lightColor
        self.separatorZero()
        imgBtn.layer.cornerRadius = 20
        imgBtn.clipsToBounds = true
        commentBtn.setImage(UIImage(named: "comment"), for: .normal)
        typeLbl.layer.cornerRadius = 7.5
        typeLbl.clipsToBounds = true
        typeLbl.layer.borderColor = skinColor.cgColor
        typeLbl.layer.borderWidth = 1
        tentLbl.font = UIFont.systemFont(ofSize: 13)
        nameLbl.font = UIFont.systemFont(ofSize: 15)
        timeLbl.font = UIFont.systemFont(ofSize: 11)
        typeLbl.font = UIFont.systemFont(ofSize: 11)
    }

    @IBAction func userClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "user", data: model?.actorId)
    }
    
    @IBAction func commentClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "tent", data: model)
    }
    
    //MARK: Public Methods
    func replaceEmoji(_ str: String) -> NSAttributedString {
        //String的格式
        let textAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: titleColor]
        //正则表达式的格式
        let pattern = "\\[+[^ -~]+\\]"
        //表情的bounds
        let attachmentBounds = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 18, height: 18))
        //转成NSString
        let originalNSString = str as NSString
        //通过str获得NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: textAttributes)
        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        //获取到匹配正则的数据
        if let matches = regex?.matches(in: str, options: .withoutAnchoringBounds, range: NSMakeRange(0,attStr.string.characters.count)) {
            if matches.count > 0 {
                //遍历符合的数据进行解析
                for i in 0..<matches.count {
                    let result = matches[matches.count-i-1]
                    let range = result.range
                    let emojiStr = originalNSString.substring(with: range)
                    //符合的数据是否为表情
                    if let index = emojiTexts.index(of: emojiStr) {
                        let str = emojiPics[index]
                        if let image = UIImage(named: str) {
                            //创建一个NSTextAttachment
                            let attachment    = NSTextAttachment()
                            attachment.image  = image
                            attachment.bounds = attachmentBounds
                            //通过NSTextAttachment生成一个NSAttributedString
                            let rep = NSAttributedString(attachment: attachment)
                            //把表情于之前的字符串替换
                            attStr.replaceCharacters(in: range, with: rep)
                        }
                    }
                }
            }
        }
        return attStr
    }

}
