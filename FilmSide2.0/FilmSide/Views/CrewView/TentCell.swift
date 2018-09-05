//
//  TentCell.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/23.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class TentCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textH: NSLayoutConstraint!
    @IBOutlet weak var textBottom: NSLayoutConstraint!
    
    var model:CommentModel? {
        didSet{
            let attrStr = NSMutableAttributedString()
            if let nick = model?.realName {
                attrStr.append(nick.attribute(color: skinColor, font: UIFont.systemFont(ofSize: 12)))
            }
            if let beenCommentName = model?.beenCommentName {
                
                attrStr.append("回复".attribute(color: titleColor, font: UIFont.systemFont(ofSize: 12)))
                attrStr.append("\(beenCommentName)".attribute(color: skinColor, font: UIFont.systemFont(ofSize: 12)))
                attrStr.append(":".attribute(color: titleColor, font: UIFont.systemFont(ofSize: 12)))
            }
            if let content = model?.content {
                attrStr.append(replaceEmoji(content))
            }
            let size = attrStr.size()
            textH.constant = size.height+5
            titleLabel.attributedText = attrStr
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.separatorZero()
        self.separatorHidden()
        self.selectionStyle = .none
        self.contentView.backgroundColor = lightColor
        titleLabel.numberOfLines = 0
        
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func downClick(_ sender: UIButton) {
        print("sdsfd")
        sender.backgroundColor = backColor
    }
    
    @IBAction func textClick(_ sender: UIButton) {
        sender.backgroundColor = UIColor.clear
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
