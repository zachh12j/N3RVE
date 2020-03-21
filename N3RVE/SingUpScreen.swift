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
    var player: AVPlayer?
    var newUserNoFollowers = 0

    @IBOutlet weak var firstAndLastField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    var DonatorBadge:Bool = false
    var FounderBadge:Bool = false
    var HighRollerBadge:Bool = false
    var isAdmin:Bool = false
    var isCEO:Bool = false
    var isHeadDev:Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func allTextFields()
    {
        firstAndLastField.setLeftPaddingPoints(20)
        firstAndLastField.setRightPaddingPoints(20)
        usernameField.setLeftPaddingPoints(20)
        usernameField.setRightPaddingPoints(20)
        emailField.setLeftPaddingPoints(20)
        emailField.setRightPaddingPoints(20)
        passwordField.setLeftPaddingPoints(20)
        passwordField.setRightPaddingPoints(20)
        repeatPasswordField.setLeftPaddingPoints(20)
        repeatPasswordField.setRightPaddingPoints(20)
        countryField.setLeftPaddingPoints(20)
        countryField.setRightPaddingPoints(20)
        ageField.setLeftPaddingPoints(20)
        ageField.setRightPaddingPoints(20)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Load the video from the app bundle.
        let videoURL: NSURL = Bundle.main.url(forResource: "BackgroundVid", withExtension: "mp4")! as NSURL
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        //player?.play()
        allTextFields()
    }
    
    //END VIEWDIDLOAD
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(SingUpScreen.finishBackgroundVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
  
    @IBAction func signUpTapped(_ sender: Any)
    {
    if passwordField.text != repeatPasswordField.text
    {
        let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
        else
        {
            let firstName = firstAndLastField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let country = countryField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let AgeOfUser = Int(ageField.text!)
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!)
            {
                (user, error) in
                //It's fine has passes
                if error == nil && AgeOfUser! >= 18
                {
                    self.performSegue(withIdentifier: "signUpDone", sender: self)
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
            
                    db.collection("users").addDocument(data: ["firstandlastname":firstName,
                                                              "username":username,
                                                              "uid": user!.user.uid,
                                                              "email":email,
                                                              "currentFollowers":self.newUserNoFollowers,
                                                              "country":country,
                                                              "age":AgeOfUser!,
                                                              "DonatorBadge": self.DonatorBadge,
                                                              "FounderBadge": self.FounderBadge,
                                                              "HighRollerBadge": self.HighRollerBadge,
                                                              "isAdmin":self.isAdmin,
                                                              "isCEO":self.isCEO,
                                                              "isHeadDev":self.isHeadDev])
                    {
                        (error) in
                if error != nil
                        {
                            // Show error message
                            print("Error")
                        }
                    }
                }
                else
                {
                    let alertController = UIAlertController(title: "You must be 18 and oler to play N3RVE", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    //END SIGNUPTAPPED
    @objc func finishBackgroundVideo(notification: NSNotification)
    {
            if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    @IBAction func backToHome(_ sender: Any) {
        performSegue(withIdentifier: "fromSignUpToHomePage", sender: self)
    }
    
