//
//  OtherUserProfile.swift
//  N3RVE
//
//  Created by Camilo Rossi on 2020-03-04.
//  Copyright © 2020 Camilo Rossi. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class OtherUserProfile: UIViewController {

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var player: AVPlayer?
    var peopleFollowing = 0
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(OtherUserProfile.finishBackgroundVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.setLeftPaddingPoints(20)
        searchField.setRightPaddingPoints(20)
        self.hideKeyboardWhenTappedAround()
        
        //        LOAD VIDEO
        
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
        player?.play()
    }
    
    @IBAction func searchForUser(_ sender: Any) {
        let searchRef = Firestore.firestore().collection("users").whereField("username", isEqualTo: searchField.text ?? nil!)
        
        // Get data
        searchRef.getDocuments { (querySnapshot, err) in
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
                   self.nameLabel.text = "\(firstAndLastName)"
                    self.usernameLabel.text = "@\(username)"
                    self.emailLabel.text = "\(email)"
                }
           }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "searchUserToUser", sender: self)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func finishBackgroundVideo(notification: NSNotification)
    {
            if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    @IBAction func followUser(_ sender: Any) {
//        let db = Firestore.firestore().collection("users").whereField("username", isEqualTo: usernameLabel.text ?? nil!)
//
//        // Set the "capital" field of the city 'DC'
//        db.collection("users").update({
//            capital: true
//        }, merge: true);
        
        
        _ = Firestore.firestore().collection("users").whereField("username", isEqualTo: usernameLabel.text!).getDocuments() { (querySnapshot, err) in
            if err != nil {
                // Some error occured
            } else if querySnapshot!.documents.count != 1 {
                // Perhaps this is an error for you?
            } else {
                let document = querySnapshot!.documents.first
                document!.reference.updateData([
                    "currentFollowers": 99
                ])
            }
        }
        
        followButton.isHidden = true
    }
    
}
