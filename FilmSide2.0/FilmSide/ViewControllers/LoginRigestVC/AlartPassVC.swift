//
//  AlartPassVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/9.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class AlartPassVC: UIViewController {
    @IBOutlet weak var oldField: UITextField!
    @IBOutlet weak var newField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var viewH: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarTintColor()
        navigationItem.title = "修改密码"
        submitBtn.layer.cornerRadius = 8
        
        let leftView = UIImageView(frame: CGRect(x: 10, y: 12.5, width: 25, height: 25))
        leftView.image = UIImage(named: "password")
        oldField.leftView = leftView
        oldField.leftViewMode = .always
        
        let rightView = UIImageView(frame: CGRect(x: 10, y: 12.5, width: 25, height: 25))
        rightView.image = UIImage(named: "password")
        newField.leftView = rightView
        newField.leftViewMode = .always
        
        oldField.font = UIFont.systemFont(ofSize: 15)
        newField.font = UIFont.systemFont(ofSize: 15)
        submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewH.constant = NaviViewH
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
