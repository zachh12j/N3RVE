//
//  Categories.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit

class Categories: UIViewController {
    
    @IBOutlet var Category1: UIView!
    @IBOutlet var Category2: UIView!
    @IBOutlet var Category3: UIView!
    @IBOutlet var Category4: UIView!
    @IBOutlet var Category5: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Category1
        Category1.layer.cornerRadius = 20.0
        Category1.layer.shadowColor = UIColor.gray.cgColor
        Category1.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Category1.layer.shadowRadius = 12.0
        Category1.layer.shadowOpacity = 0.7
        
        //Category2
        Category2.layer.cornerRadius = 20.0
        Category2.layer.shadowColor = UIColor.gray.cgColor
        Category2.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Category2.layer.shadowRadius = 12.0
        Category2.layer.shadowOpacity = 0.7
        
        //Category3
        Category3.layer.cornerRadius = 20.0
        Category3.layer.shadowColor = UIColor.gray.cgColor
        Category3.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Category3.layer.shadowRadius = 12.0
        Category3.layer.shadowOpacity = 0.7
        
        //Category4
        Category4.layer.cornerRadius = 20.0
        Category4.layer.shadowColor = UIColor.gray.cgColor
        Category4.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Category4.layer.shadowRadius = 12.0
        Category4.layer.shadowOpacity = 0.7
        
        //Category5
        Category5.layer.cornerRadius = 20.0
        Category5.layer.shadowColor = UIColor.gray.cgColor
        Category5.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        Category5.layer.shadowRadius = 12.0
        Category5.layer.shadowOpacity = 0.7
    }
    
    
}
