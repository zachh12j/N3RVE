//
//  ViewController.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation

class Home: UIViewController {
    
    var player: AVAudioPlayer?
    var AudioPlayer = AVAudioPlayer()
    var MusicPLaying = false
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    @IBOutlet weak var instagramButton: UIButton!
    
        let selection = UISelectionFeedbackGenerator()
    
    @IBAction func fromHomeToCategories(_ sender: Any) {
        self.performSegue(withIdentifier: "fromHomeToCategory1", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    @IBAction func fromHomeToSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "fromHomeToSettings", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let theURL = Bundle.main.url(forResource: "BackgroundVideo", withExtension: "mp4")

        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none

        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = UIColor.clear;
        view.layer.insertSublayer(avPlayerLayer, at: 0)

        NotificationCenter.default.addObserver(self,
                                               selector: Selector(("playerItemDidReachEnd:")),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: avPlayer.currentItem)
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.play()
        paused = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
    
    @IBAction func didTapInsta(_ sender: Any) {
        if let url = URL(string: "http://instagram.com/n3rve_app/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func didTapFacebook(_ sender: Any) {
        if let url = URL(string: "https://vm.tiktok.com/bKPSun/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func didTapSnapchat(_ sender: Any) {
        if let url = URL(string: "http://facebook.com/camilo.jrossi") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    let url = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3")!
    
    

    func buttonClickSound() {
        let url = Bundle.main.url(forResource: "button", withExtension: "wav")!
        
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

