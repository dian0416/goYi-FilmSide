//
//  DisclaimerVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/8.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class DisclaimerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarTintColor()
        navigationItem.title = "免责声明"
        let textView = UITextView(frame: CGRect(x: 5, y: 0, width: AppWidth-5, height: AppHeight))
        textView.textColor = titleColor
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.isEditable = false
        textView.text = ""
        self.view.addSubview(textView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
