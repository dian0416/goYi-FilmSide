//
//  VideoPlayVC.swift
//  Producer
//
//  Created by 米翊米 on 2017/4/5.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayVC: AVPlayerViewController {
    var videoUrl:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        let player = AVPlayer(url: videoUrl!)
        self.player = player
        player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        player?.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
