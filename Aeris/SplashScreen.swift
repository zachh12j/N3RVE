//
//  SplashScreen.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-20.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SplashScreen: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var avPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let path = Bundle.main.path(forResource: "Introduction", ofType: "mp4")
        {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            videoPlayer.showsPlaybackControls = false
            
            present(videoPlayer, animated: true, completion:
                {
                    video.play()
            })
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(Settings.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func finishVideo()
    {
        print("Video Finished")
    }
    
}
