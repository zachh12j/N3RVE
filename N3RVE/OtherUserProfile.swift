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

    @IBOutlet weak var unfollowButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var player: AVPlayer?
    var peopleFollowing = 0
    var hasTappedOnFollow = Bool()
    var getsFollowedUid = String()
    var IsDonator = Bool()
    var IsFounder = Bool()
    var IsHighRoller = Bool()
    var isAdmin = Bool()
    var isCEO = Bool()
    var isHeadDev = Bool()
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(OtherUserProfile.finishBackgroundVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.setLeftPaddingPoints(20)
        searchField.setRightPaddingPoints(20)
        self.hideKeyboardWhenTappedAround()
        hasTappedOnFollow = false
        followButton.isHidden = true
        unfollowButton.isHidden = true
        
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
        //player?.play()
    }
    
    @IBAction func searchForUser(_ sender: Any) {
        self.followButton.isHidden = false
        let searchRef = Firestore.firestore().collection("users").whereField("username", isEqualTo: searchField.text ?? nil!)
        
        // Get data
        searchRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            } else
            if querySnapshot!.documents.count != 1
            {
                let alertController = UIAlertController(title: "Oops!", message: "Seems like there is no user on our database matching this username!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                for document in querySnapshot!.documents {

                    let docId = document.documentID
                    let userID = document.get("uid") as! String
                    let username = document.get("username") as! String
                    let firstAndLastName = document.get("firstandlastname") as! String
                    let pplFollowing = document.get("currentFollowers") as! Int
                    let DonatorBadge = document.get("DonatorBadge") as! Bool
                    let FounderBadge = document.get("FounderBadge") as! Bool
                    let HighRollerBadge = document.get("HighRollerBadge") as! Bool
                    let HeadDev = document.get("isHeadDev") as! Bool
                    let Admin = document.get("isAdmin") as! Bool
                    let CEO = document.get("isCEO") as! Bool
                    self.followersLabel.text = "\(pplFollowing)"
                    self.nameLabel.text = "\(firstAndLastName)"
                    self.usernameLabel.text = "@\(username)"
                    
                    self.peopleFollowing = pplFollowing
                    self.getsFollowedUid = docId
                    self.IsDonator = DonatorBadge
                    self.IsFounder = FounderBadge
                    self.IsHighRoller = HighRollerBadge
                    self.isCEO = CEO
                    self.isAdmin = Admin
                    self.isHeadDev = HeadDev
                    
                    if self.IsDonator == true
                    {
                        print("This user is a Donator")
                    }
                    if self.IsFounder == true
                    {
                        print("This user is a Founder")
                    }
                    if self.IsHighRoller == true
                    {
                        print("This user is a High Roller")
                    }
                    if self.isHeadDev == true
                    {
                        print("You're actually the head dev...")
                    }
                    if self.isCEO == true
                    {
                        print("Welcome, CEO of N3RVE B)")
                    }
                    if self.isAdmin == true
                    {
                        print("Oh hey you guys!")
                    }
                    
                    let db = Firestore.firestore()
                    if let userId = Auth.auth().currentUser?.uid
                    {
                        db.collection("users").document(userId).collection("username").addSnapshotListener
                        {
                            (snapshot, error ) in
                        }
                        if userID == userId
                        {
                            self.performSegue(withIdentifier: "searchUserToUser", sender: self)
                        }
                    }
                }
           }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "searchUserToUser", sender: self)
    }

    @objc func finishBackgroundVideo(notification: NSNotification)
    {
            if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    
    
    @IBAction func followUser(_ sender: Any)
    {
        self.followButton.isHidden = true
        self.unfollowButton.isHidden = false
        hasTappedOnFollow = true
        print(self.getsFollowedUid)
        let db = Firestore.firestore()
        self.followersLabel.text = "\(peopleFollowing+1)"

        if let userId = Auth.auth().currentUser?.uid
        {
                db.collection("users").document(userId).collection("currentFollowers").addSnapshotListener
            { (snapshot, error ) in
                
                let docsRef = db.collection("users").document(self.getsFollowedUid)
                // Set the "capital" field of the city 'DC'
                docsRef.updateData([
                    "currentFollowers": self.peopleFollowing+1
            ]) { err in
                    if let err = err
                    {
                        print("Error updating document: \(err)")
                    }
                    else
                    {
                        print("Document successfully updated")
                    }
                }
            }
        }
    }
    
    @IBAction func unfollowUser(_ sender: Any)
    {
            self.followButton.isHidden = false
            self.unfollowButton.isHidden = true
        print(self.getsFollowedUid)
        let db = Firestore.firestore()
            self.followersLabel.text = "\(peopleFollowing)"

            if let userId = Auth.auth().currentUser?.uid {db.collection("users").document(userId).collection("currentFollowers").addSnapshotListener { (snapshot, error ) in
                
                let docsRef = db.collection("users").document(self.getsFollowedUid)
                // Set the "capital" field of the city 'DC'
                docsRef.updateData([
                    "currentFollowers": self.peopleFollowing
                ])
                {
                    err in
                    if let err = err
                    {
                        print("Error updating document: \(err)")
                    }
                    else
                    {
                        print("Document successfully updated")
                    }
                }
            }
        }

    }
    
}
