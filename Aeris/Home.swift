//
//  ViewController.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit

class Home: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
        let selection = UISelectionFeedbackGenerator()
    
    @IBAction func fromHomeToCategories(_ sender: Any) {
        self.performSegue(withIdentifier: "fromHomeToCategories", sender: self)
        selection.selectionChanged()
    }
    @IBAction func fromHomeToSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "fromHomeToSettings", sender: self)
        selection.selectionChanged()
    }
    
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
}

