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
    
    var noCorrect = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the results
        lblResults.text = "You got \(noCorrect) out of \(total) correct"
        
        // Calculate the percentage of quesitons you got right
        var percentRight = Double(noCorrect) / Double(total)
        percentRight *= 100
        
        // Based on the percentage of questions you got right present the user with different message
        var title = ""
        if(percentRight < 40) {
            title = "Not Good"
        } else if(percentRight < 70) {
            title = "Almost"
        } else {
            title = "Good Job"
        }
        lblTitle.text = title
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
