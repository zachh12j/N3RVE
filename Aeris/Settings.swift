//
//  Settings.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-14.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import SpriteKit
import UIKit

class Settings: UIViewController {
    
    @IBOutlet var animationView: UIImageView!
    
    var images: [UIImage]!
    
    var animatedImage: UIImage!
    
    var loading_1: UIImage!
    var loading_2: UIImage!
    var loading_3: UIImage!
    var loading_4: UIImage!
    var loading_5: UIImage!
    var loading_6: UIImage!
    var loading_7: UIImage!
    var loading_8: UIImage!
    var loading_9: UIImage!
    var loading_10: UIImage!
    var loading_11: UIImage!
    var loading_12: UIImage!
    var loading_13: UIImage!
    var loading_14: UIImage!
    var loading_15: UIImage!
    var loading_16: UIImage!
    var loading_17: UIImage!
    var loading_18: UIImage!
    var loading_19: UIImage!
    var loading_20: UIImage!
    var loading_21: UIImage!
    var loading_22: UIImage!
    var loading_23: UIImage!
    var loading_24: UIImage!
    var loading_25: UIImage!
    var loading_26: UIImage!
    var loading_27: UIImage!
    var loading_28: UIImage!
    var loading_29: UIImage!
    var loading_30: UIImage!
    var loading_31: UIImage!
    var loading_32: UIImage!
    var loading_33: UIImage!
    var loading_34: UIImage!
    var loading_35: UIImage!
    var loading_36: UIImage!
    var loading_37: UIImage!
    var loading_38: UIImage!
    var loading_39: UIImage!
    var loading_40: UIImage!
    var loading_41: UIImage!
    var loading_42: UIImage!
    var loading_43: UIImage!
    var loading_44: UIImage!
    var loading_45: UIImage!
    var loading_46: UIImage!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loading_1 = UIImage(named: "01.jpg")
        loading_2 = UIImage(named: "02.jpg")
        loading_3 = UIImage(named: "03.jpg")
        loading_4 = UIImage(named: "04.jpg")
        loading_5 = UIImage(named: "05.jpg")
        loading_6 = UIImage(named: "06.jpg")
        loading_7 = UIImage(named: "07.jpg")
        loading_8 = UIImage(named: "08.jpg")
        loading_9 = UIImage(named: "09.jpg")
        loading_10 = UIImage(named: "010.jpg")
        loading_11 = UIImage(named: "011.jpg")
        loading_12 = UIImage(named: "012.jpg")
        loading_13 = UIImage(named: "013.jpg")
        loading_14 = UIImage(named: "014.jpg")
        loading_15 = UIImage(named: "015.jpg")
        loading_16 = UIImage(named: "016.jpg")
        loading_17 = UIImage(named: "017.jpg")
        loading_18 = UIImage(named: "018.jpg")
        loading_19 = UIImage(named: "019.jpg")
        loading_20 = UIImage(named: "020.jpg")
        loading_21 = UIImage(named: "021.jpg")
        loading_22 = UIImage(named: "022.jpg")
        loading_23 = UIImage(named: "023.jpg")
        loading_24 = UIImage(named: "024.jpg")
        loading_25 = UIImage(named: "025.jpg")
        loading_26 = UIImage(named: "026.jpg")
        loading_27 = UIImage(named: "027.jpg")
        loading_28 = UIImage(named: "028.jpg")
        loading_29 = UIImage(named: "029.jpg")
        loading_30 = UIImage(named: "030.jpg")
        loading_31 = UIImage(named: "031.jpg")
        loading_32 = UIImage(named: "032.jpg")
        loading_33 = UIImage(named: "033.jpg")
        loading_34 = UIImage(named: "034.jpg")
        loading_35 = UIImage(named: "035.jpg")
        loading_36 = UIImage(named: "036.jpg")
        loading_37 = UIImage(named: "037.jpg")
        loading_38 = UIImage(named: "038.jpg")
        loading_39 = UIImage(named: "039.jpg")
        loading_40 = UIImage(named: "040.jpg")
        loading_41 = UIImage(named: "041.jpg")
        loading_42 = UIImage(named: "042.jpg")
        loading_43 = UIImage(named: "043.jpg")
        loading_44 = UIImage(named: "044.jpg")
        loading_45 = UIImage(named: "045.jpg")
        loading_46 = UIImage(named: "046.jpg")
        
        images = [loading_1, loading_2, loading_3, loading_4, loading_5, loading_6, loading_7, loading_8, loading_9, loading_10, loading_11, loading_12, loading_13, loading_14, loading_15, loading_16, loading_17, loading_18, loading_19, loading_20, loading_21, loading_22, loading_23, loading_24, loading_25, loading_26, loading_27, loading_28, loading_29, loading_30, loading_31, loading_32, loading_33, loading_34, loading_35, loading_36, loading_37, loading_38, loading_39, loading_40, loading_41, loading_42, loading_43, loading_44, loading_45, loading_46]
        
        animatedImage = UIImage.animatedImage(with: images, duration: 2.5)
        
        animationView.image = animatedImage
    }
}
