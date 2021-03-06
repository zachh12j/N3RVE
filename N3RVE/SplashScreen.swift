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
    var isMusicPlaying = 0
    var counter = 6
    @IBOutlet weak var containerView: UIView!
    
    var videoPlayer = AVPlayerViewController()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            counter -= 1
        } else {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if let path = Bundle.main.path(forResource: "SplashScreenAndSound", ofType: "mp4")
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
    /*
    deinit {
        print("Remove NotificationCenter Deinit")
        NotificationCenter.default.removeObserver(self)
    }
    */
    @objc func finishVideo()
    {
        /*
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomePage") as UIViewController
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
        */
        
        let HomePageVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "HomePage") as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = HomePageVC
        muteSound()
    }
    
     func muteSound()
    {
        if isMusicPlaying == 0{
        print("Music has not been started")
        //Music
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "BackgroundMusic", ofType: "wav")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.volume = 0.15
//        AudioPlayer.play()
        isMusicPlaying = 1
        }
        
        /*
        if AudioPlayer.isPlaying == true {
        isMusicPlaying = 1
        print("Music is currently playing")
        }
        */
    }
    
    func stopMusic(){
        if isMusicPlaying == 1 {
        print("Music is currently playing2")
        } else {
            print("Music is at its inital state")
            AudioPlayer.stop()
        }
    }
    
}

