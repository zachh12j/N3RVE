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
    @IBOutlet weak var containerView: UIView!
    
    var videoPlayer = AVPlayerViewController()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SplashScreenSound()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        if let path = Bundle.main.path(forResource: "SplashScreenN", ofType: "mp4")
        {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            videoPlayer.player = video
            videoPlayer.showsPlaybackControls = false
            videoPlayer.videoGravity=AVLayerVideoGravity.resizeAspectFill;
            
            NotificationCenter.default.addObserver(self, selector: #selector(SplashScreen.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
            addChild(videoPlayer)
            view.addSubview(videoPlayer.view)
            video.play()
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

        //Get our video view
        let video = view.subviews[0]
        
        //Add this subview to view hierarchy
        view.addSubview(vc.view)
        view.bringSubviewToFront(vc.view)
        
        UIView.animate(withDuration: 1, animations: {
            video.alpha = 0
            vc.view.alpha = 1
        })
        {
            _ in
            self.present(vc, animated: false, completion: nil)
        }
        
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

