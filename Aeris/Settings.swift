//
//  Settings.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-14.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class Settings: UIViewController {
    
    var player: AVAudioPlayer?
    
    let notification = UINotificationFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    
    @IBAction func fromSettingsToHome(_ sender: Any) {
        performSegue(withIdentifier: "fromSettingsToHome", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    @IBOutlet var imageView: UIImageView!
    var avPlayer: AVPlayer!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.sendSubviewToBack(imageView);
        
        let min = CGFloat(-30)
        let max = CGFloat(30)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        
        imageView.addMotionEffect(motionEffectGroup)
    }
    
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
