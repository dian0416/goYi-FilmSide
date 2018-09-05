//
//  UITextFieldExtension.swift
//  N+Store
//
//  Created by 米翊米 on 16/8/26.
//  Copyright © 2016年 天宫. All rights reserved.
//

import UIKit

extension UITextField {
    
    func selectRange() -> (location: Int, length: Int) {
        if let select = self.selectedTextRange {
            let location = self.offset(from: beginningOfDocument, to: select.start)
            let length = self.offset(from: select.start, to: select.end)
            return (location, length)
        }
        
        return (0, 0)
    }
    
    func selectText() -> String {
        let range = selectRange()
        
        return self.text!.subString(start: range.location, length: range.length)
    }
    
    func selectFrontText() -> String {
        let range = selectRange()
        
        return self.text!.subString(start: 0, length: range.location)
    }
    
    func selectBehindText() -> String {
        let range = selectRange()
        
        return self.text!.subString(start: range.location, length: text!.characters.count-range.location)
    }
    
    func insertThing(thing: String) {
        var range = selectedTextRange!.end
        var frotText = selectFrontText()
        let rangeText = selectText()
        if rangeText.isEmpty {
            let behindText = selectBehindText()
            frotText += thing + behindText
            self.text = frotText
        } else {
            range = selectedTextRange!.start
            self.text = text?.replacingOccurrences(of: rangeText, with: thing)
        }
        focusPosition(position: range, offset: thing.characters.count)
    }
    
    func focusPosition(position: UITextPosition, offset: Int){
        let start = self.position(from: position, offset: offset)
        let end = self.position(from: start!, offset: 0)
        let range = self.textRange(from: start!, to: end!)
        
        self.selectedTextRange = range
    }
    
    func deleteText() {
        var text = self.selectText()
        
        var isEmoji = false
        if text.isEmpty {
            text = self.selectFrontText()
        }
        if text.hasSuffix("]") {
            var rang = text.range(of: "[", options: [.backwards])
            if rang != nil {
                let str = text.substring(from: rang!.lowerBound)
                for emojiStr in emojiTexts {
                    if str == emojiStr {
                        rang = text.range(of: str, options: [.backwards])
                        text = text.replacingCharacters(in: rang!, with: "")
                        let tmp = self.selectedTextRange!
                        self.text = text+self.selectBehindText()
                        self.focusPosition(position: tmp.start, offset: -str.characters.count)
                        isEmoji = true
                        break
                    }
                }
                if !isEmoji {
                    self.deleteBackward()
                }
            } else {
                self.deleteBackward()
            }
        }else{
            self.deleteBackward()
        }
    }

    struct constVar{
        static var pading:CGFloat = 10
//        static var leftRect:CGRect = CGRect.zero
        static var isExchange = false
    }
    
    //方法交换
    class func swizzMethod(){
        if !constVar.isExchange {
            let textRectMethod = class_getInstanceMethod(self.classForCoder(), NSSelectorFromString("textRectForBounds:"))
            let exchangeRectMethod = class_getInstanceMethod(self.classForCoder(), #selector(self.textRectBounds(_:)))
            let editingRectMethod = class_getInstanceMethod(self.classForCoder(), NSSelectorFromString("editingRectForBounds:"))
            let exchangeEditingMethod = class_getInstanceMethod(self.classForCoder(), #selector(self.editingRectBounds(_:)))
//            let leftRectMethod = class_getInstanceMethod(self.classForCoder(), NSSelectorFromString("leftViewRectForBounds:"))
//            let exchangeleftMethod = class_getInstanceMethod(self.classForCoder(), #selector(self.leftViewBounds(_:)))
            
            method_exchangeImplementations(textRectMethod, exchangeRectMethod)
            method_exchangeImplementations(editingRectMethod, exchangeEditingMethod)
//            method_exchangeImplementations(leftRectMethod, exchangeleftMethod)
            
            constVar.isExchange = true
        }
    }
    
    func textRectBounds(_ bounds: CGRect) -> CGRect {
        if self.leftView != nil {
            return bounds.insetBy(dx: self.leftView!.frame.width+constVar.pading, dy: 0)
        }
        return bounds.insetBy(dx: constVar.pading, dy: 0)
    }
    
    func editingRectBounds(_ bounds:CGRect) -> CGRect {
        if self.leftView != nil {
            return bounds.insetBy(dx: self.leftView!.frame.width+constVar.pading, dy: 0)
        }
        return bounds.insetBy(dx: constVar.pading, dy: 0)
    }
    
    //验证文本是否为空
    func emptyText() -> String {
        if text == nil {
            return ""
        }
        
        return text!
    }
    
//    func leftViewBounds(_ bounds:CGRect) -> CGRect {
//        return constVar.leftRect
//    }
    
}
