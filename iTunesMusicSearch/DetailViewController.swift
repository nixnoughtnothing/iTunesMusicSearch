//
//  DetailViewController.swift
//  iTunesMusicSearch
//
//  Created by nixnoughtnothing on 6/3/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DetailViewController: AVPlayerViewController {
    var trackName: String!
    var previewUrl: String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        title = trackName // titleの設定
        if let previewUrl = previewUrl{
            player = AVPlayer(URL: NSURL(string: previewUrl))
            player.play() // 自動再生
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
