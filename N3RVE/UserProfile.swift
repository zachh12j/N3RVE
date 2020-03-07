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
import FirebaseCoreDiagnostics

class UserProfile: UIViewController, UIImagePickerControllerDelegate{
    
    
    @IBOutlet weak var pfp: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var player: AVPlayer?
    
    let imagePicker = UIImagePickerController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
//        LOAD VIDEO
        
        // Load the video from the app bundle.
        /*
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
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDocument()
        NotificationCenter.default.addObserver(self, selector: #selector(UserProfile.finishBackgroundVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    @IBAction func backToMenu(_ sender: Any) {
        performSegue(withIdentifier: "backToHome", sender: self)
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
                    let followers = document.get("currentFollowers") as! Int
                    let country = document.get("country") as! String
                    self.usernameLabel.text = "@\(username)"
                    self.nameLabel.text = "\(firstAndLastName)"
                    self.emailLabel.text = "\(email)"
                    self.followersLabel.text = "\(followers) FOLLOWERS"
                    self.countryLabel.text = "\(country)"
                 }
            }
         }
     }
    @IBAction func searchForUserTapped(_ sender: Any) {
        performSegue(withIdentifier: "fromUserToSearchUser", sender: self)
    }
    
    @objc func finishBackgroundVideo(notification: NSNotification)
    {
            if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
}
