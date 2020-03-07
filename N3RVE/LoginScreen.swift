//
//  LoginScreen.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAnalytics
import FirebaseAuth
import Firebase

// Put this piece of code anywhere you like

class LoginScreen: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var player: AVPlayer?
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(HomePage.finishBackgroundVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewDidLoad() {
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
        
        emailField.setLeftPaddingPoints(20)
        emailField.setRightPaddingPoints(20)
        passwordField.setLeftPaddingPoints(20)
        passwordField.setRightPaddingPoints(20)
    }
    
    //Fin ViewDidLoad
    @objc func finishBackgroundVideo(notification: NSNotification)
    {
            if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        // TODO: Validate Text Fields
        
        // Create cleaned versions of the text field
        _ = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        _ = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                let alertController = UIAlertController(title: "Oops! Something went wrong", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                               
                 alertController.addAction(defaultAction)
                 self.present(alertController, animated: true, completion: nil)
            }
            else {
                
                self.performSegue(withIdentifier: "fromLoginToHome", sender: self)
                
            }
        }
    }
    
    @IBAction func backToMenu(_ sender: Any) {
        performSegue(withIdentifier: "fromLoginToHomePage", sender: self)
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
