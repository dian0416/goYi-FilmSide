//
//  InputView.swift
//  Producer
//
//  Created by 米翊米 on 2017/3/24.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class InputView: UIView, ControlDelegate, UITextFieldDelegate {
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var pushBtn: UIButton!
    private lazy var emojiView:EmojiView = { [weak self] in
        let emoji = EmojiView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: AppWidth/7*4))
        emoji.backgroundColor = UIColor.white
        emoji.publicDelegate = self!
        
        return emoji
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.last as? UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        textFiled.layer.borderColor = backColor.cgColor
        textFiled.layer.borderWidth = 1
        textFiled.layer.cornerRadius = 5.0
        textFiled.delegate = self
        textFiled.returnKeyType = .send
        sendBtn.setImage(UIImage(named: "keybord"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        let range = textFiled.selectedTextRange
        textFiled.resignFirstResponder()
        if textFiled.inputView is EmojiView {
            textFiled.inputView = nil
            textFiled.becomeFirstResponder()
            textFiled.inputView?.reloadInputViews()
            sendBtn.setImage(UIImage(named: "keybord"), for: .normal)
        } else {
            textFiled.inputView = emojiView
            textFiled.becomeFirstResponder()
            sendBtn.setImage(UIImage(named: "face"), for: .normal)
        }
        if range != nil {
            textFiled.focusPosition(position: range!.start, offset: 0)
        }
    }
    
    func dataHandler(type: Any?, data: Any?) {
        let emoji = data as? String
        let types = type as? String
        
        if types == "emoji" {
            textFiled.insertThing(thing: emoji!)
        } else if types == "delete" {
            textFiled.deleteText()
        } else if types == "comment_send" {
            textFiled.resignFirstResponder()
            publicDelegate?.dataHandler(type: "send", data: textFiled.text)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.markedTextRange == nil {
            if string.isEmpty {
                textField.deleteText()
                
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFiled.resignFirstResponder()
        publicDelegate?.dataHandler(type: "send", data: textFiled.text)
        
        return true
    }
    
    @IBAction func sendClick(_ sender: UIButton) {
        textFiled.resignFirstResponder()
        publicDelegate?.dataHandler(type: "send", data: textFiled.text)
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        publicDelegate?.dataHandler(type: "send", data: textFiled.text)
//    }
}
