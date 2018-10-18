//
//  Categories.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation

class Categories: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    
    let notification = UINotificationFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    
    @IBAction func fromCategoriestoHome(_ sender: Any) {
        self.performSegue(withIdentifier: "fromCategoriesToHome", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    @IBAction func fromCategoriesToCategory1(_ sender: Any) {
        self.performSegue(withIdentifier: "fromCategoriesToCategory1", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    @IBAction func fromCategoriesToCategory2(_ sender: Any) {
        self.performSegue(withIdentifier: "fromCategoriesToCategory2", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    @IBAction func fromCategoriesToCategory3(_ sender: Any) {
        self.performSegue(withIdentifier: "fromCategoriesToCategory3", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    @IBAction func fromCategoriesToCategory4(_ sender: Any) {
        self.performSegue(withIdentifier: "fromCategoriesToCategory4", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    @IBAction func fromCategoriesToCategory5(_ sender: Any) {
        self.performSegue(withIdentifier: "fromCategoriesToCategory5", sender: self)
        selection.selectionChanged()
        buttonClickSound()
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
