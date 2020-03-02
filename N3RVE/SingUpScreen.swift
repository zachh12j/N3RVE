//
//  LoginScreen.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import Firebase

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

@available(iOS 13.0, *)
class SingUpScreen: UIViewController {
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    

    @IBOutlet weak var firstAndLastField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        /*PLACEHOLDERS
        nameField.attributedPlaceholder = NSAttributedString(string: "NAME",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        */
        
        let theURL = Bundle.main.url(forResource: "GlitchBackground", withExtension: "mp4")

        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none

        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = UIColor.clear;
        view.layer.insertSublayer(avPlayerLayer, at: 0)

        NotificationCenter.default.addObserver(self,
                                               selector: Selector(("playerItemDidReachEnd:")),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: avPlayer.currentItem)
        avPlayer.play()

    }
    
    //END VIEWDIDLOAD
    
    
  
    @IBAction func signUpTapped(_ sender: Any) {
    if passwordField.text != repeatPasswordField.text {
    let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
            }
    else{
        
        let firstName = firstAndLastField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let username = usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
    Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!){ (user, error) in
     //It's fine has passes
        if error == nil {
       self.performSegue(withIdentifier: "fromSignupPageToHome", sender: self)
        
            
            // User was created successfully, now store the first name and last name
            let db = Firestore.firestore()
            
            db.collection("users").addDocument(data: ["firstandlastname":firstName, "username":username, "uid": user!.user.uid ]) { (error) in
                
                
                if error != nil {
                    // Show error message
                    print("Error")
            
                        }
                }
        }
    //Check for
     else{
       let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        }
                }
          }
        
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
}
