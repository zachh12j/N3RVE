//
//  PlayerViewController.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, BambuserPlayerDelegate {
    var bambuserPlayer: BambuserPlayer
    var playButton: UIButton
    var pauseButton: UIButton
    var rewindButton: UIButton

    required init?(coder aDecoder: NSCoder) {
        bambuserPlayer = BambuserPlayer()
        playButton = UIButton(type: UIButton.ButtonType.system)
        pauseButton = UIButton(type: UIButton.ButtonType.system)
        rewindButton = UIButton(type: UIButton.ButtonType.system)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bambuserPlayer.delegate = self
        bambuserPlayer.applicationId = "9RX2zwlVLQX9OtdgQ6aQnQ"
    bambuserPlayer.playVideo("https://cdn.bambuser.net/broadcasts/833a0ace-a09e-4634-bde9-3ff0c01a5518?da_signature_method=HMAC-SHA256&da_id=9e1b1e83-657d-7c83-b8e7-0b782ac9543a&da_timestamp=1583360983&da_static=1&da_ttl=0&da_signature=dcc8818706bc96f5b69d390133b26d46b34fc2a6a590e59065b07f0692728d9b")
        self.view.addSubview(bambuserPlayer)
        playButton.setTitle("Play", for: UIControl.State.normal)
        playButton.addTarget(bambuserPlayer, action: #selector(BambuserPlayer.playVideo as (BambuserPlayer) -> () -> Void), for: UIControl.Event.touchUpInside)
        self.view.addSubview(playButton)
        pauseButton.setTitle("Pause", for: UIControl.State.normal)
        pauseButton.addTarget(bambuserPlayer, action: #selector(BambuserPlayer.pauseVideo as (BambuserPlayer) -> () -> Void), for: UIControl.Event.touchUpInside)
        self.view.addSubview(pauseButton)
        rewindButton.setTitle("Rewind", for: UIControl.State.normal)
        rewindButton.addTarget(self, action: #selector(PlayerViewController.rewind), for: UIControl.Event.touchUpInside)
        self.view.addSubview(rewindButton)
    }

    @objc func rewind() {
        bambuserPlayer.seek(to: 0.0);
    }

    override func viewWillLayoutSubviews() {
        let statusBarOffset:CGFloat
        if #available(iOS 11.0, *) {
            statusBarOffset = self.view.safeAreaInsets.top
        } else {
            statusBarOffset = self.topLayoutGuide.length
        }
        bambuserPlayer.frame = CGRect(x: 0, y: 0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        playButton.frame = CGRect(x: 20, y: 20 + statusBarOffset, width: 100, height: 40)
        pauseButton.frame = CGRect(x: 20, y: 80 + statusBarOffset, width: 100, height: 40)
        rewindButton.frame = CGRect(x: 20, y: 140 + statusBarOffset, width: 100, height: 40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func playbackStatusChanged(_ status: BambuserPlayerState) {
        switch status {
        case kBambuserPlayerStatePlaying:
            playButton.isEnabled = false
            pauseButton.isEnabled = true
            break

        case kBambuserPlayerStatePaused:
            playButton.isEnabled = true
            pauseButton.isEnabled = false
            break

        case kBambuserPlayerStateStopped:
            playButton.isEnabled = true
            pauseButton.isEnabled = false
            break

        case kBambuserPlayerStateError:
            NSLog("Failed to load video for %@", bambuserPlayer.resourceUri);
            break

        default:
            break
        }
    }
}
