//
//  Category2.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit

class Category2: UIViewController {
    @IBOutlet var ShowResults: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first as! UITouch
        
        if (touch.view == ShowResults)
        {
            self.performSegue(withIdentifier: "fromCategory2ToResults", sender: self)
        }
        
    }
    
}

