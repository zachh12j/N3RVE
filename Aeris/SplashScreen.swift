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
    
    var player: AVAudioPlayer?
    var avPlayer: AVPlayer!
    var window: UIWindow?
    var AudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SplashScreenSound()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if let path = Bundle.main.path(forResource: "SplashScreen", ofType: "mp4")
        {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            videoPlayer.showsPlaybackControls = false
            videoPlayer.videoGravity=AVLayerVideoGravity.resizeAspectFill;
            
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
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Home") as UIViewController
        
        vc.view.alpha = 0
        UIView.animate(withDuration: 1.0, animations:
        {
            vc.view.alpha = 1
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
            
        }, completion: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
        
        //Partir la musique
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "BackgroundMusic3", ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.volume = 0.15
        AudioPlayer.play()
    }
    
    func SplashScreenSound() {
        let url = Bundle.main.url(forResource: "SplashScreenSound", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

