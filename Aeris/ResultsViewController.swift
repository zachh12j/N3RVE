//
//  ResultsViewController.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblResults: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var noCorrect = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.sendSubviewToBack(imageView);
        //Parallax background
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
        
        // Calculate the percentage of quesitons you got right
        var percentRight = Double(noCorrect) / Double(total)
        percentRight *= 100
        
        // Based on the percentage of questions you got right present the user with different message
        var title = ""
        if(percentRight < 40) {
            title = "Presque!"
        } else if(percentRight < 70) {
            title = "Bravo!"
        } else {
            title = "Superbe!"
        }
        if(percentRight == 100){
            title = "Parfait!"
        }
        lblTitle.text = title
        lblTitle.numberOfLines = 0
        lblResults.sizeToFit()
        
        // Set the results
        lblResults.text = "Vous avec obtenu un résultat de \(percentRight)%. Vous avez donc répondu correctement à \(noCorrect) questions sur \(total)."
    }

    @IBAction func fromResultsToCategories(_ sender: Any) {
        self.performSegue(withIdentifier: "fromResultsToCategories", sender: self)
    }
    
}
