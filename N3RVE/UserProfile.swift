//
//  UserProfile.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class UserProfile: UIViewController {
    
    var pfp: UIImage? = nil
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDocument()
    }

    @IBAction func backToMenu(_ sender: Any) {
        performSegue(withIdentifier: "backToMenu", sender: self)
    }
    
    private func getDocument() {
         //Get sspecific document from current user
         let docRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")

         // Get data
         docRef.getDocuments { (querySnapshot, err) in
             if let err = err {
                 print(err.localizedDescription)
                 return
             } else if querySnapshot!.documents.count != 1 {
                 print("More than one documents or none")
             } else {
                 for document in querySnapshot!.documents {
                    let username = document.get("username") as! String
                    let firstAndLastName = document.get("firstandlastname") as! String
                    let email = document.get("email") as! String
                    self.usernameLabel.text = "@\(username)"
                    self.nameLabel.text = "\(firstAndLastName)"
                    self.emailLabel.text = "\(email)"
                 }
            }
         }
     }
}
