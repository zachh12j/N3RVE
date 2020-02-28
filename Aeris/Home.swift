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
    
    @IBOutlet var imageView: UIImageView!
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
        
        self.view.sendSubviewToBack(imageView);
        
        let detailVC = UIViewController()
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        
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
    
    @IBAction func didTapInsta(_ sender: Any) {
        if let url = URL(string: "http://instagram.com/camilo.jrossi/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func didTapFacebook(_ sender: Any) {
        if let url = URL(string: "http://facebook.com/camilo.jrossi") {
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

