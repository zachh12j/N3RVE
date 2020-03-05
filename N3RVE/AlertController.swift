//
//  AlertController.swift
//  N3RVE
//
//  Created by Camilo Rossi on 2020-03-05.
//  Copyright © 2020 Camilo Rossi. All rights reserved.
//

import Foundation

class AlertController: UIAlertController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }

}
