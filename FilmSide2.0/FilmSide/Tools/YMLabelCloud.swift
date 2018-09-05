//
//  STLabelCloud.swift
//  N+Store
//
//  Created by 米翊米 on 16/8/12.
//  Copyright © 2016年 天宫. All rights reserved.
//

import UIKit

class YMLabelCloud: UIView {
    lazy var btnArray:[UIButton] = {
        return [UIButton]()
    }()
    //列数默认为0则不规则排，大于0则按固定列数
    var row = 0
    //是否改变按钮和文字颜色
    var changeColor = false
    var type:String?
    var itemHeight:CGFloat = 25
    var maxWidth:CGFloat = 0
    var ymwidth:CGFloat = 0
    var itemBackColor = UIColor.white
    var itemTextColor = skinColor
    var coruis:CGFloat = 0
    var itemAble = true
    var font = UIFont.systemFont(ofSize: 14)
    var miniWidth:CGFloat = 0
    var spaceH:CGFloat = 10
    var spaceW:CGFloat = 10
    var titeArray:[(key:String?, value:String?)]? {
        didSet{
            var frame = self.frame
            var offsetY:CGFloat = 10
            var offsetX:CGFloat = 10
            let space:CGFloat = 10
            let count = titeArray == nil ? 0:titeArray!.count
            //创建按钮
            for i in 0..<count {
                let title = titeArray![i].value
                var button:UIButton!
                if i < btnArray.count {
                    button = btnArray[i]
                }else{
                    button = UIButton()
                    button.titleLabel?.font = font
                    button.setTitleColor(itemTextColor, for: .normal)
                    button.backgroundColor = itemBackColor
                    button.tag = 100+i
                    button.layer.borderWidth = 0.5
                    button.layer.borderColor = itemTextColor.cgColor
                    button.titleLabel?.lineBreakMode = .byTruncatingTail
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
                    button.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
                    button.isUserInteractionEnabled = itemAble
                    
                    btnArray.append(button)
                    self.addSubview(button)
                }
                button.isHidden = false
                button.setTitle(title, for: .normal)
                let vWidth = frame.size.width - 20
                var bWidth:CGFloat = 0
                //固定列数
                if row > 0 {
                    let spaces = CGFloat((row-1))*(space)
                    let mores = CGFloat(row*10)
                    bWidth = (vWidth-spaces-mores)/CGFloat(row)
                }else{
                    //按照文字内容
                    bWidth = (title?.sizeString(font: button.titleLabel!.font, maxWidth: vWidth).width)!
                    if bWidth < miniWidth {
                        bWidth = miniWidth
                    }
                    //文字内容超出最大宽度就用最大宽度
                    if bWidth > vWidth - 30 {
                        bWidth = vWidth - 30
                    }
                    bWidth += 5
                }
                
                itemHeight = (title?.sizeString(font: button.titleLabel!.font, maxWidth: vWidth).height)!+spaceH
                if coruis > 0 {
                    button.layer.cornerRadius = coruis
                } else {
                    button.layer.cornerRadius = itemHeight/2
                }
                
                //判读是否换行
                if offsetX + bWidth > frame.size.width-20 {
                    offsetX = 10
                    offsetY += itemHeight+10
                    
                    maxWidth = frame.size.width
                }
                
                //设置按钮frame
                button.frame = CGRect(x: offsetX, y: offsetY, width: bWidth+10, height: itemHeight)
                offsetX += bWidth+10+space
            }
            for i in count..<btnArray.count{
                btnArray[i].isHidden = true
            }
            
            frame.size.height = offsetY+itemHeight+10
            self.frame = frame
            ymwidth = offsetX
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //点击事件
    func btnClick(sender: UIButton) {
        let tag = sender.tag - 100
        
        for btn in btnArray {
            btn.backgroundColor = itemBackColor
//            btn.layer.borderWidth = 0.5
//            btn.layer.borderColor = goldColor.cgColor
            btn.setTitleColor(itemTextColor, for: .normal)
            if btn != sender {
                btn.isSelected = false
            }
        }
        
        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//            sender.backgroundColor = itemTextColor
//            sender.setTitleColor(itemBackColor, for: .normal)
//        }
        
        if type != nil {
            var data = (key:type!, value:titeArray![tag].key)
            if sender.isSelected {
                self.publicDelegate?.dataHandler(type: nil, data: data)
            }else{
                data.value = ""
                self.publicDelegate?.dataHandler(type: nil, data: data)
            }
        }else{
            self.publicDelegate?.dataHandler(type: titeArray![tag].key, data: titeArray![tag])
        }
    }
    
    func noCheck(sender: UIButton) {
        for btn in btnArray {
            btn.backgroundColor = itemBackColor
            btn.setTitleColor(itemTextColor, for: .normal)
            if btn != sender {
                btn.isSelected = false
            }
        }
    }

}

//历史记录
class HistoryNote {
    let hisPath:String = {
        //Home目录
        let homeDirectory = NSHomeDirectory()
        //Cache目录
        let cachesPath = homeDirectory + "/Library/Caches"
        
        return cachesPath + "/histroynote"
    }()
    static let shareNote = HistoryNote()
    private let managerFile = FileManager()
    
    //保存记录
    class func saveNote(note: String){
        var notes = HistoryNote.loadNotes()
        if notes == nil {
            notes = [String]()
        }

        if notes?.index(of: note) != nil {
            notes?.remove(at: notes!.index(of: note)!)
        }
        notes?.insert(note, at: 0)
        (notes! as NSArray).write(toFile: HistoryNote.shareNote.hisPath, atomically: true)
    }
    
    //取出记录
    class func loadNotes() -> [String]? {
        var notes:[String]?
        if HistoryNote.shareNote.managerFile.fileExists(atPath: HistoryNote.shareNote.hisPath) {
            notes = NSArray(contentsOfFile: HistoryNote.shareNote.hisPath) as? Array
        }
        
        return notes
    }
    
    //删除记录
    class func removeNotes(){
        if HistoryNote.shareNote.managerFile.fileExists(atPath: HistoryNote.shareNote.hisPath) {
            try? HistoryNote.shareNote.managerFile.removeItem(atPath: HistoryNote.shareNote.hisPath)
        }
    }
    
}
