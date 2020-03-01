//
//  LoginScreen.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAnalytics
import FirebaseAuth
import Firebase

class HomePage: UIViewController {
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var player: AVPlayer?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
           self.performSegue(withIdentifier: "fromHomePageToHome", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the video from the app bundle.
        let videoURL: NSURL = Bundle.main.url(forResource: "GlitchBackground", withExtension: "mp4")! as NSURL
        
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1

        playerLayer.frame = view.frame

        view.layer.addSublayer(playerLayer)

        player?.play()
            
        //loop video
        NotificationCenter.default.addObserver(self,selector: Selector(("itemDidReachEnd:")),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
        object: player?.currentItem)
        
        }
    func itemDidReachEnd(notification: NSNotification) {
        player?.seek(to: CMTime.zero)
        player?.play()
    
    }
    
    func loopVideo() {
        player!.seek(to: CMTime.zero)
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
        performSegue(withIdentifier: "fromHomePageToLogin", sender: self)
    }
    @IBAction func gotoSignUp(_ sender: Any) {
        performSegue(withIdentifier: "fromHomePageToSignUp", sender: self)
    }
    
}
