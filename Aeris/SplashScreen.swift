//
//  SplashScreen.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-20.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class SplashScreen: UIViewController{
    
    var avPlayer: AVPlayer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if let path = Bundle.main.path(forResource: "Introduction", ofType: "mp4")
        {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            videoPlayer.showsPlaybackControls = false
            
            NotificationCenter.default.addObserver(self, selector: #selector(SplashScreen.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
            present(videoPlayer, animated: false, completion:
                {
                    video.play()
                })
            
        }
        
    }
    deinit {
        print("Remove NotificationCenter Deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func finishVideo()
    {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashScreen")
    }
}

