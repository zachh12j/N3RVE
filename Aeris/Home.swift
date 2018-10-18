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
    
    @IBOutlet var imageView: UIImageView!
    
        let selection = UISelectionFeedbackGenerator()
    
    @IBAction func fromHomeToCategories(_ sender: Any) {
        self.performSegue(withIdentifier: "fromHomeToCategories", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    @IBAction func fromHomeToSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "fromHomeToSettings", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Background Music
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "BackgroundMusic", ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.volume = 0.5
        AudioPlayer.play()
        
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

