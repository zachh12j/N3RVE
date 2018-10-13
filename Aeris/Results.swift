//
//  Results.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit

class Results: UIViewController {
    @IBOutlet var fromResultsToHome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first as! UITouch
        
        if (touch.view == fromResultsToHome)
        {
            self.performSegue(withIdentifier: "fromResultsToHome", sender: self)
        }
        
    }
    
    
}
