//
//  FavSearchView.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/4/15.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit

class FavSearchView: UIView, UISearchBarDelegate {
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var sexBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view = Bundle.main.loadNibNamed("FavSearchView", owner: self, options: nil)?.first as? UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        sexBtn.layer.cornerRadius = 15
        sexBtn.layer.borderWidth = 0.5
        sexBtn.layer.borderColor = skinColor.cgColor
        nameBtn.layer.cornerRadius = 15
        nameBtn.layer.borderWidth = 0.5
        nameBtn.layer.borderColor = skinColor.cgColor
        
        searchBar.subviews[0].subviews[0].removeFromSuperview()
        let searchField = searchBar.value(forKey: "_searchField") as? UITextField
        searchField?.subviews[0].removeFromSuperview()
        searchField?.layer.cornerRadius = 15
        searchField?.layer.borderWidth = 0.5
        searchField?.layer.borderColor = skinColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func nameClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "film", data: nil)
    }
    
    @IBAction func sexClick(_ sender: UIButton) {
        publicDelegate?.dataHandler(type: "sex", data: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.length() > 0 {
            publicDelegate?.dataHandler(type: "search", data: searchBar.text!)
        }
    }
    
}
