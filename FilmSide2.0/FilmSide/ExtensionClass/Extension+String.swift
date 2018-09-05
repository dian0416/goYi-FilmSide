//
//  StringExtension.swift
//  N+Store
//
//  Created by 米翊米 on 2016/7/14.
//  Copyright © 2016年 天宫. All rights reserved.
//

import UIKit

//String拓展
extension String {

    //字符串长度
    func length() -> Int {
        return self.utf16.count
    }
    
    //去空字符串
    func tirmSpace() -> String {
        var contentText = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        contentText = contentText.replacingOccurrences(of: " ", with: "")
        
        return contentText
    }
    
    //判断手机号码
    func authPhone() -> Bool {
        let telephoneRegex = "^(13[0-9]|15[0-9]|17[0678]|18[0-9]|14[57])[0-9]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", telephoneRegex)
        
        if !predicate.evaluate(with: self) || self.length() != 11 {
            return false
        }
        
        return true
    }
    
    //判断密码
    func authPass() -> Bool {
        if self.tirmSpace().length() < 6 || self.tirmSpace().length() > 20 {
            return false
        }
        
        return true
    }
    
    //判断验证码
    func authCode() -> Bool {
        if self.tirmSpace().length() != 4 {
            return false
        }
        
        return true
    }
    
    func subString(start:Int, length:Int) -> String {
        let begin = self.index(self.startIndex, offsetBy: start)
        let end = self.index(begin, offsetBy: length)
        
        return substring(with: begin..<end)
    }
    
    func stringIndex(index: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: index)
    }
    
    func index(atIndex: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: atIndex)
    }
    
    //时间戳转字符串
    func stringFormartDate(formart: String) -> String{
        let marter = DateFormatter()
        marter.dateFormat = formart
        
        if Double(self) != nil {
            let date = Date(timeIntervalSince1970: Double(self)!)
            return marter.string(from: date)
        }
        
        return ""
    }
    
    //获取字符串size
    func sizeString(font: UIFont, maxWidth:CGFloat) -> CGSize{
        let attributes = [NSFontAttributeName:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let rect:CGRect = self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: option, attributes: attributes, context: nil)
        
        return rect.size
    }
    
    //设置文字属性
    func attribute(color:UIColor, font:UIFont = UIFont.systemFont(ofSize: 15)) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: self)
        attrStr.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, self.length()))
        attrStr.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, self.length()))

        return attrStr
    }
    
    //获取拼音首字母
    func PYFirst(_ allFirst:Bool=false)->String{
        var py="#"
        
        let str = CFStringCreateMutableCopy(nil, 0, self as CFString!)
        CFStringTransform(str, nil, kCFStringTransformToLatin, Bool(0))
        CFStringTransform(str, nil, kCFStringTransformStripCombiningMarks, Bool(0))
        
        py = ""
        str.map { tmpstr in
            if allFirst {
                for (index,var value) in (tmpstr as String).components(separatedBy: " ").enumerated() {
                    if index == self.length()-1 {
                        value = "hang"
                    }
                    py += value.PYFirst()
                }
            } else {
                py  = (tmpstr as NSString).substring(to: 1).lowercased()
            }
        }
        
        return py
    }
    
}
