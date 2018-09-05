//
//  Extension+UIImageView.swift
//  WineDealer
//
//  Created by 米翊米 on 2017/3/13.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlStr: String? = nil, placeholder:UIImage? = UIImage(named: "default")) {
        let urlString = urlStr?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if urlString == nil {
            self.kf.setImage(with: nil, placeholder: placeholder, options: [.targetCache(.default)], progressBlock: nil, completionHandler: nil)
//            self.image = UIImage(named: "error")
        } else {
            let str = "\(urlString!)"
            if let url = URL(string: str) {
                self.kf.setImage(with: url, placeholder: placeholder, options: [.targetCache(.default)], progressBlock: nil, completionHandler: { (dimage, _, _, _) in
                    if dimage != nil {
                        self.image = dimage
                    } else {
                        self.image = placeholder
                    }
                })
            } else {
                self.image = placeholder
//                self.kf.setImage(with: nil, placeholder: placeholder, options: [.targetCache(.default)], progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    func imageCell(cell: UITableViewCell?) {
        let itemSize = CGSize(width: 60, height: 60)
        
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
        let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        cell?.imageView?.image?.draw(in: imageRect)
        cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
}

extension UIButton {
    
    func loadImage(_ urlStr: String? = nil, placeholder:UIImage? = UIImage(named: "default")) {
        let urlString = urlStr?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if urlString == nil {
            self.kf.setImage(with: nil, for: .normal, placeholder: placeholder, options: [.targetCache(.default)], progressBlock: nil, completionHandler: nil)
//            self.setImage(UIImage(named: "error"), for: .normal)
        } else {
            let str = "\(urlString!)"
            if let url = URL(string: str) {
                self.kf.setImage(with: url, for: .normal, placeholder: placeholder, options: [.targetCache(.default)], progressBlock: nil, completionHandler: { (dimage, _, _, _) in
                    if dimage != nil {
                        self.setImage(dimage, for: .normal)
                    } else {
                        self.setImage(placeholder, for: .normal)
                    }
                })
            } else {
                self.kf.setImage(with: nil, for: .normal, placeholder: placeholder, options: [.targetCache(.default)], progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    func loadBackImage(_ urlStr: String? = nil, placeholder:UIImage? = UIImage(named: "default")) {
        let urlString = urlStr?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if urlString == nil {
            self.kf.setBackgroundImage(with: nil, for: .normal, placeholder: placeholder, options: [.targetCache(.default)], progressBlock: nil, completionHandler: nil)
        } else {
            let str = "\(urlString!)"
            if let url = URL(string: str) {
                self.kf.setBackgroundImage(with: url, for: .normal, placeholder: placeholder, options: [.targetCache(.default)], progressBlock: nil, completionHandler: { (dimage, _, _, _) in
                    if dimage != nil {
                        self.setBackgroundImage(dimage, for: .normal)
                    } else {
                        self.setBackgroundImage(placeholder, for: .normal)
                    }
                })
            } else {
//                self.kf.setBackgroundImage(with: nil, for: .normal, placeholder: placeholder, options: [.targetCache(.default)], progressBlock: nil, completionHandler: nil)
                self.setBackgroundImage(placeholder, for: .normal)
            }
        }
    }
    
}
